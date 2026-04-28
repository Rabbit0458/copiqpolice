import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ObtentionIndueDocumentAdministratifPage extends StatelessWidget {
  const ObtentionIndueDocumentAdministratifPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux/obtention_indue_document_administratif';

  static const Color _lawRed = Color(0xFFE53935);

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
          "Faux & usage de faux",
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
            "L’obtention indue de document administratif",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Est incriminée l’action de se faire délivrer indûment, par une administration publique "
                "ou par un organisme chargé d’une mission de service public, par quelque moyen frauduleux que ce soit, "
                "un document destiné à constater un droit, une identité, une qualité ou à accorder une autorisation.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Est également prévu le fait de fournir sciemment une fausse déclaration ou une déclaration incomplète "
                "en vue d’obtenir (ou de tenter d’obtenir), de faire obtenir (ou de tenter de faire obtenir) d’une personne publique, "
                "d’un organisme de protection sociale ou d’un organisme chargé d’une mission de service public "
                "une allocation, une prestation, un paiement ou un avantage indu.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text: "Article 441-6 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime l’obtention indue de document administratif et l’assimilation liée aux fausses déclarations pour obtenir des avantages indus.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Document administratif ou assimilé"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le texte vise un document délivré par une administration publique (ou assimilé) au sens de ",
                ),
                const TextSpan(
                  text: "l’article 441-6 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ", destiné à constater un droit, une identité, une qualité, ou à accorder une autorisation.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’infraction ne s’applique pas à des faux : elle vise des documents authentiques délivrés indûment.",
              ),

              const SizedBox(height: 12),

              _ConditionCard(
                title: "Exemples de documents visés",
                cardColor: isDark
                    ? const Color(0xFF1E232A)
                    : const Color(0xFFF3F4F6),
                accent: accentGrey,
                titleColor: textMain,
                children: const [
                  _IntroBullet(
                    text:
                        "Documents d’identité : passeport, carte nationale d’identité, titre de séjour, etc.",
                  ),
                  _IntroBullet(
                    text:
                        "Documents constatant un droit/une qualité : certificat de nationalité, carte grise, récépissés administratifs constatant une formalité obligatoire, etc.",
                  ),
                  _IntroBullet(
                    text:
                        "Documents accordant une autorisation : permis de construire, permis de chasser, permis de conduire, etc.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "B) Délivrance par un organisme chargé d’une mission de service public",
              ),
              const _Paragraph(
                "Le texte étend l’incrimination aux documents délivrés par des organismes chargés d’une mission de service public "
                "(ex. caisses de sécurité sociale, OFPRA, Pôle emploi, etc.).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Obtenu frauduleusement"),
              const _Paragraph(
                "Les documents sont délivrés indûment. Le texte vise « quelque moyen frauduleux que ce soit » "
                "sans en donner une liste exhaustive.",
              ),
              const SizedBox(height: 10),

              _ConditionCard(
                title: "Moyens frauduleux : repères",
                cardColor: isDark
                    ? const Color(0xFF1E232A)
                    : const Color(0xFFF3F4F6),
                accent: accentGrey,
                titleColor: textMain,
                children: [
                  const _IntroBullet(text: "Fausses déclarations."),
                  const _IntroBullet(
                    text: "Faux renseignements, certificats ou attestations.",
                  ),
                  const _IntroBullet(
                    text:
                        "Déclarations d’un tiers (ex. fausse attestation de réussite).",
                  ),
                  const _IntroBullet(
                    text:
                        "Manœuvres frauduleuses (ex. mariage de complaisance).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : indications mensongères données pour se faire délivrer un plan de chasse ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 03 octobre 2000)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : fausse date d’entrée en France sur un formulaire de demande de carte de séjour ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 20 mars 1991)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : personne se déclarant atteinte de cécité pour accéder au statut d’invalide ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 30 avril 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : délivrance d’un brevet d’éducateur sportif sur la base d’une fausse attestation de réussite ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 02 juin 1999)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : mariage de complaisance constitutif de manœuvres pour l’obtention indue d’un titre de séjour ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 04 novembre 1992)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’infraction n’a pas à être préjudiciable pour être qualifiée ",
                  ),
                  const TextSpan(
                    text: "(Cass. crim., 07 avril 1994)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Allocation, prestation, paiement ou avantage indu (assimilation)",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Selon "),
                const TextSpan(
                  text: "l’article 441-6 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      ", est assimilé le fait de fournir une fausse déclaration ou une déclaration incomplète "
                      "pour obtenir (ou tenter d’obtenir) des avantages indus.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La fausse déclaration peut être verbale ou écrite (si elle est écrite, elle doit être recueillie par écrit par le destinataire, puis signée).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La déclaration est fausse ou incomplète lorsqu’elle altère la vérité : affirmation de faits faux ou omission de faits exacts.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’avantage n’a pas besoin d’avoir été obtenu : il suffit que la déclaration ait été faite dans le but de l’obtenir ou de le faire obtenir.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Lorsque des qualifications spécifiques existent, elles s’appliquent prioritairement (ex. dispositions du code de l’action sociale et des familles pour certaines aides).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Intention frauduleuse"),
              _Paragraph(
                "L’auteur doit avoir conscience de se faire délivrer indûment un document (ou de tenter d’obtenir un avantage indu) "
                "et vouloir recourir à un moyen frauduleux.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "S’agissant de l’alinéa 2 : la fausse déclaration ou la déclaration incomplète doit être faite volontairement.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph("Aucune circonstance aggravante prévue par le texte."),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Délit : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende. — ",
                ),
                const TextSpan(
                  text: "article 441-6 (alinéas 1 et 2) du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                const TextSpan(
                  text: "l’article 441-12 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — "),
                const TextSpan(
                  text: "article 441-9 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text:
                      " (prévoit expressément la tentative des délits, dont ceux visés à l’article 441-6).",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Complicité : OUI (règles générales relatives à la complicité).",
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
