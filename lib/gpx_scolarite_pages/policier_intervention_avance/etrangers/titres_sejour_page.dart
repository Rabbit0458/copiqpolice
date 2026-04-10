import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitresSejourPage extends StatelessWidget {
  const TitresSejourPage({super.key});

  static const String routeName = '/gpx/intervention/etrangers/titres-sejour';

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
    final Color cardMaj = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMin = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAsile = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardProv = isDark
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
          "Étrangers",
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
            "Les différents titres de séjour",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Point de départ (contrôle)",
            cardColor: cardProv,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Dès que la qualité d’étranger est établie, il appartient au gardien de la paix "
                "d’examiner le titre de séjour présenté : type, validité, mentions, cohérence avec la situation.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Toujours vérifier : identité / dates / mentions (activité, étudiant…) / intégrité du document.",
              ),
              _IntroBullet(
                text:
                    "En cas de doute : recoupements via les outils et canaux habituels (procédures internes).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Cadre légal (référence)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 411-1 du C.E.S.E.D.A.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : présente les principaux titres de séjour délivrés aux majeurs (typologie).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La mention exacte portée sur le titre est déterminante (ex. « salarié », « vie privée et familiale », « étudiant »…).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Majeurs
          _ConditionCard(
            title: "I — Titres de séjour délivrés aux majeurs",
            cardColor: cardMaj,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Les différents titres"),
              _Paragraph.rich([
                const TextSpan(text: "Base : "),
                TextSpan(
                  text: "article L. 411-1 du C.E.S.E.D.A.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("1) Carte de résident"),
              const _Paragraph(
                "Délivrable aux étrangers résidant en France qui remplissent les conditions fixées par la loi. "
                "Validité : 10 ans. La carte de résident permanent est délivrée de droit dès le 2ᵉ renouvellement (selon régime applicable).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Carte de séjour temporaire"),
              const _Paragraph(
                "Validité : 1 an. Concerne notamment les étrangers ne remplissant pas les conditions pour une carte de résident. "
                "Peut se présenter sous forme de carte plastifiée ou de vignette apposée sur le passeport. "
                "Elle comporte des mentions (ex. « salarié », « vie privée et familiale »).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) Carte de séjour pluriannuelle"),
              const _Paragraph(
                "Porte des mentions (ex. « talent », « étudiant-programme de mobilité », « salarié détaché ICT »). "
                "Validité : de 2 à 4 ans, renouvelable.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 411-4 du C.E.S.E.D.A.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : durée/renouvellement (référence)."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("4) Carte de séjour « retraité »"),
              const _Paragraph(
                "Validité : 10 ans, renouvelée de plein droit. "
                "Le bénéficiaire peut entrer en France à tout moment pour y effectuer des séjours n’excédant pas 1 an.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("5) Certificat de résidence algérien"),
              const _Paragraph(
                "Régime particulier lié à un accord bilatéral. Les ressortissants algériens se voient délivrer un certificat de résidence algérien.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Tout ressortissant algérien majeur doit être titulaire d’un titre de séjour pour résider en France.",
              ),
              const _BulletPoint(
                text:
                    "Entre 16 et 18 ans : titre requis s’il souhaite travailler.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Un certificat d’1 an peut être délivré avec mentions (« vie privée et familiale », « salarié », « étudiant »…). "
                "Un certificat de 10 ans peut aussi être délivré sous certaines conditions.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("6) Résidents U.E / E.E.E"),
              const _Paragraph(
                "Les résidents de l’Union européenne et de l’Espace économique européen peuvent séjourner en France "
                "avec un passeport ou une carte nationale d’identité en cours de validité.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Ils peuvent également demander une carte de séjour « Ressortissant d’un État membre de l’U.E » "
                "(convenances personnelles). Certains cas peuvent exiger une mention autorisant l’activité professionnelle.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "E.E.E. : États membres de l’U.E + Islande, Liechtenstein, Norvège.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("7) Visas de long séjour (visa D)"),
              const _Paragraph(
                "Trois grands types existent, selon les mentions : "
                "« vie privée et familiale », « visiteur », « étudiant », « salarié », « travailleur temporaire », "
                "« scientifique-chercheur », « stagiaire », etc. "
                "Certains visent une dispense temporaire de carte de séjour ou imposent une demande de carte dans les 2 mois.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Ces visas valent titre de séjour (durée > 3 mois et ≤ 1 an). "
                "Les titulaires sont soumis à une procédure d’enregistrement auprès de l’O.F.I.I. "
                "Une vignette spécifique est apposée dans le passeport.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("8) Mention « Accord de retrait » (Royaume-Uni)"),
              const _Paragraph(
                "Depuis le 1er janvier 2022, les ressortissants britanniques doivent détenir soit "
                "un titre spécifique portant la mention « Accord de retrait », soit un titre de droit commun.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Mineurs
          _ConditionCard(
            title: "II — Titres / documents pour les mineurs",
            cardColor: cardMin,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Les mineurs étrangers résidant en France sont dispensés de détenir un titre de séjour. "
                "Cependant, pour faciliter les déplacements à l’étranger et le retour sur le territoire, "
                "un document spécifique est requis.",
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "Document de Circulation pour Étranger Mineur (D.C.E.M.)",
              ),
              const _Paragraph(
                "Le D.C.E.M. facilite les déplacements et la réadmission sur le territoire français. "
                "Sa durée de validité ne peut excéder 5 ans (conditions de délivrance simplifiées).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Références : "),
                TextSpan(
                  text:
                      "articles L.414-4, L.414-5, L.414-6, L.414-9 et L. 236-1 du C.E.S.E.D.A.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un D.C.E.M. délivré par le préfet de Mayotte ne permet la réadmission qu’à Mayotte. "
                        "Le document est inscrit dans l’application A.G.D.R.E.F.2.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Asile / apatrides
          _ConditionCard(
            title: "III — Demandeurs d’asile, réfugiés, apatrides",
            cardColor: cardAsile,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Définitions"),
              const _BulletPoint(
                text:
                    "Réfugié : craint d’être persécuté (race, religion, nationalité, groupe social, opinions politiques).",
              ),
              const _BulletPoint(
                text:
                    "Apatride : aucun État ne le considère comme ressortissant (Convention de New York, 28/09/1954).",
              ),
              const _BulletPoint(
                text:
                    "Protection subsidiaire : ne remplit pas les critères du réfugié, mais risque des menaces graves (peine de mort, tortures, traitements inhumains, menace grave contre la vie).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("B) Documents délivrés pendant la procédure"),
              const _Paragraph(
                "Les demandeurs déposent un dossier auprès de l’O.F.P.R.A. "
                "Ils reçoivent un récépissé constatant le dépôt (valable 3 mois). "
                "Il existe plusieurs types de récépissés (dépôt, reconnaissance de protection, admission au titre de l’asile).",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "C) En cas de décision favorable de l’O.F.P.R.A.",
              ),
              const _Paragraph(
                "Les réfugiés et apatrides peuvent obtenir une carte de séjour pluriannuelle "
                "mention « bénéficiaire du statut d’apatride » (4 ans) ou une carte de résident (10 ans), selon le cas.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Articles L.424-1 et L. 424-18 du C.E.S.E.D.A.",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les bénéficiaires de la protection subsidiaire reçoivent de plein droit une carte de séjour pluriannuelle "
                "mention « bénéficiaire de la protection subsidiaire » (4 ans). Une carte de résident (10 ans) peut être obtenue "
                "après une résidence régulière d’au moins 4 ans (selon conditions).",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Articles L.424-9 et L. 424-13 du C.E.S.E.D.A.",
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

          // IV — Titres provisoires
          _ConditionCard(
            title: "IV — Titres provisoires de séjour",
            cardColor: cardProv,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Autorisation provisoire de séjour (A.P.S.)"),
              _Paragraph(
                "Document autorisant la présence en France pendant sa durée de validité. "
                "Délivrée pour 15 jours, 1 mois, 3 mois ou 6 mois, renouvelable. "
                "Elle peut porter une mention autorisant (ou non) l’exercice d’un emploi.",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Récépissé de demande de carte de séjour (R.C.S.)"),
              _Paragraph(
                "Tout étranger autorisé à déposer une première demande ou un renouvellement reçoit un document provisoire appelé « récépissé ». "
                "Il permet de demeurer régulièrement en France pendant l’instruction du dossier.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Durée : au minimum 1 mois (souvent 3 mois), renouvelable si nécessaire.",
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
