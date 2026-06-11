import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaReseauxSociauxPage extends StatelessWidget {
  const PaReseauxSociauxPage({super.key});

  static const String routeName =
      '/pa/institution/deontologie/reseaux_sociaux';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
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
          "Déontologie",
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
            "Soyez vigilants sur les réseaux sociaux",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro / enjeu
          _ConditionCard(
            title: "Pourquoi c’est important ?",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sans le savoir, certains policiers se mettent en danger sur les réseaux sociaux.\n\n"
                "Les réseaux sociaux accélèrent et amplifient la circulation de l’information : "
                "une publication anodine (photo, vidéo, commentaire, partage) peut révéler des éléments "
                "sur votre identité, vos proches, vos habitudes, vos missions ou votre affectation.\n\n"
                "L’usage des réseaux sociaux doit donc être raisonné, avec prudence, bon sens, discrétion "
                "et modération, pour protéger votre sécurité, celle de vos proches, et l’image de l’institution.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre légal en haut (articles en rouge)
          _ConditionCard(
            title: "I — Cadre légal & obligations",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 26 de la loi n° 83-634 du 13 juillet 1983",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : secret professionnel + discrétion professionnelle (faits, informations, documents connus dans l’exercice des fonctions).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-13 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : réprime la révélation d’une information à caractère secret par une personne dépositaire par état, profession, fonction ou mission.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Code de déontologie (Police / Gendarmerie) : ",
                ),
                TextSpan(
                  text:
                      "articles R. 434-2 à R. 434-33 du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " — dignité en toute circonstance, y compris sur les réseaux de communication électronique sociaux.",
                ),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Même sous pseudonyme, vous restez responsable de vos publications : ce que vous écrivez, partagez, commentez ou « likez » peut engager votre responsabilité disciplinaire et/ou pénale.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Risques principaux (sécurité + institution)
          _ConditionCard(
            title: "II — Les risques majeurs",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Risque sécurité (vous + proches)"),
              _BulletPoint(
                text:
                    "Publier des éléments de vie privée (lieux, habitudes, famille) + indices d’appartenance à l’institution peut attirer des personnes mal intentionnées.",
              ),
              _BulletPoint(
                text:
                    "Le danger existe en service comme hors service (et peut viser l’entourage).",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Risque institutionnel (image + neutralité)"),
              _BulletPoint(
                text:
                    "Si vous mentionnez directement ou indirectement votre qualité de policier, vous représentez l’institution auprès de ceux qui vous lisent.",
              ),
              _BulletPoint(
                text:
                    "Neutralité renforcée en période électorale : ne pas s’identifier politiquement ou religieusement au titre de sa qualité d’agent.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le droit à l’oubli n’existe pas sur internet : une diffusion inappropriée est difficile à supprimer et peut causer des préjudices irréparables.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bonnes pratiques (checklist)
          _ConditionCard(
            title:
                "III — Bonnes pratiques (discrétion • prudence • responsabilité)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Protégez votre anonymat"),
              _IntroBullet(
                text:
                    "Utilisez un pseudonyme et évitez toute information personnelle (adresse, habitudes, proches).",
              ),
              _IntroBullet(
                text:
                    "Préservez votre famille : limitez l’exposition de vos proches sur vos contenus.",
              ),
              SizedBox(height: 10),
              _SubTitle("Maîtrisez vos paramètres"),
              _IntroBullet(
                text:
                    "Calibrez strictement la confidentialité (idéalement : famille/amis). Vérifiez régulièrement.",
              ),
              _IntroBullet(
                text: "Désactivez la géolocalisation sur tous vos comptes.",
              ),
              SizedBox(height: 10),
              _SubTitle("Connaissez vos contacts"),
              _IntroBullet(
                text:
                    "N’acceptez pas n’importe qui : surtout pas des inconnus.",
              ),
              SizedBox(height: 10),
              _SubTitle("Préservez votre identité professionnelle"),
              _IntroBullet(
                text:
                    "Ne vous identifiez pas comme policier (tenue, logo, lieu de travail). Attention aux arrière-plans sur photos/vidéos.",
              ),
              _IntroBullet(
                text:
                    "Respectez strictement le secret professionnel : n’évoquez aucune mission en cours ou achevée.",
              ),
              SizedBox(height: 10),
              _SubTitle("Devoir de réserve"),
              _IntroBullet(
                text:
                    "Évitez les prises de position ou publications susceptibles de nuire à l’institution : retenue, neutralité, exemplarité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contenus / publications
          _ConditionCard(
            title: "IV — Avant de publier : check mental",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Est-ce que mon contenu révèle un lieu, une habitude, un proche, une affectation, une mission, un véhicule, un badge, un uniforme, un logo ?",
              ),
              _BulletPoint(
                text:
                    "Est-ce que mon propos peut être lu par un supérieur, un collègue, un adversaire, un journaliste, un justiciable ?",
              ),
              _BulletPoint(
                text:
                    "Est-ce que je suis en train de commenter la hiérarchie, le ministre, ou l’institution ? (à proscrire)",
              ),
              _BulletPoint(
                text:
                    "Est-ce que je respecte neutralité, réserve, discrétion, loyauté, dignité ?",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Même une « blague » ou un contenu supposé privé peut devenir public (captures, partages, piratage).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Menaces / injures : quoi faire
          _ConditionCard(
            title: "V — Menaces / injures : que faire si vous êtes victime ?",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Réflexe immédiat"),
              _BulletPoint(
                text:
                    "Conserver une preuve datée : capture d’écran, impression, export…",
              ),
              _BulletPoint(
                text:
                    "Signaler le compte/contenu via la procédure du réseau social.",
              ),
              SizedBox(height: 10),
              _SubTitle("Si menaces sérieuses"),
              _BulletPoint(text: "Rendre compte en priorité à la hiérarchie."),
              _BulletPoint(
                text: "Déposer plainte pour engager des poursuites.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "À savoir : la plateforme PHAROS dispose d’outils permettant de récupérer certains contenus supprimés. Si le contenu a disparu, vous pouvez le signaler sur la plateforme officielle de signalement.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse
          _ConditionCard(
            title: "En résumé",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Prudence, bon sens, discrétion, modération : votre sécurité et celle de vos proches passent en premier.",
              ),
              _BulletPoint(
                text:
                    "Neutralité et réserve : si vous êtes identifiable comme policier, vous engagez l’institution.",
              ),
              _BulletPoint(
                text:
                    "Internet n’oublie pas : une diffusion inadaptée peut avoir des conséquences durables (disciplinaire/pénal/sécurité).",
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
