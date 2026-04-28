import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AtteinteRepresentationPersonnePage extends StatelessWidget {
  const AtteinteRepresentationPersonnePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_representation_personne';

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
          "Atteintes à la personnalité",
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
            "L’atteinte à la représentation de la personne",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (claire + pédagogique)
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Constitue une infraction le fait de porter à la connaissance du public ou d’un tiers, par quelque voie que ce soit, "
                "le montage réalisé avec les paroles ou l’image d’une personne sans son consentement, "
                "si l’on ne voit pas à l’évidence qu’il s’agit d’un montage ou si cela n’est pas expressément indiqué.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Est assimilé à cette infraction le fait de diffuser un contenu visuel ou sonore généré par un traitement algorithmique "
                "(ex. « deepfake ») représentant l’image ou les paroles d’une personne sans son consentement, "
                "si le caractère artificiel n’est pas évident ou n’est pas clairement mentionné.",
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
                TextSpan(
                  text: "Article 226-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime l’atteinte à la représentation de la personne (montage / contenu généré algorithmiquement).",
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
              const _SubTitle("A) Un montage (paroles / image)"),
              const _Paragraph(
                "Le montage peut porter sur :\n"
                "• la voix (imitation, reproduction, déformation) ;\n"
                "• l’image (trucage d’une photo/vidéo, découpage, détourage, synchronisation, etc.).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’objectif typique est de faire croire qu’une personne (identifiée par son image ou sa voix) "
                "a tenu un discours ou réalisé des actes alors qu’il n’en est rien. "
                "Le procédé technique employé importe peu : l’infraction vise le résultat trompeur diffusé.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "JURISPRUDENCE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Créer des blogs/profils au nom d’un tiers uniquement par l’écrit, sans montage de parole ou d’image, "
                        "ne relève pas de l’article 226-8 (",
                  ),
                  TextSpan(
                    text: "Cass. crim., 24 janvier 2018, n° 16-83.045",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "PRÉCISION",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le montage est réprimé lorsqu’il déforme délibérément des images ou des paroles, "
                        "par ajout ou retrait d’éléments étrangers à son objet (",
                  ),
                  TextSpan(
                    text: "Cass. crim., 30 mars 2016, n° 15-82.039",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Un contenu visuel/sonore généré algorithmiquement (deepfake)",
              ),
              const _Paragraph(
                "L’hypertrucage (« deepfake ») repose sur l’intelligence artificielle et peut :\n"
                "• superposer/fusionner des images (changement de visage sur une vidéo) ;\n"
                "• substituer des propos en reproduisant la voix ;\n"
                "• générer un contenu artificiel à partir d’un modèle source ;\n"
                "• produire des contenus réalistes à partir de commandes textuelles.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Porter à la connaissance du public ou d’un tiers (par quelque voie que ce soit)",
              ),
              const _Paragraph(
                "Sont visés tous les moyens de diffusion ou de révélation (publication, envoi, partage, repartage…). "
                "Le texte permet aussi de sanctionner les personnes qui repartagent le contenu.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "PRESSE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si l’infraction est commise par voie de presse écrite/audiovisuelle, des règles spéciales s’appliquent. "
                        "La hiérarchie des responsables est notamment prévue par ",
                  ),
                  TextSpan(
                    text: "l’article 42 de la loi du 29 juillet 1881",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " (directeur de publication, à défaut l’auteur, puis l’imprimeur, puis vendeurs/distributeurs/afficheurs).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Absence de consentement (sauf montage évident ou signalé)",
              ),
              const _Paragraph(
                "Le consentement requis porte sur la publication/révélation à un tiers, pas sur la création du contenu. "
                "Ainsi, même si la personne a accepté la réalisation du montage/deepfake, l’accord à la diffusion demeure nécessaire.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Toutefois, l’accord à la publication n’est pas exigé dans deux hypothèses :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Le caractère de montage est évident : le public ne peut pas croire à l’authenticité du document.",
              ),
              const _BulletPoint(
                text:
                    "Il est expressément mentionné qu’il s’agit d’un montage (indication claire et non équivoque).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "IDÉE CLÉ",
                bodySpans: [
                  TextSpan(
                    text:
                        "Ces limites évitent de sanctionner des contenus à finalité simplement récréative (ex. montages humoristiques) "
                        "lorsque l’absence de tromperie est assurée.",
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
              _Paragraph(
                "L’infraction suppose la volonté de créer/diffuser un montage (ou un contenu généré algorithmiquement) "
                "dans une logique de tromperie du public (ou d’un tiers).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "PRÉCISION",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le résultat recherché (notoriété, profit, nuisance, etc.) importe peu : c’est la tromperie liée à la diffusion "
                        "sans consentement qui est au cœur de l’infraction.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstance aggravante
          _ConditionCard(
            title: "IV — Circonstance aggravante",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-8 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsque les faits sont réalisés en utilisant un service de communication au public en ligne.",
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
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Qualification simple : "),
                const TextSpan(
                  text: "1 an d’emprisonnement et 15 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 226-8 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Qualification aggravée (en ligne) : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 226-8 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "les articles 226-7 et 226-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — prévue par "),
                TextSpan(
                  text: "l’article 226-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Complicité : OUI — les règles générales s’appliquent (",
                ),
                TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ")."),
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
