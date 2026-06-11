import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAtteinteIntimiteViePriveePage extends StatelessWidget {
  const PaAtteinteIntimiteViePriveePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_intimite_vie_privee';

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
            "L’atteinte à l’intimité de la vie privée",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / faits visés
          _ConditionCard(
            title: "Définition — faits visés",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph("Constituent des infractions :"),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    "la captation, l’enregistrement ou la transmission, sans son consentement, des paroles d’une personne prononcées à titre privé ou confidentiel.",
              ),
              _IntroBullet(
                text:
                    "la fixation, l’enregistrement ou la transmission, sans son consentement, de l’image d’une personne se trouvant dans un lieu privé.",
              ),
              _IntroBullet(
                text:
                    "la captation, l’enregistrement ou la transmission de la localisation (en temps réel ou en différé) d’une personne, sans son consentement.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La conservation, l’utilisation ou la divulgation d’un document ou d’un enregistrement issu de ces agissements constitue également une infraction.",
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
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime les atteintes à l’intimité de la vie privée d’une personne.",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime la conservation, la diffusion ou l’utilisation de tout document ou enregistrement obtenu à l’aide d’une atteinte à l’intimité de la vie privée.",
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
              _SubTitle("A) Au moyen d’un procédé quelconque"),
              _Paragraph(
                "Sont visés toutes les méthodes permettant de parvenir au résultat recherché : "
                "dispositifs techniques (appareils, logiciels, balises…) mais aussi procédés ne faisant pas appel à un appareil.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "B) Captation / enregistrement / transmission des paroles privées ou confidentielles",
              ),

              SizedBox(height: 6),
              _SubTitle("• La captation"),
              _Paragraph(
                "Le Code pénal vise notamment l’audition par un ou des tiers, grâce à des moyens techniques appropriés, "
                "de conversations (par ex. téléphoniques). Sont également concernés les propos tenus de vive voix alors "
                "que le locuteur est éloigné de toute oreille indiscrète, mais rendus audibles par des moyens clandestins "
                "de captation ou d’amplification.",
              ),

              SizedBox(height: 10),
              _SubTitle("• L’enregistrement"),
              _Paragraph(
                "C’est le fait d’enregistrer, au moyen d’un appareil quelconque, des paroles prononcées à titre privé. "
                "L’infraction est constituée quels que soient les résultats techniques : elle peut l’être même si les propos "
                "enregistrés sont inaudibles.",
              ),

              SizedBox(height: 10),
              _SubTitle("• La transmission"),
              _Paragraph(
                "Elle vise tout moyen permettant la mise à disposition, à un ou plusieurs destinataires avertis, "
                "de la parole indûment captée. L’expédition d’un enregistrement matériel ou dématérialisé peut constituer cette transmission.",
              ),

              SizedBox(height: 10),
              _SubTitle("• Paroles « privées ou confidentielles »"),
              _Paragraph(
                "Le délit est constitué dès lors que les paroles captées ou enregistrées ont été prononcées "
                "dans un lieu privé ou public : l’important est qu’elles n’avaient pas vocation à être rendues publiques "
                "(intimité ou volonté d’entourer les propos d’une part de secret).",
              ),

              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : l’enregistrement de la parole ou de l’image d’une personne placée en garde à vue "
                        "n’échappe pas ipso facto au champ d’application de l’atteinte à l’intimité de la vie privée ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 21 avril 2020)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("• Sans le consentement de la personne"),
              _Paragraph(
                "L’auteur des paroles n’a pas donné son accord pour qu’elles soient captées, enregistrées ou transmises. "
                "À l’inverse, le consentement est présumé lorsque l’atteinte est accomplie au vu et au su de cette personne "
                "sans qu’elle s’y soit opposée, alors même qu’elle pouvait le faire.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : l’infraction n’est pas caractérisée si l’acte est réalisé au vu et au su "
                        "de la personne sans établir qu’elle s’y opposait ; la charge de la preuve ne pèse pas sur le prévenu "
                        "mais sur le ministère public ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 28 mars 2023)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Mineur",
                bodySpans: [
                  TextSpan(
                    text:
                        "Dans le cas d’un mineur, le consentement doit émaner des titulaires de l’autorité parentale "
                        "dans le respect de ",
                  ),
                  TextSpan(
                    text: "l’article 372-1 du Code civil",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle(
                "C) Fixation / enregistrement / transmission de l’image d’une personne en un lieu privé",
              ),
              _Paragraph(
                "Toute personne a le droit d’interdire la reproduction, sans autorisation, de son image : "
                "elle constitue le prolongement de sa personnalité. Ce droit vaut que la personne soit anonyme ou publique.",
              ),

              SizedBox(height: 10),
              _SubTitle("• La fixation"),
              _Paragraph(
                "Cela inclut le recours aux appareils photos ou caméras vidéo.",
              ),

              SizedBox(height: 10),
              _SubTitle("• L’enregistrement"),
              _Paragraph(
                "L’image fixe ou animée est sauvegardée sur tout type de support (numérique ou technologies plus anciennes).",
              ),

              SizedBox(height: 10),
              _SubTitle("• La transmission"),
              _Paragraph(
                "Tout transfert du support de l’image illicite vers un ou des tiers avertis tombe sous le coup de cette incrimination.",
              ),

              SizedBox(height: 10),
              _SubTitle("• De l’image d’une personne"),
              _Paragraph(
                "Est exclue la photographie du lieu de vie d’une personne ou de biens, même prise sans consentement : "
                "c’est bien l’image de la personne qui est visée.",
              ),

              SizedBox(height: 10),
              _SubTitle("• En un lieu privé"),
              _Paragraph(
                "Le champ de l’infraction est restreint : le lieu privé n’est pas ouvert à tous, sauf autorisation de celui "
                "qui l’occupe de manière permanente ou temporaire.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : le lieu privé est un endroit non ouvert à tous sauf autorisation ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 28 novembre 2006)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La notion de lieu privé s’apprécie au cas par cas (exemples admis) :",
              ),
              SizedBox(height: 8),
              _BulletPoint(text: "Une chambre d’hôpital."),
              _BulletPoint(text: "Une prison."),
              _BulletPoint(text: "Un commissariat."),

              SizedBox(height: 12),
              _SubTitle("• Sans le consentement de la personne"),
              _Paragraph(
                "On retrouve les mêmes principes que pour les paroles, y compris lorsqu’il s’agit d’un mineur.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Ne tombent pas sous le coup de cet article :\n",
                  ),
                  TextSpan(
                    text:
                        "• procédé photo police/gendarmerie pour matérialité d’un excès de vitesse ",
                  ),
                  TextSpan(
                    text: "(Cass. 2e civ., 29 juin 1988)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "• prise de photos dans le cadre de la signalisation anthropométrique à l’occasion d’une enquête judiciaire ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 décembre 2003)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle(
                "D) Captation / enregistrement / transmission de la localisation (temps réel ou différé) sans consentement",
              ),
              _SubTitle("• La captation"),
              _Paragraph(
                "Tout dispositif technique est envisageable : placement clandestin d’une balise sur une personne ou un véhicule, "
                "installation d’un logiciel espion sur un moyen de communication mobile, etc.",
              ),
              SizedBox(height: 10),
              _SubTitle("• L’enregistrement"),
              _Paragraph(
                "Les données de localisation (positionnement, éventuellement horodatage) sont stockées sur tout support.",
              ),
              SizedBox(height: 10),
              _SubTitle("• La transmission"),
              _Paragraph(
                "Les données sont mises à disposition d’un ou de plusieurs tiers avertis. "
                "Peu importe que cela s’opère en temps réel, en différé ou en un seul bloc.",
              ),
              SizedBox(height: 10),
              _SubTitle("• Localisation temps réel ou différé"),
              _Paragraph(
                "Le niveau de précision importe peu : relais de communication ou GPS précis.",
              ),
              SizedBox(height: 10),
              _SubTitle("• Sans le consentement de la personne"),
              _Paragraph(
                "La personne n’a pas donné son accord à la localisation. La présomption de consentement prévue pour "
                "les paroles et l’image ne s’applique pas à la localisation, car elle est très facilement clandestine.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Mineur",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le consentement doit émaner des titulaires de l’autorité parentale. "
                        "Il suffit de l’opposition de l’un d’eux pour rendre la localisation illicite, "
                        "dans le respect de ",
                  ),
                  TextSpan(
                    text: "l’article 372-1 du Code civil",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle(
                "E) Conservation / divulgation / utilisation d’un document ou enregistrement obtenu par atteinte à la vie privée",
              ),
              _Paragraph(
                "Il s’agit d’une infraction de conséquence : le « produit » des atteintes prévues par l’incrimination principale. "
                "Le terme « document » inclut tous supports, y compris ceux liés au suivi géographique.",
              ),
              SizedBox(height: 12),
              _SubTitle("• La conservation"),
              _Paragraph(
                "Indépendamment de toute divulgation ou utilisation, le simple fait de garder à disposition le produit "
                "de l’atteinte est réprimé (prévention de publication, chantage ultérieur, etc.).",
              ),
              SizedBox(height: 10),
              _SubTitle("• L’utilisation"),
              _Paragraph(
                "Elle peut avoir lieu en public ou non : par exemple l’usage d’enregistrements illicites dans une procédure de divorce.",
              ),
              SizedBox(height: 10),
              _SubTitle("• La diffusion"),
              _Paragraph(
                "Est punissable la divulgation au sens large : presse, radio, télévision (objectif grand public) ou simple "
                "communication à un tiers jusqu’alors ignorant la nature de ce qui est dévoilé.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Presse",
                bodySpans: [
                  TextSpan(
                    text:
                        "Quand l’infraction est commise par voie de presse écrite ou audiovisuelle, des règles particulières "
                        "s’appliquent pour la détermination des responsables, avec notamment une hiérarchie prévue par ",
                  ),
                  TextSpan(
                    text: "l’article 42 de la loi du 29 juillet 1881",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
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
              _SubTitle("A) Conscience de se livrer à un acte illicite"),
              _Paragraph(
                "L’auteur sait que les paroles ont vocation à demeurer dans un cercle restreint (voire à rester secrètes). "
                "Pour les images, il a connaissance de la nature privée du lieu où il procède à l’atteinte.",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "B) Volonté de porter atteinte à la vie privée d’autrui",
              ),
              _Paragraph(
                "L’auteur décide de ne pas respecter la vie privée de la victime, quelle que soit sa motivation "
                "(enrichissement, règlement de compte, volonté de nuire, etc.).",
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
                  text: "Article 226-1 alinéa 7 du Code pénal",
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
                    "Lorsque les faits sont commis par le conjoint, le concubin, ou le partenaire lié par un PACS.",
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-1 alinéa 8 du Code pénal",
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
                    "Lorsque les faits sont commis au préjudice d’une personne dépositaire de l’autorité publique, chargée d’une mission de service public, titulaire d’un mandat électif public, candidate à un tel mandat ou d’un membre de sa famille.",
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-2-1 alinéa 1 du Code pénal",
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
                    "Lorsque les faits portent sur des paroles ou des images présentant un caractère sexuel prises dans un lieu public ou privé.",
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
                TextSpan(text: "Atteinte simple : "),
                TextSpan(
                  text: "1 an d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 226-1 du Code pénal",
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
                  text: "Conservation / diffusion / utilisation : ",
                ),
                TextSpan(
                  text: "1 an d’emprisonnement et 45 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 226-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Formes aggravées : "),
                TextSpan(
                  text: "2 ans d’emprisonnement et 60 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 226-1 al. 7 et al. 8 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " ; et "),
                TextSpan(
                  text: "article 226-2-1 al. 1 du Code pénal",
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
                  text: "l’article 226-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 226-5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
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
                "Elle suppose un fait constitutif de complicité prévu par la loi : aide et assistance, provocation ou instructions données.",
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
