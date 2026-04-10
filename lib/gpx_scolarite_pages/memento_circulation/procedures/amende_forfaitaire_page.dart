import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmendeForfaitairePage extends StatelessWidget {
  const AmendeForfaitairePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/amende_forfaitaire';

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
    final Color cardCadre = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardTypes = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMontants = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPaiement = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardContest = isDark
        ? const Color(0xFF1E2630)
        : const Color(0xFFF3F6FA);
    final Color cardSuite = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentSteel = isDark
        ? const Color(0xFF90A4AE)
        : const Color(0xFF546E7A);

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
          "Procédures — circulation",
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
            "L’amende forfaitaire",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (comme demandé)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 529 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text:
                      "articles R. 48-1 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : encadrent la procédure de l’amende forfaitaire.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre d'application (définition + conditions)
          _ConditionCard(
            title: "Cadre d’application",
            cardColor: cardCadre,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "S’applique aux contraventions des 4 premières classes et à certaines contraventions de 5e classe listées par la réglementation.",
              ),
              _IntroBullet(
                text: "Constatation par procès-verbal électronique (PVe).",
              ),
              _IntroBullet(
                text:
                    "Non applicable s’il y a constatation simultanée de plusieurs infractions dont au moins une ne peut donner lieu à amende forfaitaire.",
              ),
              _IntroBullet(
                text:
                    "Donne lieu à la délivrance d’un avis de contravention + carte de paiement (envoi postal au domicile du contrevenant ou du titulaire du certificat d’immatriculation, ou par messagerie si une adresse e-mail est fournie — sauf paiement immédiat).",
              ),
              _IntroBullet(text: "Applicable aux mineurs de plus de 13 ans."),
            ],
          ),

          const SizedBox(height: 14),

          // Types d'amendes
          _ConditionCard(
            title: "II — Les 3 régimes",
            cardColor: cardTypes,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Amende forfaitaire « ordinaire »"),
              const _Paragraph(
                "Concerne notamment les contraventions au Code de la route qui ne sont pas minorées, "
                "les contraventions en matière d’arrêt/stationnement, d’assurance des véhicules, "
                "ou encore celles liées à la réglementation des transports routiers.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Amende forfaitaire minorée"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le montant est minoré pour les contraventions routières des 2e, 3e, 4e et certaines 5e classes mentionnées à ",
                ),
                TextSpan(
                  text: "l’article R. 48-1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", "),
                const TextSpan(
                  text:
                      "à l’exception de certaines contraventions relatives au stationnement.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Exception stationnement : "),
                  TextSpan(
                    text: "articles R. 417-1 à R. 417-13",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " et "),
                  TextSpan(
                    text: "article R. 421-7 du Code de la route",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La minoration est conditionnée au paiement dans les délais prévus à ",
                ),
                TextSpan(
                  text: "l’article 529-8 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". En cas de non-paiement dans les délais : application du montant « ordinaire ».",
                ),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("C) Amende forfaitaire majorée"),
              const _Paragraph(
                "Le contrevenant qui ne règle pas l’amende ou ne conteste pas dans les délais se voit appliquer de plein droit une majoration.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Un titre rendu exécutoire par le ministère public permet au Trésor public de recouvrer le montant de l’amende forfaitaire majorée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Montants
          _ConditionCard(
            title: "III — Montants (par classe)",
            cardColor: cardMontants,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Références : "),
                TextSpan(
                  text: "article R. 49 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (ordinaire), "),
                TextSpan(
                  text: "article R. 49-9 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (minorée) et "),
                TextSpan(
                  text: "article R. 49-7 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (majorée)."),
              ]),
              const SizedBox(height: 12),
              _AmountTable(
                isDark: isDark,
                rows: const [
                  _AmountRow(
                    classe: "1ère classe",
                    ordinaire: "11 €",
                    minoree: "4 € (piéton) / 7 € (autre)",
                    majoree: "33 €",
                  ),
                  _AmountRow(
                    classe: "2e classe",
                    ordinaire: "35 €",
                    minoree: "22 €",
                    majoree: "75 €",
                  ),
                  _AmountRow(
                    classe: "3e classe",
                    ordinaire: "68 €",
                    minoree: "45 €",
                    majoree: "180 €",
                  ),
                  _AmountRow(
                    classe: "4e classe",
                    ordinaire: "135 €",
                    minoree: "90 €",
                    majoree: "375 €",
                  ),
                  _AmountRow(
                    classe: "5e classe",
                    ordinaire: "200 €",
                    minoree: "150 €",
                    majoree: "450 €",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Paiement
          _ConditionCard(
            title: "IV — Paiement de l’amende forfaitaire",
            cardColor: cardPaiement,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Le paiement entraîne reconnaissance de l’infraction et extinction de l’action publique.",
              ),
              _IntroBullet(
                text:
                    "Le paiement de l’amende forfaitaire « ordinaire » ou minorée peut être immédiat ou différé (dans les délais).",
              ),
              SizedBox(height: 12),
              _SubTitle("A) Paiement immédiat à l’agent verbalisateur"),
              _Paragraph(
                "Sur les lieux, l’agent encaisse le montant et délivre une quittance. "
                "Aucun procès-verbal n’est rédigé : la quittance tient lieu de feuillet de constatation.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Si l’agent dispose d’un dispositif électronique : quittance dématérialisée envoyée sur demande. "
                "En cas de paiement en espèces : une quittance est obligatoirement adressée au contrevenant.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Les fonds provenant de la perception directe sont remis à l’agent comptable de l’unité (ou suppléant).",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Paiement différé — délais"),
              _BulletPoint(
                text:
                    "Amende forfaitaire « ordinaire » : 45 jours (60 jours en télépaiement / timbre dématérialisé).",
              ),
              _BulletPoint(
                text:
                    "Amende forfaitaire minorée : 15 jours (30 jours en télépaiement / timbre dématérialisé).",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Modes de paiement"),
              _BulletPoint(text: "Chèque au comptable du Trésor."),
              _BulletPoint(
                text:
                    "Télépaiement / timbre dématérialisé : Internet, serveur vocal, application « amendes.gouv ».",
              ),
              _BulletPoint(
                text:
                    "Débitants de tabac agréés « paiement électronique des amendes ».",
              ),
              _BulletPoint(
                text: "Trésoreries équipées de terminaux de télépaiement.",
              ),
              _BulletPoint(
                text: "Virement bancaire international (si applicable).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contestation
          _ConditionCard(
            title: "V — Contestation",
            cardColor: cardContest,
            accent: accentSteel,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’amende forfaitaire peut être contestée conformément aux ",
                ),
                TextSpan(
                  text:
                      "articles 529-2, 529-10 et 530 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("A) Amende forfaitaire « ordinaire » ou minorée"),
              const _Paragraph(
                "Deux voies existent selon le type de contravention.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title:
                    "Requête en exonération (cas CI / locataire / acquéreur / représentant légal)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si la contravention vise la responsabilité pécuniaire du titulaire du certificat d’immatriculation (ou assimilé) lorsque le conducteur n’a pas été interpellé (contrôle automatisé, vidéo-verbalisation). Référence : ",
                  ),
                  TextSpan(
                    text: "L. 121-3 et R. 121-6 du Code de la route",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "→ Requête (courrier RAR au CNT de Rennes ou via ANTAI) avec : "
                "formulaire rempli + pièces justificatives (vol, destruction, cession, usurpation de plaque) "
                "ou exposé des motifs + preuve de consignation (si autre motif).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "En cas de classement sans suite, la somme consignée est restituée par le comptable du Trésor.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Requête en exonération simple",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si l’amende forfaitaire concerne une contravention autre que celles liées à la responsabilité pécuniaire : envoi du formulaire + avis de contravention au CNT de Rennes (ou contestation dématérialisée). Référence : ",
                  ),
                  TextSpan(
                    text: "article 529-2 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Amende forfaitaire majorée"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Réclamation (annule le titre exécutoire) — ",
                ),
                TextSpan(
                  text: "article 530 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réclamation accompagnée de l’avis d’amende forfaitaire majorée correspondant.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Suites possibles
          _ConditionCard(
            title: "VI — Suites possibles après examen",
            cardColor: cardSuite,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Après examen de la recevabilité d’une requête en exonération ou d’une réclamation, le ministère public peut :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Renoncer aux poursuites (classement sans suite).",
              ),
              const _BulletPoint(
                text: "Saisir le tribunal par voie d’ordonnance pénale.",
              ),
              const _BulletPoint(
                text:
                    "Citer directement le contrevenant devant le tribunal de police.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("A) Ordonnance pénale"),
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 524 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : procédure simplifiée permettant au juge de statuer sans débat préalable (relaxe ou condamnation).",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "À compter de l’envoi de la notification d’une ordonnance pénale de condamnation, le prévenu dispose de 30 jours pour former opposition ou payer l’amende.",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "B) Citation directe devant le tribunal de police",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 531 et suivants du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : applicable aux contraventions ne pouvant relever de l’amende forfaitaire ou lorsque l’ordonnance pénale est écartée.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La citation précise la juridiction saisie, le lieu, l’heure et la date d’audience. "
                "Le juge prononce des sanctions proportionnées à la gravité de l’infraction.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Point pratique : l’agent verbalisateur doit relever avec précision et impartialité les circonstances de commission de l’infraction (qualité du PV, cohérence des mentions).",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(text: "Mis à jour le "),
                const TextSpan(
                  text: "15/06/2025",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountRow {
  const _AmountRow({
    required this.classe,
    required this.ordinaire,
    required this.minoree,
    required this.majoree,
  });

  final String classe;
  final String ordinaire;
  final String minoree;
  final String majoree;
}

class _AmountTable extends StatelessWidget {
  const _AmountTable({required this.isDark, required this.rows});

  final bool isDark;
  final List<_AmountRow> rows;

  @override
  Widget build(BuildContext context) {
    final Color headerBg = isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF1F1F1);
    final Color rowBg = isDark ? const Color(0xFF151515) : Colors.white;
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white : const Color(0xFF111111);
    final Color subText = isDark ? Colors.white70 : const Color(0xFF444444);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Classe",
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      color: text,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Ordinaire",
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      color: text,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Minorée",
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      color: text,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Majorée",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      color: text,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rows
          ...rows.map((r) {
            return Container(
              decoration: BoxDecoration(
                color: rowBg,
                border: Border(top: BorderSide(color: border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      r.classe,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: text,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      r.ordinaire,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: subText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      r.minoree,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: subText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      r.majoree,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: text,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
