import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProtocoleMorsurePage extends StatelessWidget {
  const ProtocoleMorsurePage({super.key});

  static const String routeName = '/gpx/intervention/animal/protocole-morsure';

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
    final Color cardKnown = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardUnknown = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDead = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDogs = isDark
        ? const Color(0xFF1F2B34)
        : const Color(0xFFEFF7FF);
    final Color cardInfra = isDark
        ? const Color(0xFF26201A)
        : const Color(0xFFFFF3E0);
    final Color cardSynth = isDark
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
          "Intervention — Animal",
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
            "Protocole sanitaire en cas de morsure",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "But du protocole",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Tout animal ayant mordu ou griffé une personne doit être soumis à un protocole sanitaire, "
                "afin de vérifier qu’il n’est pas porteur du virus de la rage.\n\n"
                "Le suivi de la surveillance des animaux mordeurs ou griffeurs est enregistré auprès du gestionnaire "
                "du fichier national d’identification des chiens, chats et furets.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (comme demandé)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                lawSpan("Article L. 223-10 du C.R.P.M."),
                const TextSpan(
                  text:
                      " : impose la surveillance vétérinaire de tout animal ayant mordu ou griffé une personne, "
                      "lorsqu’il est possible de s’en saisir sans l’abattre (aux frais du propriétaire/détenteur).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                lawSpan("Article R. 223-35 du C.R.P.M."),
                const TextSpan(
                  text:
                      " : pendant la période de surveillance, il est interdit de se dessaisir de l’animal, de le vacciner "
                      "contre la rage, ou de l’abattre sans autorisation.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                lawSpan("Article R. 223-36 du C.R.P.M."),
                const TextSpan(
                  text:
                      " : en cas d’animal mort/abattu, la tête ou le cadavre est adressé à un organisme ou laboratoire agréé.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Conduite à tenir envers l’animal mordeur",
            cardColor: cardKnown,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) L’animal est connu"),
              _Paragraph(
                "Même si l’animal n’est pas suspect de rage, dès lors qu’on peut s’en saisir sans l’abattre, "
                "il doit être présenté à un vétérinaire sanitaire et placé sous surveillance pendant 15 jours. "
                "Le statut vaccinal antirabique est vérifié (mais la surveillance reste obligatoire).",
              ),
              SizedBox(height: 10),
              _SubTitle("Les 3 visites obligatoires (même vétérinaire)"),
              _IntroBullet(
                text:
                    "1ʳᵉ visite : dans les 24 h suivant la morsure (certificat provisoire).",
              ),
              _IntroBullet(
                text:
                    "2ᵉ visite : au plus tard 7 jours après la morsure (certificat provisoire).",
              ),
              _IntroBullet(
                text:
                    "3ᵉ visite : 15 jours après la morsure (certificat définitif).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Certificats vétérinaires",
            cardColor: cardKnown,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "À chaque visite, un certificat justifiant l’exclusion de suspicion de rage est délivré. "
                "Si l’animal présente des signes suspects, la vaccination antirabique de la personne mordue est engagée.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Établissement en 5 exemplaires"),
              const _BulletPoint(
                text:
                    "3 exemplaires remis au propriétaire/détenteur (dont 1 à transmettre à la personne mordue et 1 à l’autorité investie des pouvoirs de police : le maire).",
              ),
              const _BulletPoint(
                text:
                    "1 exemplaire adressé par le vétérinaire au directeur des services vétérinaires du département.",
              ),
              const _BulletPoint(
                text: "1 exemplaire conservé 1 an par le vétérinaire.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text: "Interdictions pendant la surveillance : ",
                  ),
                  TextSpan(
                    text:
                        "se dessaisir / vacciner contre la rage / abattre sans autorisation",
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(text: ". Référence : "),
                  TextSpan(
                    text: "article R. 223-35 du C.R.P.M.",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "B) L’animal est inconnu ou en fuite",
            cardColor: cardUnknown,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La personne mordue est orientée (via le médecin) vers un centre antirabique. "
                "Le centre décide de l’attitude à adopter en fonction des risques potentiels de contamination.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "C) L’animal est mort",
            cardColor: cardDead,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La tête ou le cadavre des animaux mordeurs ou griffeurs abattus est adressé à un organisme ou laboratoire agréé. ",
                ),
                lawSpan("Article R. 223-36 du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "En attendant les résultats, la vaccination contre la rage de la personne mordue est débutée, "
                "puis arrêtée si la contamination est écartée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Mesures spécifiques applicables aux chiens mordeurs",
            cardColor: cardDogs,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Tout fait de morsure d’une personne par un chien doit être déclaré au maire par le propriétaire/détenteur "
                      "ou par tout professionnel en ayant connaissance (vétérinaire, médecin, policier, pompier…). ",
                ),
                lawSpan("Article L. 211-14-2 du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Le chien est soumis, pendant la surveillance, à une évaluation comportementale par un vétérinaire habilité (communiquée au maire).",
              ),
              const _BulletPoint(
                text:
                    "Le maire (ou à défaut le préfet) peut imposer une formation et une attestation d’aptitude au propriétaire/détenteur.",
              ),
              const _BulletPoint(
                text:
                    "En cas de non-respect : placement en fourrière possible ; en cas de danger grave et immédiat, euthanasie possible après avis vétérinaire.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le refus d’exécuter l’arrêté municipal de placement constitue une contravention de 1ʳᵉ classe : ",
                  ),
                  TextSpan(
                    text: "article R. 610-5 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Infractions liées au protocole (repères)",
            cardColor: cardInfra,
            accent: accentOrange,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Repères opérationnels (codes internes + libellés) pour identifier les manquements fréquents "
                "pendant la période de surveillance.",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "Manquements pendant la surveillance vétérinaire",
              ),
              const _BulletPoint(
                text:
                    "20785 — Absence de visite vétérinaire obligatoire pendant la période de surveillance (rage).",
              ),
              const _BulletPoint(
                text:
                    "20786 — Dessaisissement non autorisé de l’animal pendant la période de surveillance (rage).",
              ),
              const _BulletPoint(
                text:
                    "20787 — Vaccination non autorisée de l’animal pendant la période de surveillance (rage).",
              ),
              const _BulletPoint(
                text:
                    "20788 — Abattage non autorisé de l’animal pendant la période de surveillance (rage).",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                const TextSpan(text: "Fondements cités : "),
                lawSpan("L. 223-10"),
                const TextSpan(text: ", "),
                lawSpan("R. 223-25 5°"),
                const TextSpan(text: ", "),
                lawSpan("R. 223-35"),
                const TextSpan(text: " et "),
                lawSpan("R. 223-36"),
                const TextSpan(text: " du "),
                lawSpan("C.R.P.M."),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Tentative & complicité",
            cardColor: cardSynth,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Tentative : en pratique NON (contraventions et obligations administratives : pas de tentative punissable).",
              ),
              _BulletPoint(
                text:
                    "Complicité : en principe NON pour les contraventions (la complicité vise surtout crimes et délits).",
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
