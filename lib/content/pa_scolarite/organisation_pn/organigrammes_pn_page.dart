import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganigrammesPnPage extends StatelessWidget {
  const OrganigrammesPnPage({super.key});

  static const String routeName =
      '/pa/institution/organisation_pn/organigrammes';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardMain = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardInfo = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardOrg = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);

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
          "Organigrammes",
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
            "Organisation — organigrammes principaux",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Comment utiliser cette page",
            cardColor: cardMain,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Chaque carte contient un organigramme officiel. "
                "Appuie sur une image pour l’ouvrir en grand et zoomer (pincement).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Vue d’ensemble",
            cardColor: cardInfo,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("Direction générale de la Police nationale"),
              _Paragraph(
                "Organigramme synthétique de l’organisation nationale et des principales directions et services.",
              ),
              SizedBox(height: 10),
              _OrgImageTile(
                title: "Organisation globale",
                subtitle:
                    "Direction générale de la Police nationale — vue d’ensemble",
                assetPath: "assets/images/organisation_pn.png",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Directions et services — organigrammes",
            cardColor: cardOrg,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "D.R.H.F.S — Direction des ressources humaines, des finances et des soutiens de la Police nationale",
              ),
              _OrgImageTile(
                title: "D.R.H.F.S",
                subtitle: "Structure de direction, services et sous-directions",
                assetPath: "assets/images/drhfs.png",
              ),
              SizedBox(height: 14),

              _SubTitle("I.G.P.N — Inspection générale de la Police nationale"),
              _OrgImageTile(
                title: "I.G.P.N",
                subtitle:
                    "Direction, secrétariat général, sous-directions et unités",
                assetPath: "assets/images/igpn.png",
              ),
              SizedBox(height: 14),

              _SubTitle(
                "D.N.P.J — Direction nationale de la Police judiciaire",
              ),
              _OrgImageTile(
                title: "D.N.P.J",
                subtitle:
                    "Pilotage stratégique, sous-directions, offices et services",
                assetPath: "assets/images/dnpj.png",
              ),
              SizedBox(height: 14),

              _SubTitle(
                "D.N.S.P — Direction nationale de la Sécurité publique",
              ),
              _OrgImageTile(
                title: "D.N.S.P",
                subtitle:
                    "Sous-directions (ordre public, performance, sécurité du quotidien, numérique)",
                assetPath: "assets/images/dnsp.png",
              ),
              SizedBox(height: 14),

              _SubTitle(
                "D.N.P.A.F — Direction nationale de la Police aux frontières",
              ),
              _OrgImageTile(
                title: "D.N.P.A.F",
                subtitle:
                    "Frontières, éloignement, numérique, aériens/maritimes, aéroports",
                assetPath: "assets/images/dnpaf.png",
              ),
              SizedBox(height: 14),

              _SubTitle("A.D.P — Académie de Police"),
              _OrgImageTile(
                title: "Académie de Police",
                subtitle:
                    "Formation, écoles nationales, pilotage, recherche et déontologie",
                assetPath: "assets/images/ap.png",
              ),
              SizedBox(height: 14),

              _SubTitle("S.D.L.P — Service de la protection"),
              _OrgImageTile(
                title: "S.D.L.P",
                subtitle:
                    "Protection rapprochée, sûreté, moyens mobiles, état-major",
                assetPath: "assets/images/sdlp.png",
              ),
              SizedBox(height: 14),

              _SubTitle("S.N.P.S — Service national de Police scientifique"),
              _OrgImageTile(
                title: "S.N.P.S",
                subtitle:
                    "Systèmes, biométrie, criminalistique, innovation, état-major",
                assetPath: "assets/images/snps.png",
              ),
              SizedBox(height: 14),

              _SubTitle(
                "D.C.I.S — Direction de la coopération internationale de sécurité",
              ),
              _OrgImageTile(
                title: "D.C.I.S",
                subtitle:
                    "Coopération bilatérale/multilatérale, administration, finances, cabinets",
                assetPath: "assets/images/dcis.png",
              ),
              SizedBox(height: 14),

              _SubTitle(
                "A.N.F.S.I — Agence du numérique des forces de sécurité intérieure",
              ),
              _OrgImageTile(
                title: "A.N.F.S.I",
                subtitle:
                    "Systèmes d’information, équipements numériques, convergence et sécurité",
                assetPath: "assets/images/anfsi.png",
              ),
            ],
          ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

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

    showGeneralDialog<void>(
      context: context,
      barrierLabel: "Image",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(.55),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, __, ___) {
        final controller = TransformationController();

        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Fond + viewer plein écran
                Positioned.fill(
                  child: Container(
                    color: isDark ? const Color(0xFF111111) : Colors.white,
                    child: Center(
                      child: InteractiveViewer(
                        transformationController: controller,
                        panEnabled: true,
                        scaleEnabled: true,
                        clipBehavior: Clip.none,
                        minScale: 1,
                        maxScale: 12,
                        boundaryMargin: const EdgeInsets.all(80),
                        child: GestureDetector(
                          // Double tap = zoom rapide
                          onDoubleTapDown: (details) {
                            final position = details.localPosition;

                            // Si déjà zoomé -> reset
                            final currentScale = controller.value
                                .getMaxScaleOnAxis();
                            if (currentScale > 1.01) {
                              controller.value = Matrix4.identity();
                              return;
                            }

                            // Zoom vers l'endroit tapé
                            const double zoom = 3.0;
                            final Matrix4 matrix = Matrix4.identity()
                              ..translate(
                                -position.dx * (zoom - 1),
                                -position.dy * (zoom - 1),
                              )
                              ..scale(zoom);

                            controller.value = matrix;
                          },
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Impossible d’ouvrir l’image.\nVérifie l’asset : $assetPath",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.fustat(
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bouton fermer
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(.10)
                              : Colors.black.withOpacity(.08),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // Mini aide en bas
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(.08)
                            : Colors.black.withOpacity(.06),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        "Pince pour zoomer • Glisse pour déplacer • Double-tap pour zoom",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(scale: curved, child: child),
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
