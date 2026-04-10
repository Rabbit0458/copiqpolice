import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HierarchiePnPage extends StatelessWidget {
  const HierarchiePnPage({super.key});

  static const String routeName = '/pa/institution/organisation_pn/hierarchie';

  static const Color _lawRed = Color(0xFFE53935);

  static TextSpan _law(String text) {
    return const TextSpan(); // placeholder to satisfy analyzer in static context
  }

  @override
  Widget build(BuildContext context) {
    TextSpan law(String text) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardActive = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardAdmin = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardTech = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardOther = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
          "Hiérarchie",
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
            "Hiérarchie des personnels de la Police nationale",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Présentation",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La Police nationale comprend des personnels actifs, ainsi que des personnels administratifs, "
                "techniques et scientifiques soumis au statut général de la fonction publique. "
                "Ces fonctionnaires appartiennent à des corps organisés par niveaux hiérarchiques.\n\n"
                "Elle comprend aussi d’autres catégories d’agents concourant aux missions de sécurité : "
                "policiers adjoints, cadets de la République et réservistes.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Repères visuels — galonnage",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Appuie sur une image pour l’ouvrir en grand et zoomer (pincement).",
              ),
              SizedBox(height: 10),
              _OrgImageTile(
                title: "Corps de conception et de direction",
                subtitle: "Grades et appellations — commissaires",
                assetPath: "assets/images/ccd.png",
              ),
              SizedBox(height: 12),
              _OrgImageTile(
                title: "Corps de commandement",
                subtitle: "Grades et appellations — officiers",
                assetPath: "assets/images/cc.png",
              ),
              SizedBox(height: 12),
              _OrgImageTile(
                title: "Corps d’encadrement et d’application",
                subtitle: "Grades et appellations — gradés et gardiens",
                assetPath: "assets/images/cea.png",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "I — Personnels des services actifs",
            cardColor: cardActive,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Corps de conception et de direction"),
              const _Paragraph(
                "Il comprend les grades :\n"
                "• Commissaire général de police\n"
                "• Commissaire divisionnaire de police\n"
                "• Commissaire de police\n\n"
                "Il comprend aussi des emplois fonctionnels (direction/inspection) accessibles à partir du grade de commissaire divisionnaire.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Rôle"),
              const _Paragraph(
                "Les commissaires élaborent et mettent en œuvre les doctrines d’emploi et la direction des services. "
                "Ils assument une responsabilité opérationnelle et organique et exercent une autorité sur les personnels affectés.\n\n"
                "Placés à la tête d’une circonscription, d’un service (local, départemental ou zonal) ou d’un groupement de CRS, "
                "ils exercent des fonctions de conception et de direction.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Ils exercent les attributions de magistrat qui leur sont conférées par la loi.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Corps de commandement"),
              const _Paragraph(
                "Il comprend les grades :\n"
                "• Commandant divisionnaire de police\n"
                "• Commandant de police\n"
                "• Capitaine de police\n\n"
                "Appellations usuelles : « commandant » et « capitaine ».\n"
                "Durant les 4 premières années après titularisation, les officiers du premier grade prennent l’appellation « lieutenant ».\n\n"
                "Sous conditions d’ancienneté (et selon l’emploi exercé), des commandants peuvent être nommés à l’emploi de "
                "commandant divisionnaire fonctionnel.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Rôle"),
              const _Paragraph(
                "Les officiers secondent ou suppléent les commissaires dans l’exercice de leurs fonctions "
                "(sauf cas où la loi impose l’intervention du commissaire).\n\n"
                "Ils peuvent diriger certains services et commander l’ensemble des personnels placés sous leur autorité.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Ils exercent les attributions prévues par le ",
                ),
                law("Code de procédure pénale"),
                const TextSpan(
                  text:
                      " et des textes réglementaires propres à leur service d’emploi (discipline, formation, etc.).",
                ),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("C) Corps d’encadrement et d’application"),
              const _Paragraph(
                "Les gradés et gardiens participent aux missions des services actifs et exercent les compétences "
                "que leur confère le Code de procédure pénale.\n\n"
                "Les majors de police et brigadiers-chefs assurent l’encadrement des gardiens de la paix, des policiers adjoints "
                "et des membres de la réserve opérationnelle.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Grades & appellations usuelles"),
              const _BulletPoint(text: "Major de police — « major »."),
              const _BulletPoint(
                text: "Brigadier-chef de police — « brigadier-chef ».",
              ),
              const _BulletPoint(
                text:
                    "Gardien de la paix — « sous-brigadier » (gardien ayant atteint le 6e échelon) / « gardien ».",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Sous certaines conditions d’ancienneté et selon l’emploi exercé, les majors peuvent accéder à un emploi fonctionnel de responsable d’unité locale de police.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Personnels administratifs",
            cardColor: cardAdmin,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "A) Corps des attachés d’administration de l’intérieur",
              ),
              _Paragraph(
                "Grades :\n"
                "• Attaché principal\n"
                "• Attaché\n\n"
                "Les attachés exercent des tâches de gestion administrative, financière ou logistique, "
                "et peuvent encadrer des personnels / piloter une unité de gestion.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Corps des secrétaires administratifs"),
              _Paragraph(
                "Grades :\n"
                "• Classe exceptionnelle\n"
                "• Classe supérieure\n"
                "• Classe normale\n\n"
                "Ils réalisent les tâches administratives les plus importantes et peuvent encadrer des adjoints/agents administratifs. "
                "Certains peuvent être assistants d’enquête.",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Corps des adjoints administratifs"),
              _Paragraph(
                "Grades :\n"
                "• Adjoint administratif principal de 1re classe\n"
                "• Adjoint administratif principal de 2e classe\n"
                "• Adjoint administratif\n\n"
                "Ils participent à des tâches administratives variées : correspondance, classement, gestion de pièces et dossiers.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Personnels techniques et scientifiques",
            cardColor: cardTech,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Ingénieurs de la police technique et scientifique"),
              _Paragraph(
                "Grades :\n"
                "• Ingénieur en chef\n"
                "• Ingénieur principal\n"
                "• Ingénieur\n\n"
                "Ils effectuent constatations, examens et analyses demandés par les magistrats et services enquêteurs. "
                "Ils encadrent des personnels et peuvent diriger des unités selon leur compétence.",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "B) Techniciens de la police technique et scientifique",
              ),
              _Paragraph(
                "Grades :\n"
                "• Technicien en chef\n"
                "• Technicien principal\n"
                "• Technicien\n\n"
                "Ils assistent les ingénieurs, participent aux analyses, exploitent la documentation et peuvent encadrer "
                "les agents spécialisés.",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "C) Agents spécialisés de la police technique et scientifique",
              ),
              _Paragraph(
                "Grades :\n"
                "• Agent spécialisé principal\n"
                "• Agent spécialisé\n\n"
                "Ils interviennent notamment sur la signalisation, les scènes d’infraction, les prélèvements, "
                "l’exploitation des traces/indices et l’alimentation des fichiers.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title:
                "IV — Filière SIC (systèmes d’information et de communication)",
            cardColor: cardActive,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Ingénieurs SIC"),
              _Paragraph(
                "Grades :\n"
                "• Ingénieur hors classe\n"
                "• Ingénieur principal\n"
                "• Ingénieur\n\n"
                "Ils assurent conception, mise en œuvre, expertise, conseil, contrôle et encadrement.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Techniciens SIC"),
              _Paragraph(
                "Grades :\n"
                "• Classe exceptionnelle\n"
                "• Classe supérieure\n"
                "• Classe normale\n\n"
                "Ils exercent dans l’exploitation, la production, l’installation et la gestion des systèmes d’information et de communication.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Autres catégories d’agents",
            cardColor: cardOther,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Les policiers adjoints"),
              const _Paragraph(
                "Recrutés sous contrat (3 ans, renouvelable une fois), ils concourent aux missions de sécurité "
                "des personnes et des biens. Ils agissent sous l’autorité et la responsabilité de policiers titulaires.\n\n"
                "Sous certaines conditions, ils peuvent exercer les fonctions d’assistant d’enquête.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Ils disposent de la qualité d’agent de police judiciaire adjoint — ",
                ),
                law("article 21-1° ter du Code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Ils peuvent constater certaines contraventions au code de la route — ",
                ),
                law("article R. 130-1-1 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Les cadets de la République"),
              const _Paragraph(
                "Recrutés sous contrat (3 ans, renouvelable une fois), ils ont le statut de policier adjoint.\n"
                "La 1re année : formation spécifique de 12 mois + préparation au concours de gardien de la paix.\n"
                "Après cette année, ils peuvent se présenter au concours et sont affectés comme policiers adjoints.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Ils disposent également de la qualité d’APJA — ",
                ),
                law("article 21-1° ter du Code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("C) Les réservistes"),
              const _Paragraph(
                "1) Réserve opérationnelle : renfort temporaire aux forces de sécurité intérieure et missions de solidarité "
                "(hors maintien/rétablissement de l’ordre public). Elle peut inclure retraités des corps actifs et volontaires.\n\n"
                "2) Réserve citoyenne : missions bénévoles et occasionnelles (solidarité, médiation, éducation à la loi, prévention).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les réservistes citoyens n’ont aucune prérogative de puissance publique — ",
                ),
                law("article L. 411-18 du Code de la sécurité intérieure"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Condition de résidence/ intégration mentionnée notamment à ",
                ),
                law("l’article L. 413-7 du CESEDA"),
                const TextSpan(text: "."),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

/// ✅ Reprend exactement ton principe Organigrammes : tu appuies -> plein écran + zoom.
/// (Tu peux garder ce widget dans ce fichier, il ne touche pas à tes widgets personnalisés.)
class _OrgImageTile extends StatelessWidget {
  const _OrgImageTile({
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  final String title;
  final String subtitle;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color chipBg = isDark
        ? const Color(0xFF2B2B2B)
        : const Color(0xFFF2F2F2);
    final Color chipText = isDark ? Colors.white : const Color(0xFF1F1F1F);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openImageViewer(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (isDark ? Colors.white10 : Colors.black12).withOpacity(.8),
            width: 0.8,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                      color: chipText,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.open_in_full_rounded,
                  size: 18,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
                height: 1.2,
                color: isDark ? Colors.white : const Color(0xFF050505),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFEDEDED),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "Image introuvable :\n$assetPath",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Image',
      barrierColor: Colors.black.withOpacity(0.55),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0E0E0E) : Colors.white,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF0E0E0E) : Colors.white,
            elevation: 0,
            leading: IconButton(
              tooltip: "Fermer",
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.close_rounded,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            centerTitle: true,
            title: Text(
              title,
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          body: SafeArea(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 12.0,
              boundaryMargin: const EdgeInsets.all(200),
              constrained: false,
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Impossible d’ouvrir l’image.\nVérifie l’asset : $assetPath",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
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
