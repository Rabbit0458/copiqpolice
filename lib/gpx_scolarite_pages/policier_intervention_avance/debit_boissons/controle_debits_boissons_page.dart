import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ControleDebitsBoissonsPage extends StatelessWidget {
  const ControleDebitsBoissonsPage({super.key});

  static const String routeName = '/gpx/intervention/debit-boissons/controle';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return const TextSpan(text: '').children == null
        ? TextSpan(
            text: text,
            style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
          )
        : TextSpan(
            text: text,
            style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
          );
  }

  TextSpan _t(String text) => TextSpan(text: text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardCond = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAdmin = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSafe = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInf = isDark
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
          "Débits de boissons",
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
            "Le contrôle des débits de boissons",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Contexte",
            cardColor: cardInf,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le contrôle des établissements recevant du public (débits de boissons, restaurants…) fait partie "
                "des missions de police. Lors des contrôles, le gardien de la paix doit maîtriser les règles "
                "juridiques et administratives, respecter les règles de sécurité, et rester vigilant.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Base / élément légal en haut (références principales issues de ton contenu)
          _ConditionCard(
            title: "I — Cadre légal (références principales)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _t("Textes fréquemment rencontrés lors des contrôles : "),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("C.S.P. : "),
                _t(
                  "régime des licences, obligations, interdictions, fermetures, protection des mineurs.\n",
                ),
                _law("L 3332-3 C.S.P."),
                _t(", "),
                _law("L 3332-4 C.S.P."),
                _t(", "),
                _law("L 3332-15 C.S.P."),
                _t(", "),
                _law("L 3332-16 C.S.P."),
                _t(", "),
                _law("L 3353-3 C.S.P."),
                _t(", "),
                _law("R 3353-7 C.S.P."),
                _t(", "),
                _law("R 3353-2 C.S.P."),
                _t("."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "IMPORTANT",
                bodySpans: [
                  _t(
                    "Les articles affichés dans cette fiche sont ceux apparaissant dans tes supports. "
                    "En intervention, tu relies toujours le contrôle à la situation concrète (lieu, horaires, fermeture, sécurité, mineurs, etc.).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // CONDITIONS D’INTERVENTION
          _ConditionCard(
            title: "II — Conditions d’intervention",
            cardColor: cardCond,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Règles horaires d’intervention"),
              const _Paragraph(
                "Pour intervenir dans un lieu ouvert au public, le policier respecte les heures d’ouverture "
                "et de fermeture fixées par les arrêtés municipaux et préfectoraux. En dehors de ces heures, "
                "la pénétration relève des règles applicables à l’introduction dans un lieu privé.",
              ),
              const SizedBox(height: 10),
              const _SubTitle(
                "B) Cas admis par la jurisprudence (hors horaires)",
              ),
              const _Paragraph(
                "L’intervention hors horaires d’ouverture a été admise notamment lorsque :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "La porte n’est pas verrouillée et l’établissement est éclairé, même sans consommateur.",
              ),
              const _BulletPoint(
                text:
                    "Le débitant fait sortir des personnes au moment de la constatation.",
              ),
              const _BulletPoint(
                text:
                    "Les personnes présentes sont des invités (amis, voisins…) du débitant.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  _t(
                    "Après l’heure légale de fermeture, le policier peut requérir l’ouverture du débit si les constatations "
                    "faites depuis l’extérieur laissent présumer, de manière non équivoque, que des infractions sont en train "
                    "de se commettre.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "C) Conditions de lieu (périmètre d’intervention)",
              ),
              const _Paragraph(
                "Les débits de boissons sont des lieux ouverts au public : les forces de l’ordre peuvent y pénétrer. "
                "La jurisprudence admet aussi l’intervention dans des espaces liés au débit (selon les circonstances).",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Cuisine attenante, salle louée pour une réunion particulière.",
              ),
              const _BulletPoint(
                text:
                    "Pièce réservée à l’usage personnel si des consommateurs y sont trouvés.",
              ),
              const _BulletPoint(
                text:
                    "Chambre à coucher de l’exploitant si des consommateurs y ont été invités.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("D) Terrasse sur la voie publique"),
              const _Paragraph(
                "Une terrasse sur la voie publique nécessite une autorisation d’occupation temporaire du domaine public "
                "(maire ou préfet). L’installation ne doit pas porter atteinte à la libre circulation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // CONTROLES ADMIN
          _ConditionCard(
            title: "III — Contrôles de police administrative",
            cardColor: cardAdmin,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Contrôle des pièces administratives"),
              const _Paragraph("L’exploitant doit pouvoir présenter :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Permis d’exploitation (formation obligatoire) valable 10 ans.",
              ),
              const _BulletPoint(
                text:
                    "Récépissé de déclaration administrative remis par la mairie (justifie la possession de la licence).",
              ),
              const _BulletPoint(
                text: "Extrait du registre du commerce et des sociétés.",
              ),
              const _BulletPoint(
                text:
                    "Attestation notariale de propriété ou de gérance du fonds de commerce.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Contrôle de la réglementation générale"),
              const _Paragraph("Le contrôle porte notamment sur :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Respect des heures d’ouverture et de fermeture.",
              ),
              const _BulletPoint(
                text:
                    "Protection des mineurs (présence, emploi, vente d’alcool interdite).",
              ),
              const _BulletPoint(
                text:
                    "Publicité obligatoire (étalage des 10 boissons non alcooliques).",
              ),
              const _BulletPoint(
                text: "Affichage de l’interdiction de fumer + signalisation.",
              ),
              const _BulletPoint(text: "Affichage visible des prix."),
              const _BulletPoint(
                text: "Vente des boissons (modalités / interdictions).",
              ),
              const _BulletPoint(text: "Employés de l’établissement."),
              const _BulletPoint(
                text:
                    "Jeux de hasard interdits (certains jeux peuvent être autorisés localement).",
              ),
              const _BulletPoint(
                text: "Non-respect d’une sanction de fermeture.",
              ),
              const _BulletPoint(
                text: "Installation et conformité d’une terrasse.",
              ),
              const _BulletPoint(
                text:
                    "Affiche relative à la protection des mineurs et à la répression de l’ivresse publique.",
              ),
              const _BulletPoint(
                text:
                    "Mise à disposition de dispositifs de dépistage de l’imprégnation alcoolique (éthylotests).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("C) Sécurité, hygiène et salubrité"),
              const _Paragraph(
                "Vérifier les principes de prévention incendie (issues, évacuation, éclairage de sécurité, consignes…). "
                "Contrôler le respect du règlement sanitaire départemental (aération, propreté, protection des denrées…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // SECURITE
          _ConditionCard(
            title: "IV — Règles de sécurité (vigilance opérationnelle)",
            cardColor: cardSafe,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’intervention dans un débit de boissons exige une vigilance élevée : configuration des lieux, "
                "affluence, consommation d’alcool, excitation potentielle, risques de rixe, objets dangereux, etc.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Se placer, observer, analyser : sorties, flux, zones à risque, comportement des clients.",
              ),
              const _BulletPoint(
                text:
                    "Rester attentif au personnel, aux signaux de tension, et aux changements rapides d’ambiance.",
              ),
              const _BulletPoint(
                text:
                    "Sécuriser l’équipe : répartition des rôles, communication, maintien des distances.",
              ),
              const _BulletPoint(
                text:
                    "Limiter l’exposition inutile : éviter l’isolement, conserver des axes de repli.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  _t(
                    "Si la situation l’exige, bascule dans une logique de sécurisation avant toute vérification administrative.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // INFRACTIONS (présentation propre, pédagogique)
          _ConditionCard(
            title: "V — Principales infractions à relever (repères)",
            cardColor: cardInf,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Cette section te donne des repères rapides issus de tes supports (Natinf / textes / classe). "
                "À adapter selon le contexte et ce que tu constates sur place.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Ouverture / déclaration / licence"),
              _Paragraph.rich([
                _t("• Changement de propriétaire/gérant sans déclaration : "),
                _law("L 3332-4 C.S.P."),
                _t(" (Natinf 245).\n"),
                _t("• Ouverture sans déclaration préalable : "),
                _law("L 3332-3 C.S.P."),
                _t(" (Natinf 246).\n"),
                _t("• Débit temporaire sans autorisation municipale : "),
                _law("L 3334-2 C.S.P."),
                _t(" (Natinf 6251).\n"),
                _t("• Distance réglementaire (arrêté préfectoral) : "),
                _law("R 3335-15 C.S.P."),
                _t(" (Natinf 2357)."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("B) Personnel / mineurs / protection"),
              _Paragraph.rich([
                _t("• Débitant mineur non émancipé / majeur sous tutelle : "),
                _law("L 3336-1 C.S.P."),
                _t(" (Natinf 2363).\n"),
                _t("• Emploi sans agrément de mineur : "),
                _law("L 3336-4 C.S.P."),
                _t(" + "),
                _law("L 4153 Code du travail"),
                _t(" (Natinf 2345).\n"),
                _t("• Vente/offre d’alcool à un mineur : "),
                _law("L 3353-3 C.S.P."),
                _t(" (Natinf 20556).\n"),
                _t(
                  "• Accueil d’un mineur de moins de 16 ans non accompagné : ",
                ),
                _law("R 3353-7 C.S.P."),
                _t(" (Natinf 6256)."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("C) Interdiction de fumer (principaux repères)"),
              _Paragraph.rich([
                _t(
                  "• Absence de signalisation / obligations de signalétique : ",
                ),
                _law("R.3515-3"),
                _t(" / "),
                _law("R.3512-2 C.S.P."),
                _t(" (selon cas).\n"),
                _t(
                  "• Violation de l’interdiction dans un lieu couvert et clos : ",
                ),
                _law("R.3512-2"),
                _t(" + "),
                _law("L.3512-8 C.S.P."),
                _t(" (Natinf 11280 / 11281 selon situations)."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("D) Ivresse / vente à personne ivre"),
              _Paragraph.rich([
                _t("• Ivresse (repère support) : "),
                _law("R 3353-2 C.S.P."),
                _t(" (Natinf 6253).\n"),
                _t(
                  "• Vente / accueil d’une personne manifestement ivre : repères Natinf 11360 / 6258 (selon constatations).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("E) Affichage « mineurs & ivresse publique »"),
              _Paragraph.rich([
                _t(
                  "• Non-apposition / affiche non conforme (sur place / à emporter / carburant) : ",
                ),
                _law("R 3353-7 C.S.P."),
                _t(" + "),
                _law("L 3342-4 C.S.P."),
                _t(" (Natinf 27658 à 27666 selon cas)."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("F) Éthylotests (mise à disposition)"),
              _Paragraph.rich([
                _t(
                  "• Absence / non-conformité / insuffisance / conditions d’hygiène : ",
                ),
                _law("L 3341-4"),
                _t(" + "),
                _law("R 3353-3 C.S.P."),
                _t(" (Natinf 33523 à 33527 selon cas)."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("G) Bruits, tapage, troubles"),
              _Paragraph.rich([
                _t("• Bruit portant atteinte à la tranquillité : "),
                _law("R 1334-31 C.S.P."),
                _t(" (Natinf 13313).\n"),
                _t("• Tapage nocturne : "),
                _law("R 623-2 C.P."),
                _t(" (Natinf 6068).\n"),
                _t(
                  "• Manquement à une obligation de police (repère support) : ",
                ),
                _law("R 610-5 C.P."),
                _t(" (Natinf 6032 / 2902 selon cas)."),
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
