import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IvressePubliqueManifestePage extends StatelessWidget {
  const IvressePubliqueManifestePage({super.key});

  static const String routeName = '/gpx/intervention/autres/ipm';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
            "Ivresse publique et manifeste (IPM)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / Esprit de la mesure
          _ConditionCard(
            title: "De quoi s’agit-il ?",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’IPM est une mesure de police administrative visant à prévenir les atteintes à l’ordre public "
                "et à protéger la personne en état d’ivresse.\n\n"
                "Toute personne trouvée en état d’ivresse dans un lieu public peut être conduite, après examen médical, "
                "dans un local de police/gendarmerie ou en chambre de sûreté, jusqu’au retour à la raison.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal (textes)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 3341-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : prévoit la conduite (après examen médical) et la retenue jusqu’au retour à la raison, "
                      "et permet la remise sous responsabilité d’un tiers (OPJ/APJ) lorsque l’audition immédiate n’est pas nécessaire.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 3353-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réprime l’ivresse publique et manifeste (contravention de 2ᵉ classe).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Audition libre : notification des droits de ",
                ),
                TextSpan(
                  text: "l’article 61-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (selon le cadre retenu)."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Champ d’application
          _ConditionCard(
            title: "II — Champ d’application (quand c’est une IPM ?)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Conditions"),
              _BulletPoint(
                text:
                    "Ivresse manifeste : évidente, constatable (signes extérieurs, troubles du comportement).",
              ),
              _BulletPoint(
                text:
                    "Ivresse publique : constatée dans un lieu public ou privé ouvert au public (place, route, gare, café…).",
              ),
              SizedBox(height: 10),
              _SubTitle("Appréciation pratique"),
              _Paragraph(
                "L’ivresse s’apprécie indépendamment de toute mesure d’imprégnation alcoolique. "
                "Elle résulte du comportement observé et des signes extérieurs.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Exemples de signes fréquemment relevés : haleine alcoolisée, défaut d’équilibre, élocution bégayante, "
                "propos incohérents, comportement anormal. Ces critères n’ont pas à être tous réunis.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette mesure ne s’applique qu’aux majeurs : les mineurs ne doivent pas être placés en chambre de sûreté.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Conduite à tenir : obligations
          _ConditionCard(
            title: "III — Conduite à tenir (principes)",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Nature de la mesure"),
              _Paragraph(
                "Il s’agit d’une mesure de police administrative : l’objectif est la protection et la prévention des troubles à l’ordre public.",
              ),
              SizedBox(height: 10),
              _SubTitle("Deux obligations fondamentales"),
              _BulletPoint(
                text:
                    "Devoir de protection et d’assistance (personne vulnérable).",
              ),
              _BulletPoint(
                text: "Obligation de rendre compte (CIC + traçabilité).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’équipage doit adapter son intervention à l’état réel de la personne et appliquer les gestes de secourisme si nécessaire.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Une situation qui ressemble à une ivresse peut être un malaise (hypoglycémie/diabète, choc, prise de médicaments…). "
                        "Un policier ne pose pas de diagnostic : prudence + examen médical.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Prise en charge par les policiers
          _ConditionCard(
            title: "IV — Prise en charge par les policiers",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Étapes opérationnelles"),
              _BulletPoint(
                text:
                    "Retirer la personne sans brutalité de la vue du public, sécuriser la situation, palpation de sécurité.",
              ),
              _BulletPoint(
                text:
                    "Rendre compte régulièrement au CIC (contrôle, décision de remise tiers / hôpital / service…).",
              ),
              _BulletPoint(
                text: "Renseigner la main courante informatisée (traçabilité).",
              ),
              SizedBox(height: 12),
              _SubTitle("A) Conduite à l’hôpital (examen médical)"),
              _BulletPoint(
                text:
                    "L’examen médical vérifie si l’état de santé est compatible avec un maintien en locaux de police.",
              ),
              _BulletPoint(
                text:
                    "Si compatible : délivrance d’un certificat médical de non-admission.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Conduite au commissariat / chef de poste"),
              _BulletPoint(
                text:
                    "Mesures de sécurité décidées par le chef de poste (ou sous son contrôle).",
              ),
              _BulletPoint(
                text:
                    "Fouille de sécurité : retirer objets/accessoires pouvant nuire (ceinture, lacets, médicaments…).",
              ),
              _BulletPoint(
                text:
                    "Inventaire + mention sur registre d’écrou (identité + heure de prise en charge).",
              ),
              SizedBox(height: 10),
              _SubTitle("C) Chambre de sûreté (surveillance)"),
              _BulletPoint(
                text:
                    "Surveillance constante + rondes régulières (intervalle max 15 minutes).",
              ),
              _BulletPoint(
                text: "Feuille de rondes : heures, signature, observations.",
              ),
              _BulletPoint(text: "Au moindre signe d’alerte : appel médecin."),
              SizedBox(height: 12),
              _SubTitle("Fin de mesure"),
              _Paragraph(
                "La retenue prend fin au complet dégrisement : disparition des caractéristiques d’ivresse. "
                "Restitution des effets et décharge par émargement du registre d’écrou.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Remise à un tiers
          _ConditionCard(
            title: "V — Remise sous responsabilité d’un tiers",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsque l’audition immédiate n’est pas nécessaire après le retour à la raison, la personne peut être placée par OPJ/APJ sous la responsabilité d’un tiers garant — ",
                ),
                TextSpan(
                  text:
                      "article L. 3341-1 alinéa 2 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "La remise à un tiers peut intervenir à tout moment : à l’hôpital, au service, avant ou après la chambre de sûreté.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si la remise à un tiers intervient avant l’examen médical, le certificat de non-admission ne sera pas sollicité.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // PV + audition
          _ConditionCard(
            title: "VI — Procès-verbal & audition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La contravention d’ivresse publique et manifeste doit donner lieu à un PV ordinaire, "
                      "en décrivant précisément les signes extérieurs constatés — ",
                ),
                TextSpan(
                  text: "article R. 3353-1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les APJA ne sont pas compétents pour constater cette contravention par procès-verbal.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Audition"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La personne est entendue sur PV séparé : soit après dégrisement, soit ultérieurement si remise à un tiers. "
                      "Il s’agit d’une audition libre avec notification des droits de ",
                ),
                TextSpan(
                  text: "l’article 61-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Résumé
          _ConditionCard(
            title: "En résumé (check-list rapide)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Constater : public + manifeste (signes extérieurs, comportement).",
              ),
              _IntroBullet(
                text:
                    "Protéger : personne vulnérable, prudence (malaise possible).",
              ),
              _IntroBullet(
                text:
                    "Examiner : examen médical avant maintien (certificat non-admission si compatible).",
              ),
              _IntroBullet(
                text:
                    "Sécuriser : fouille de sécurité + registre d’écrou + surveillance (rondes ≤ 15 min).",
              ),
              _IntroBullet(
                text:
                    "Tracer : compte-rendu CIC + MCI + PV (signes détaillés).",
              ),
              _IntroBullet(
                text:
                    "Audition : après dégrisement / ultérieurement + droits CPP.",
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
