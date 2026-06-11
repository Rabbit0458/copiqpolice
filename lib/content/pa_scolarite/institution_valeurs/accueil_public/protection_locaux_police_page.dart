import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaProtectionLocauxPolicePage extends StatelessWidget {
  const PaProtectionLocauxPolicePage({super.key});

  static const String routeName =
      '/pa/institution/accueil_public/protection_locaux';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardOrdinaire = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardAggression = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardIncendie = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
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
          "Accueil du public",
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
            "La protection des locaux de police",
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
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La mission de surveillance des locaux de police exige un haut niveau de vigilance et le respect strict des consignes de sécurité. "
                "L’effectif en poste peut être confronté à tout moment à une situation anormale ou dangereuse : la réaction doit être rapide, coordonnée et conforme aux procédures internes.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Vigilance permanente : personnes, accès, circulations et abords des locaux.",
              ),
              _IntroBullet(
                text:
                    "Ne pas improviser : appliquer les consignes prévues dans les plans de protection.",
              ),
              _IntroBullet(
                text:
                    "Alerter sans délai la hiérarchie en cas de doute ou d’événement anormal.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — SURVEILLANCE ORDINAIRE
          _ConditionCard(
            title: "I — Surveillance ordinaire des locaux",
            cardColor: cardOrdinaire,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Présence de personnes extérieures"),
              _Paragraph(
                "Toute personne extérieure présente dans les locaux doit faire l’objet d’une attention particulière "
                "(risque de vol, dégradations, intrusion, évasion, agression). "
                "Dans la mesure du possible, les déplacements s’effectuent avec un accompagnement du personnel.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Identifier et surveiller : qui, pourquoi, où, avec qui.",
              ),
              _BulletPoint(
                text:
                    "Limiter l’accès : zones strictement nécessaires, circulation encadrée.",
              ),
              _BulletPoint(
                text:
                    "Prévenir les risques : ne pas laisser une personne seule dans des zones sensibles.",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "B) Voies de passage (cours, escaliers, circulations)",
              ),
              _Paragraph(
                "Les voies de passage doivent être surveillées : elles peuvent servir de lieu de dépôt d’objets "
                "(colis, sac oublié…), ou de point de vulnérabilité lors des mouvements de personnes.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Objet suspect",
                bodySpans: [
                  TextSpan(
                    text:
                        "En cas de découverte d’un objet suspect : ne pas toucher. Mettre en place un périmètre de sécurité et aviser immédiatement l’autorité hiérarchique.",
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle("C) Transferts / escortes (détenus, GAV)"),
              _Paragraph(
                "Les circulations sont particulièrement sensibles lors des transferts : risque d’évasion, de résistance active, "
                "ou d’agression contre le personnel.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Surveiller les couloirs/escaliers en amont et pendant les mouvements.",
              ),
              _BulletPoint(
                text:
                    "Éviter les croisements inutiles (public / mis en cause / personnels).",
              ),
              _BulletPoint(
                text:
                    "Anticiper : accès dégagés, portes contrôlées, points de rupture identifiés.",
              ),
              SizedBox(height: 12),

              _SubTitle("D) Abords immédiats des locaux"),
              _Paragraph(
                "Les abords doivent être surveillés afin de déceler tout stationnement dangereux, repérage, "
                "ou toute dégradation/inscription portant atteinte à l’autorité de l’État.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Surveiller les stationnements anormaux (durée, comportement, visibilité sur accès).",
              ),
              _BulletPoint(
                text:
                    "Signaler immédiatement toute dégradation ou inscription.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — PLAN AGGRESSION EXTÉRIEURE
          _ConditionCard(
            title: "II — Plan de protection contre une agression extérieure",
            cardColor: cardAggression,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Un plan de protection à caractère confidentiel doit être prévu pour protéger les locaux contre une agression extérieure. "
                "Il prend la forme d’un dossier regroupant les consignes, connu et consultable par les personnels concernés.",
              ),
              SizedBox(height: 12),

              _SubTitle("Contenu minimal du plan (dossier)"),
              _BulletPoint(text: "Gardes statiques."),
              _BulletPoint(text: "Plantons."),
              _BulletPoint(text: "Patrouilles."),
              _BulletPoint(text: "Signaux conventionnels d’alerte."),
              _BulletPoint(text: "Conduite à tenir en cas d’agression."),
              _BulletPoint(
                text: "Conduite à tenir en cas de tentative d’attentat.",
              ),
              _BulletPoint(
                text: "Règles relatives à l’usage des armes (cadre interne).",
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Vigilance renforcée",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les structures décentralisées (postes de police, antennes…), fermées au public la nuit, week-ends et jours fériés, "
                        "doivent faire l’objet d’une attention particulière en raison de leur vulnérabilité.",
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle("Diffusion & accessibilité"),
              _BulletPoint(
                text:
                    "Les consignes sont communiquées à l’ensemble du personnel.",
              ),
              _BulletPoint(
                text: "Elles doivent pouvoir être consultées à tout moment.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Le plan est établi par chaque chef de circonscription et peut intégrer les mesures prévues dans le cadre de la lutte contre l’incendie.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — PLAN INCENDIE
          _ConditionCard(
            title: "III — Plan de protection contre l’incendie",
            cardColor: cardIncendie,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Un plan de protection contre l’incendie doit également être prévu. "
                "Il s’agit d’un dossier diffusé à l’ensemble du personnel concerné, avec des consignes opérationnelles claires.",
              ),
              SizedBox(height: 12),

              _SubTitle("Le dossier comprend"),
              _BulletPoint(
                text:
                    "Un plan des lieux (implantation des bouches d’incendie à l’extérieur).",
              ),
              _BulletPoint(
                text:
                    "Localisation des lances à incendie et des extincteurs à l’intérieur.",
              ),
              _BulletPoint(
                text:
                    "Consignes d’alerte : procédure interne + appel aux sapeurs-pompiers.",
              ),
              _BulletPoint(text: "Ordre prioritaire d’évacuation."),
              SizedBox(height: 12),

              _NotaBox(
                title: "Affichage",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les consignes (alerte, appel, évacuation) doivent être affichées à proximité de chaque poste de matériel de lutte contre le feu.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mémo opérationnel
          _ConditionCard(
            title: "Mémo opérationnel",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Toujours accompagner autant que possible les personnes extérieures dans les zones internes.",
              ),
              _BulletPoint(
                text:
                    "Objet suspect : ne pas toucher, périmètre de sécurité, avis hiérarchique immédiat.",
              ),
              _BulletPoint(
                text:
                    "Transferts GAV/détenus : surveillance renforcée des circulations, anticiper les points de vulnérabilité.",
              ),
              _BulletPoint(
                text:
                    "Agression extérieure : appliquer le plan confidentiel (signaux, conduite à tenir, sécurité du site).",
              ),
              _BulletPoint(
                text:
                    "Incendie : connaître le plan des lieux, le matériel, et l’ordre d’évacuation.",
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
