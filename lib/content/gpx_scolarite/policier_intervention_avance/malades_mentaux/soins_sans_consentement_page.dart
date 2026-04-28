import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoinsSansConsentementPage extends StatelessWidget {
  const SoinsSansConsentementPage({super.key});

  static const String routeName =
      '/gpx/intervention/malades-mentaux/soins-sans-consentement';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardProcedures = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRoles = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSynth = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
          "Malades mentaux",
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
            "Admission en soins psychiatriques sans consentement",
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
            title: "I — Cadre légal (Code de la santé publique)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les soins psychiatriques sans consentement sont principalement encadrés par le Code de la santé publique, notamment : ",
                ),
                TextSpan(
                  text: "articles L. 3212-1 à L. 3212-12 CSP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (demande d’un tiers / péril imminent) et ",
                ),
                TextSpan(
                  text: "articles L. 3213-1 à L. 3213-11 CSP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (décision du représentant de l’État)."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Principe",
                bodySpans: const [
                  TextSpan(
                    text:
                        "La prise en charge peut être une hospitalisation complète ou une autre forme (programme de soins, consultations, soins à domicile), "
                        "adaptée et proportionnée à l’état mental du patient.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition / notions
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La maladie mentale correspond à une perturbation des facultés mentales pouvant affecter "
                "les pensées, les sentiments et le comportement, au point de rendre la conduite parfois incompréhensible. "
                "Elle peut être guérie ou réduite par une thérapie adaptée.\n\n"
                "• Les soins avec consentement = soins psychiatriques libres (mêmes droits que tout autre patient).\n"
                "• Les soins sans consentement = accès aux soins pour une personne qui n’est pas en mesure de consentir.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Procédures
          _ConditionCard(
            title: "II — Les procédures d’admission",
            cardColor: cardProcedures,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Demande d’un tiers / Péril imminent"),
              _Paragraph.rich([
                const TextSpan(text: "Cadre : "),
                TextSpan(
                  text: "articles L. 3212-1 à L. 3212-12 CSP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1) Sur demande d’un tiers"),
              const _Paragraph(
                "Décision prise par le directeur d’un établissement autorisé en psychiatrie lorsque :\n"
                "• les troubles rendent impossible le consentement,\n"
                "• l’état impose des soins immédiats avec surveillance constante justifiant une hospitalisation complète.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Demande manuscrite et signée par le tiers (famille, tuteur…).",
              ),
              const _BulletPoint(
                text:
                    "Deux certificats médicaux récents (moins de 15 jours), circonstanciés, rédigés par deux médecins différents.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) En cas de péril imminent"),
              const _Paragraph(
                "Décision du directeur d’établissement lorsque :\n"
                "• le consentement est impossible,\n"
                "• il est impossible d’obtenir une demande d’un tiers,\n"
                "• il existe un péril imminent pour la santé de la personne.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Un seul certificat médical circonstancié (moins de 15 jours) est requis.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Décision du représentant de l’État (Préfet)"),
              _Paragraph.rich([
                const TextSpan(text: "Cadre : "),
                TextSpan(
                  text: "articles L. 3213-1 à L. 3213-11 CSP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1) Procédure normale (arrêté préfectoral)"),
              const _Paragraph(
                "Le préfet prononce l’admission par arrêté, au vu d’un certificat médical circonstancié "
                "(qui ne peut pas émaner d’un psychiatre exerçant dans l’établissement d’accueil), lorsque les troubles :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Compromettent la sûreté des personnes.",
              ),
              const _BulletPoint(
                text: "Ou portent atteinte, de façon grave, à l’ordre public.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Procédure d’urgence (mesure provisoire)"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En cas de danger imminent pour la sûreté des personnes attesté par un avis médical, le maire (ou à Paris les commissaires de police) peut prendre des mesures provisoires : ",
                ),
                TextSpan(
                  text: "article L. 3213-2 CSP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Information transmise au préfet dans les 24 heures.",
              ),
              const _BulletPoint(
                text:
                    "Sans décision préfectorale : mesures caduques au terme de 48 heures.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La “notoriété publique” ne suffit plus : un certificat / avis médical est nécessaire (suite à censure partielle de l’ancien dispositif).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Observation / JLD / mineurs
          _ConditionCard(
            title: "III — Période initiale d’observation et suites",
            cardColor: cardSynth,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Lors de l’admission, une période initiale d’observation et de soins de 72 heures est mise en place.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Examen par un psychiatre du centre d’accueil : certificat médical à 24 heures.",
              ),
              const _BulletPoint(
                text: "Nouvel examen : certificat médical à 72 heures.",
              ),
              const _BulletPoint(
                text:
                    "À l’issue : avis motivé proposant la forme de prise en charge (hospitalisation complète ou autre).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Si la prise en charge est une hospitalisation complète, le juge des libertés et de la détention (JLD) est avisé.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Mineurs",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les mineurs de moins de 16 ans relèvent d’une prise en charge en hôpital de médecine générale pour les premiers soins nécessaires.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Rôle police
          _ConditionCard(
            title: "IV — Rôle des services de police",
            cardColor: cardRoles,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le rôle des services de police consiste à prendre en charge le malade mental pour un temps aussi court que possible, "
                "avec une surveillance permanente et directe. Les précautions de sécurité doivent être strictement respectées.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("A) Sécurisation immédiate"),
              const _BulletPoint(
                text:
                    "Surveillance permanente et directe (jamais “laisser seul”).",
              ),
              const _BulletPoint(
                text:
                    "Fouille de sécurité et retrait de tout objet dangereux dès l’appréhension.",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "B) Si un séjour au commissariat est indispensable",
              ),
              const _BulletPoint(
                text:
                    "Isoler la personne (cadre sécurisé) et mobiliser plusieurs policiers pour une surveillance constante.",
              ),
              const _BulletPoint(
                text:
                    "Ne jamais placer la personne dans les locaux de garde à vue.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("C) Transport vers l’établissement"),
              const _BulletPoint(
                text:
                    "Le transport vers l’établissement psychiatrique n’incombe pas aux services de police (sauf conventions particulières).",
              ),
              const _BulletPoint(
                text:
                    "À défaut de convention : l’établissement de destination doit assurer le transport.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("D) Évasion d’un patient hospitalisé"),
              const _Paragraph(
                "Les patients faisant l’objet d’une hospitalisation complète et évadés peuvent être inscrits au FPR "
                "(dangerosité, réactions à craindre, personnes/lieux à risque).",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "En cas de découverte : effectuer une cessation de recherches selon la procédure.",
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
