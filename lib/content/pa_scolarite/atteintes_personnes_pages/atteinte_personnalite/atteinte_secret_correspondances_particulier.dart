import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAtteinteSecretCorrespondancesParticulierPage extends StatelessWidget {
  const PaAtteinteSecretCorrespondancesParticulierPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_secret_correspondances_particulier';

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
          "Atteinte à la personnalité",
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
            "L’atteinte au secret des correspondances\ncommise par un particulier",
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
                "Le fait, commis de mauvaise foi, d’ouvrir, de supprimer, de retarder ou de détourner "
                "des correspondances arrivées ou non à destination et adressées à des tiers, "
                "ou d’en prendre frauduleusement connaissance, constitue une infraction.",
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
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime l’atteinte au secret des correspondances commise par un particulier.",
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
            children: const [
              _SubTitle("A) L’objet de l’atteinte"),
              _SubTitle("• Une correspondance"),
              _Paragraph(
                "La loi ne définit pas la notion de « correspondance ». La jurisprudence considère ce terme "
                "comme un synonyme de « message », quel qu’en soit le support, dès lors que ce message a vocation à circuler. "
                "Sont donc considérés comme correspondances : courrier, lettre, carte postale, télégramme, etc.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La nature de la correspondance importe peu : elle peut être privée ou professionnelle.",
              ),

              SizedBox(height: 12),
              _SubTitle("• À destination d’un tiers"),
              _Paragraph(
                "L’auteur doit s’en prendre à un message adressé à autrui : on ne viole pas le secret de sa propre correspondance.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Le mode d’acheminement est indifférent (La Poste, coursier, etc.).",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " précise que les correspondances peuvent être « arrivées ou non à destination » : l’atteinte peut se produire "
                      "alors que la correspondance n’est pas encore ou n’est plus acheminée.",
                ),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Pour les juges du fond, il suffit que le pli litigieux ait été, lors de son ouverture, en voie d’acheminement "
                        "(l’expéditeur s’en était dessaisi et il n’était pas encore parvenu à son destinataire).",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un acte matériel d’atteinte"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " vise plusieurs comportements : ouvrir, supprimer, retarder, détourner une correspondance, "
                      "ou prendre frauduleusement connaissance de son contenu.",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("• Ouvrir une correspondance"),
              _Paragraph(
                "Cela consiste à violer la fermeture quelconque d’une correspondance. Est sanctionné tout acte portant atteinte "
                "à l’intégrité du support et donnant accès au contenu, quel que soit le moyen utilisé : violent (déchirer) ou plus subtil "
                "(décacheter à la vapeur).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’altération peut être totale ou partielle. Peu importe que la correspondance ait été ensuite renvoyée vers son destinataire.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Un gérant d’immeuble puni pour avoir ouvert un courrier adressé à une locataire avant de lui distribuer ",
                  ),
                  TextSpan(
                    text: "(C.A. Toulouse, 13 janvier 2000)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("• Supprimer une correspondance"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La jurisprudence définit la suppression comme « tout acte qui a pour effet d’empêcher qu’elle parvienne à destination » ",
                ),
                TextSpan(
                  text: "(Cass. crim., 23 novembre 1849)",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Cela peut consister en une mise au rebut, une destruction, ou même une conservation empêchant la remise.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Une secrétaire de mairie qui avait jeté à la poubelle, après l’avoir lue, une lettre envoyée au maire ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 09 janvier 1996)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("• Retarder une correspondance"),
              _Paragraph(
                "Retarder consiste à faire arriver plus tard qu’il ne faut, après le moment fixé ou attendu. "
                "L’acte se concrétise par le fait de retenir un message en interrompant le cours normal de son acheminement.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text:
                        "Un individu qui réexpédie une lettre avec la mention « inconnu » ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 08 octobre 1957)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "Le propriétaire d’un immeuble qui réexpédie le courrier de sa locataire à une boîte postale ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 09 février 1965)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "Le gardien d’un immeuble qui refuse de délivrer le courrier à la destinataire et le remet au préposé des postes ",
                  ),
                  TextSpan(
                    text: "(C.A. Aix-en-Provence, 26 janvier 1998)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("• Détourner une correspondance"),
              _Paragraph(
                "Le détournement se matérialise en modifiant le cours normal de la transmission : on réprime un retard "
                "infligé volontairement à la transmission de la correspondance.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Condamné pour détournement : un secrétaire de mairie conserve une lettre anonyme adressée à une employée "
                        "plus de deux mois avant remise à la destinataire ",
                  ),
                  TextSpan(
                    text: "(C.A. Aix-en-Provence, 17 mars 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                "• Prendre frauduleusement connaissance du contenu",
              ),
              _Paragraph.rich([
                TextSpan(text: "C’est le dernier cas prévu par "),
                TextSpan(
                  text: "l’article 226-15 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      ". C’est celui qui caractérise le mieux l’atteinte au secret : il peut être sanctionné de façon autonome, "
                      "même si, en pratique, il est souvent consécutif à une ouverture, un retard ou un détournement.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Dans certaines situations, une personne peut prendre connaissance frauduleusement du contenu d’une correspondance "
                "sans avoir elle-même commis les actes d’ouverture/suppression/retard/détournement.",
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
              _SubTitle("Mauvaise foi (élément intentionnel)"),
              _Paragraph(
                "L’auteur doit agir en toute connaissance de cause : il sait que la correspondance ne lui était pas destinée "
                "et porte volontairement atteinte à sa transmission ou à son secret.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La Cour de cassation définit la « mauvaise foi » comme la connaissance que les lettres ne lui étaient pas destinées "
                        "et le fait de les conserver volontairement pour empêcher ou retarder leur transmission ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 15 mai 1990)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Détourner ou ouvrir une correspondance d’autrui par erreur ne constitue pas l’infraction : il s’agit d’une simple négligence "
                "ou imprudence (l’intention coupable fait défaut).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "L’intention de nuire n’est pas exigée. Le mobile importe peu.",
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Lorsque les faits sont commis par le conjoint, le concubin ou le partenaire lié à la victime par un pacte civil de solidarité (PACS).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "1 an d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 226-15 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Qualification aggravée : "),
                TextSpan(
                  text: "2 ans d’emprisonnement et 60 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 226-15 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 121-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text: "Tentative : NON (non prévue / non punissable).",
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI — conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Elle suppose un des faits constitutifs de complicité prévus par la loi : aide et assistance, provocation ou instructions données.",
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
