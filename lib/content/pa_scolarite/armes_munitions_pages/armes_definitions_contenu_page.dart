import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaArmesDefinitionsPage extends StatelessWidget {
  const PaArmesDefinitionsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/armes_munitions_pages/armes_definitions';

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
    final Color cardCP = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCSI = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardOther = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
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
            "Définitions",
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
            title: "Textes de référence (élément légal)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Code pénal : "),
                TextSpan(
                  text: "article 132-75 du C.P.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: "Code de la sécurité intérieure : "),
                TextSpan(
                  text: "article R. 311-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Ces définitions permettent de qualifier juridiquement ce qu’est une arme, une munition, "
                "un élément d’arme, ainsi que certaines activités liées aux armes.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I - Code pénal
          _ConditionCard(
            title: "I — Définitions des armes par le Code pénal",
            cardColor: cardCP,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Arme par nature"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 132-75 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : « Est une arme tout objet conçu pour tuer ou blesser. »",
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle("B) Arme par usage / par destination"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 132-75 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : « Tout autre objet susceptible de présenter un danger pour les personnes est assimilé à une arme dès lors "
                      "qu’il est utilisé pour tuer, blesser ou menacer, ou qu’il est destiné par celui qui en est porteur à tuer, blesser ou menacer. »",
                ),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 132-75 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : est assimilé à une arme tout objet ressemblant à une arme « par nature » au point de créer une confusion, "
                      "lorsqu’il est utilisé (ou destiné) pour menacer de tuer ou de blesser.",
                ),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 132-75 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : l’utilisation d’un animal pour tuer, blesser ou menacer est assimilée à l’usage d’une arme "
                      "(le tribunal peut décider du sort de l’animal dans certains cas).",
                ),
              ]),
              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "À retenir : un objet peut être une arme soit parce qu’il est conçu pour blesser (arme par nature), "
                        "soit parce qu’il est utilisé/destiné à blesser ou menacer (arme par destination/usage), "
                        "même s’il n’est pas une arme « au départ ».",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II - CSI : Armes par nature & munitions (R.311-1)
          _ConditionCard(
            title: "II — Définitions par le Code de la sécurité intérieure",
            cardColor: cardCSI,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Au sens de "),
                TextSpan(
                  text: "l’article R. 311-1 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", on entend par :"),
              ]),
              SizedBox(height: 12),

              _SubTitle("A) Armes par nature et munitions"),
              _BulletPoint(
                text:
                    "Arme : tout objet/dispositif conçu ou destiné par nature à tuer, blesser, frapper, neutraliser ou provoquer une incapacité.",
              ),
              _BulletPoint(
                text:
                    "Arme à canon lisse : âme du canon circulaire, ne donnant pas de mouvement de rotation au projectile.",
              ),
              _BulletPoint(
                text:
                    "Arme à canon rayé : âme non circulaire avec rayures (conventionnelles/polygonales) donnant une rotation au projectile.",
              ),
              _BulletPoint(
                text:
                    "Arme à feu : tire un projectile par combustion d’une charge propulsive (ou transformable aisément à cette fin).",
              ),
              _BulletPoint(
                text:
                    "Arme à répétition automatique : se recharge automatiquement et peut, par une seule pression sur la détente, lâcher une rafale.",
              ),
              _BulletPoint(
                text:
                    "Arme à répétition manuelle : rechargée manuellement par introduction d’une munition prélevée dans un système d’alimentation, transportée via un mécanisme.",
              ),
              _BulletPoint(
                text:
                    "Arme à répétition semi-automatique : se recharge automatiquement mais ne peut lâcher plus d’un coup par pression sur la détente.",
              ),
              _BulletPoint(
                text:
                    "Arme à un coup : sans système d’alimentation, chargée avant chaque tir par introduction manuelle de la munition.",
              ),
              _BulletPoint(
                text:
                    "Arme blanche : action perforante/tranchante/brisante due à la force humaine (hors explosion).",
              ),
              _BulletPoint(
                text:
                    "Arme camouflée : arme dissimulée sous la forme d’un autre objet (y compris un autre type d’arme).",
              ),
              SizedBox(height: 10),

              _SubTitle("B) Armes d’épaule / armes de poing"),
              _BulletPoint(
                text:
                    "Arme d’épaule : arme que l’on épaule pour tirer (mesures de longueur selon règles CSI).",
              ),
              _BulletPoint(
                text:
                    "Arme de poing : arme tenue par une poignée à une main et non destinée à être épaulée.",
              ),
              SizedBox(height: 10),

              _SubTitle("C) Armes incapacitantes / neutralisation"),
              _BulletPoint(
                text:
                    "Arme incapacitante (projection/émission) : provoque une incapacité à distance.",
              ),
              _BulletPoint(
                text:
                    "Arme incapacitante de contact : provoque une incapacité à bout touchant.",
              ),
              _BulletPoint(
                text:
                    "Arme neutralisée : rendue définitivement impropre au tir (procédés techniques rendant les éléments inutilisables).",
              ),
              SizedBox(height: 10),

              _SubTitle("D) Munitions et éléments"),
              _BulletPoint(
                text:
                    "Élément d’arme : partie essentielle (canon, carcasse, boîte de culasse, culasse, barillet, systèmes de fermeture, conversion…).",
              ),
              _BulletPoint(
                text:
                    "Élément de munition : projectile, amorce, douille (amorcée/chargée…), etc.",
              ),
              _BulletPoint(
                text:
                    "Munition perforante / explosive / incendiaire / expansive : classifications selon la nature du projectile.",
              ),
              _BulletPoint(
                text:
                    "Systèmes d’alimentation : magasins intégrés, chargeurs, bandes, réservoirs (fixes ou mobiles pendant le tir).",
              ),
              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Ces définitions CSI servent ensuite à appliquer les régimes (catégories A/B/C/D), "
                        "et à qualifier précisément la nature de l’arme/munition dans les procédures.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III - Autres armes / activités / exclusions
          _ConditionCard(
            title: "III — Autres notions importantes (CSI)",
            cardColor: cardOther,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Autres armes (exemples)"),
              _BulletPoint(
                text:
                    "Arme d’alarme et de signalisation : dispositif tirant des munitions à blanc/irritants/pyrotechniques, non transformable aisément pour propulser un projectile (selon arrêté).",
              ),
              _BulletPoint(
                text:
                    "Arme de spectacle : arme à feu transformée pour munitions à blanc (tournages, théâtre…), classée dans sa catégorie d’origine.",
              ),
              _BulletPoint(
                text:
                    "Arme didactique : arme authentique avec mécanismes visibles, sans neutralisation.",
              ),
              _BulletPoint(
                text:
                    "Arme factice : apparence d’une arme à feu expulstant un projectile non métallique < 2 joules.",
              ),
              _BulletPoint(
                text:
                    "Munition inerte : munition factice non transformable en munition active.",
              ),
              _BulletPoint(
                text:
                    "Lanceur de paintball : propulsion non pyrotechnique d’un projectile marquant l’impact.",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Activités en relation avec les armes"),
              _BulletPoint(
                text:
                    "Activité d’intermédiation : rapprochement/organisation de contrats ou transferts d’armes/munitions (courtage, mandat, commission).",
              ),
              _BulletPoint(
                text:
                    "Activité de fabrication : conception, réparation, transformation, assemblage d’armes/éléments/munitions.",
              ),
              _BulletPoint(
                text:
                    "Armurier : activité pro (fabrication, commerce, échange, location, prêt, réparation ou transformation).",
              ),
              _BulletPoint(
                text:
                    "Port d’arme : avoir une arme sur soi utilisable immédiatement.",
              ),
              _BulletPoint(
                text:
                    "Transport d’arme : déplacer une arme en l’ayant auprès de soi, inutilisable immédiatement.",
              ),
              SizedBox(height: 12),

              _SubTitle("C) Ne sont pas des armes (CSI)"),
              _Paragraph.rich([
                TextSpan(text: "Au sens de "),
                TextSpan(
                  text: "l’article R. 311-1 IV du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Objets tirant un projectile / projetant des gaz avec énergie à la bouche inférieure à 2 joules.",
              ),
              _BulletPoint(
                text:
                    "Réducteurs de son : pièces additionnelles ne modifiant pas le fonctionnement de l’arme.",
              ),
              _BulletPoint(
                text:
                    "Objets conçus pour sauvetage, abattage, pêche au harpon, usages industriels/techniques (si usage strictement limité et non détournable).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Résumé final
          _ConditionCard(
            title: "Synthèse",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "• Code pénal : définit l’arme par nature et l’assimilation par usage/destination (et même par ressemblance).\n"
                "• CSI : définit précisément les types d’armes, munitions, éléments, systèmes d’alimentation, et certaines activités.\n"
                "• Bien qualifier l’objet = appliquer le bon régime juridique (catégories A/B/C/D) et sécuriser la procédure.",
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
