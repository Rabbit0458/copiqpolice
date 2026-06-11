import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMiseEnDangerDiffusionInformationsPage extends StatelessWidget {
  const PaMiseEnDangerDiffusionInformationsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/mise_en_danger/mise_en_danger_diffusion_informations';

  static const _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cartes (harmonie visuelle)
    final Color card1 = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color card2 = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color card3 = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color card4 = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color card5 = isDark
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
          "Mise en danger",
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
            "La mise en danger par la diffusion d’informations personnelles",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro pédagogique (propre + concise)
          _ConditionCard(
            title: "Définition",
            cardColor: card5,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Révéler, diffuser ou transmettre (par quelque moyen que ce soit) des informations "
                "relatives à la vie privée, familiale ou professionnelle d’une personne, permettant de "
                "l’identifier ou de la localiser, dans le but de l’exposer (elle ou sa famille) à un risque direct "
                "d’atteinte à la personne ou aux biens, constitue une infraction lorsque l’auteur ne pouvait ignorer ce risque.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ ÉLÉMENT LÉGAL EN HAUT (demandé)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: card1,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Infraction définie et réprimée par "),
                TextSpan(
                  text: "l’article 223-1-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’objectif est notamment de viser des comportements (souvent en ligne) "
                        "qui, sans être une provocation directe ou une complicité, recherchent en pratique "
                        "le même résultat : exposer la personne à un risque direct.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ÉLÉMENT MATÉRIEL
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "A) Révélation / diffusion / transmission (par quelque moyen)",
              ),
              _Paragraph(
                "L’incrimination n’exige pas que la révélation, la diffusion ou la transmission soient publiques. "
                "L’infraction vise particulièrement les réseaux sociaux, mais des moyens plus confidentiels "
                "(courriels, SMS, messageries) peuvent également être concernés.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "La simple réception, la captation ou la détention des informations n’est pas répréhensible.",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "B) Informations de vie privée, familiale ou professionnelle",
              ),
              _Paragraph(
                "Exemples : numéro de téléphone, adresse, informations professionnelles. "
                "Une photographie peut aussi constituer une information personnelle, notamment si elle "
                "a été prise dans un lieu privé à l’insu de la personne.",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Permettant d’identifier ou de localiser"),
              _Paragraph(
                "Les informations doivent permettre d’identifier ou de localiser la personne. "
                "Il peut s’agir d’une personne distincte de celle visée à titre principal par la divulgation.",
              ),
              SizedBox(height: 12),
              _SubTitle("D) Auteur : toute personne"),
              _Paragraph(
                "L’incrimination vise toute personne, y compris un journaliste si la preuve est rapportée d’une "
                "intention de nuire gravement à autrui. Elle n’a toutefois pas pour objet de réprimer la diffusion "
                "d’éléments dans le but d’informer le public, même si ces éléments pourraient être réutilisés par un tiers.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Jurisprudence (mise en valeur)
          _ConditionCard(
            title: "Jurisprudence",
            cardColor: card4,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La diffusion concomitante d’informations sur la qualité de fonctionnaire de police "
                      "dans un contexte visant les forces de l’ordre peut exposer la personne et/ou sa famille "
                      "à un risque direct d’atteinte à la personne ou aux biens. ",
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: "Cass. crim., n° 24-82.090, 11 février 2025",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ÉLÉMENT MORAL
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: card3,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Intention de nuire gravement à autrui"),
              _Paragraph(
                "L’auteur doit avoir l’intention manifeste qu’il soit porté une atteinte grave à la personne, "
                "à ses proches ou à ses biens. L’intention peut être caractérisée par des propos explicites "
                "ou déduite d’un faisceau d’indices.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // CIRCONSTANCES AGGRAVANTES
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: card1,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 223-1-1 alinéa 2 du Code pénal",
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
                    "Victime dépositaire de l’autorité publique, chargée d’une mission de service public, "
                    "titulaire d’un mandat électif public, candidat à un mandat pendant la campagne, ou journaliste "
                    "(au sens de l’art. 2, al. 2, loi du 29 juillet 1881).",
              ),
              _BulletPoint(
                text:
                    "Faits commis dans les mêmes conditions envers le conjoint, ascendant, descendant en ligne directe "
                    "ou toute personne vivant habituellement au domicile de la personne protégée, en raison des fonctions exercées.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 223-1-1 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : victime mineure."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 223-1-1 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : victime présentant une particulière vulnérabilité (âge, maladie, infirmité, déficience, grossesse), "
                      "apparente ou connue de l’auteur.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // RÉPRESSION + tentative/complicité + personnes morales
          _ConditionCard(
            title: "V — Répression",
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. ",
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: "Article 223-1-1 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Qualification aggravée : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. ",
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: "Article 223-1-1 alinéas 2 à 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Responsabilité pénale des personnes morales selon le principe général : ",
                ),
                TextSpan(
                  text: "article 121-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 223-1-1 alinéa 5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : en cas de diffusion par voie de presse, audiovisuelle ou communication au public en ligne, "
                      "application des règles spécifiques de ces matières pour la détermination des responsables.",
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, selon "),
                TextSpan(
                  text: "les articles 121-6 et 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
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
