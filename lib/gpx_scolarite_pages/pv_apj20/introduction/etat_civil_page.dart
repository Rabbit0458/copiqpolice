import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVEtatCivilPage extends StatelessWidget {
  const PVEtatCivilPage({super.key});

  static const String routeName = '/gpx/pv_apj20/introduction/etat_civil';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardS = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardP = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardG = isDark
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
          "PV — APJ 20",
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
            "L’état-civil",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (ici : cadre APJ20 + collecte d'identité)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 20 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : rappelle les missions des agents de police judiciaire, notamment la constatation des infractions et la réception des déclarations par procès-verbal, ce qui implique le recueil rigoureux de l’identité des personnes concernées.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Définition / objectif
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’identité permet de désigner, de reconnaître ou de retrouver une personne. Les informations doivent être recueillies en respectant un ordre précis.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Qu’il rapporte des faits ou relate des propos, le policier est amené à relever l’identité de personnes (victime, témoin, requérant, suspect). Selon le type de procès-verbal, elle est présentée différemment.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I. Identité succincte
          _ConditionCard(
            title: "II — L’identité succincte",
            cardColor: cardS,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Elle est employée dans la marge des procès-verbaux. Elle sert à désigner toute personne dont le nom apparaît dans la procédure sans qu’il soit procédé à son audition.",
              ),
              SizedBox(height: 12),
              _SubTitle("Elle comporte"),
              _BulletPoint(text: "Nom"),
              _BulletPoint(text: "Prénom usuel"),
              _BulletPoint(text: "Âge"),
              _BulletPoint(text: "Profession"),
              _BulletPoint(text: "Domicile"),
            ],
          ),

          const SizedBox(height: 14),

          // II. Petite identité
          _ConditionCard(
            title: "III — La petite identité",
            cardColor: cardP,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Elle est insérée dans le corps du procès-verbal lorsque la personne entendue ou interrogée n’est pas mise en cause (victime, témoin).",
              ),
              SizedBox(height: 12),
              _SubTitle("Elle comporte"),
              _BulletPoint(text: "Nom"),
              _BulletPoint(text: "Prénoms"),
              _BulletPoint(text: "Date et lieu de naissance"),
              _BulletPoint(
                text:
                    "Nationalité (si vol du document d’identité ou si nationalité étrangère)",
              ),
              _BulletPoint(text: "Profession"),
              _BulletPoint(text: "Domicile"),
              _BulletPoint(text: "Numéro de téléphone"),
              _BulletPoint(
                text:
                    "Adresse mail (pour communication ultérieure avec la police/gendarmerie et/ou la justice)",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III. Grande identité
          _ConditionCard(
            title: "IV — La grande identité",
            cardColor: cardG,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Elle doit être relevée lorsque le policier se trouve en présence de l’auteur d’un crime ou d’un délit. Elle comporte des mentions très complètes permettant d’identifier sans ambiguïté la personne.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Identité — personne concernée"),
              const _BulletPoint(
                text:
                    "Nom patronymique en LETTRES CAPITALES (dit « de jeune fille »).",
              ),
              const _BulletPoint(text: "Prénom usuel en lettres minuscules."),
              const _BulletPoint(
                text:
                    "Autre état civil : divorcé, époux, veuf… (suivi du nom d’époux).",
              ),
              const _BulletPoint(
                text:
                    "Date et lieu de naissance : préciser le pays ou le département + arrondissement pour grandes villes.",
              ),
              const _BulletPoint(
                text:
                    "Filiation : nom/prénom du père (avec mention « DÉCÉDÉ » si besoin) ; nom de jeune fille + prénom de la mère.",
              ),
              const _BulletPoint(text: "Nationalité."),

              const SizedBox(height: 12),

              const _SubTitle("B) Adresse"),
              const _BulletPoint(text: "Domicile (au sens du droit civil)."),
              const _BulletPoint(
                text:
                    "Pays, département, commune + arrondissement (grandes villes).",
              ),
              const _BulletPoint(text: "Numéro et nom de la voie."),
              const _BulletPoint(
                text:
                    "Précisions : bâtiment, code d’accès, étage, porte d’entrée, etc.",
              ),
              const _BulletPoint(
                text: "Téléphone domicile et autres coordonnées.",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "C) Communication électronique (police/gendarmerie/justice)",
              ),
              const _BulletPoint(text: "Oui (préciser l’adresse mail) ou non."),

              const SizedBox(height: 12),

              const _SubTitle("D) Compléments d’identité"),
              const _BulletPoint(
                text:
                    "Titre d’occupation : locataire, propriétaire, occupant à titre gratuit.",
              ),
              const _BulletPoint(
                text:
                    "Propriétaire (si besoin) : nom et adresse ; montant du loyer ou du crédit.",
              ),
              const _BulletPoint(
                text:
                    "Complément nationalité (étranger) : nature/références du titre de séjour + dates (délivrance/expiration).",
              ),
              const _BulletPoint(
                text:
                    "État de la personne : vulnérabilité éventuelle ; n° de sécurité sociale.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("E) Situation de famille"),
              const _BulletPoint(
                text:
                    "Statut : célibataire, concubinage, divorce, mariage, séparé, veuf, PACS.",
              ),
              const _BulletPoint(
                text:
                    "Conjoint : nom/prénom + date/lieu de l’union ; nombre et âge des enfants.",
              ),
              const _BulletPoint(
                text:
                    "Ex-conjoint : si séparation/divorce : nom/prénom + date/lieu ; nombre/âge des enfants + droit de garde.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("F) Emploi / employeur"),
              const _BulletPoint(text: "Activité professionnelle."),
              const _BulletPoint(text: "Statut : employé ou à son compte."),
              const _BulletPoint(
                text: "Date de début d’activité, salaire mensuel.",
              ),
              const _BulletPoint(text: "Adresse employeur."),

              const SizedBox(height: 12),

              const _SubTitle("G) Diplôme / distinction"),
              const _BulletPoint(
                text: "Niveau d’étude : analphabète ou niveau d’instruction.",
              ),
              const _BulletPoint(text: "Diplômes obtenus."),
              const _BulletPoint(text: "Situation militaire."),
              const _BulletPoint(
                text: "Décoration, distinction, pension (civile ou militaire).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("H) Permis / armes"),
              const _BulletPoint(
                text:
                    "Permis : nature (conduite, chasse, pêche), catégorie, numéro, date et lieu de délivrance.",
              ),
              const _BulletPoint(
                text:
                    "Arme détenue : références d’autorisation (défense / sportif) + numéro, date, lieu ; armes détenues (nature, catégorie, marque, calibre, numéro).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("I) Antécédents judiciaires"),
              const _BulletPoint(
                text: "Ne jamais évoquer une condamnation amnistiée.",
              ),
              const _BulletPoint(
                text:
                    "Mentionner « NS » (non spécifié) si la personne est connue des services de police ou de justice.",
              ),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Astuce rédaction",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Recueillir dans un ordre fixe évite les oublis. En pratique, commence par l’identité stricte, puis l’adresse, puis les compléments (famille, emploi, titres, etc.).",
                  ),
                ],
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
