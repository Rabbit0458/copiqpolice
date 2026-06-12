import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCnilProtectionDonneesPage extends StatelessWidget {
  const PaCnilProtectionDonneesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/individuelles/cnil_protection_donnees';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF2962FF)
        : const Color(0xFF2962FF);
    final Color referenceColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'CNIL & protection des données',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // =====================================================
          // EN-TÊTE / INTRO
          // =====================================================
          Text(
            "La Commission Nationale de l’Informatique et des Libertés",
            textAlign: TextAlign.center,
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: .2,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  "Selon l’article 1 de la loi n° 78-17 du 6 janvier 1978 relative à l’informatique, aux fichiers et aux libertés, "
                  "« l’informatique doit être au service de chaque citoyen. Son développement doit s’opérer dans le cadre de la coopération internationale. "
                  "Elle ne doit porter atteinte ni à l’identité humaine, ni aux droits de l’homme, ni à la vie privée, ni aux libertés individuelles ou publiques ». ",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  "La loi n° 2018-493 du 20 juin 2018 a modifié la loi Informatique et Libertés afin de mettre en conformité le droit national avec le cadre juridique européen. "
                  "Elle permet la mise en œuvre concrète du règlement général sur la protection des données (RGPD) et de la directive « police-justice » applicable aux fichiers de la sphère pénale. ",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  "La CNIL est le régulateur français des données personnelles : elle accompagne les professionnels dans leur mise en conformité et aide les particuliers à maîtriser leurs données et à exercer leurs droits.",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 16),

          // =====================================================
          // CHAPITRE 1 — STATUT DE LA CNIL
          // =====================================================
          _HypoCard(
            title: "Chapitre 1 — Le statut de la CNIL",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // 1.1
              Text(
                "1.1 — La composition",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La CNIL est composée de 18 membres nommés pour cinq ans :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: "4 parlementaires (2 députés, 2 sénateurs) ;"),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "2 représentants du Conseil économique, social et environnemental ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "6 représentants des hautes juridictions (2 conseillers auprès du Conseil d’État, de la Cour de cassation et de la Cour des comptes) ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "5 personnalités qualifiées désignées par le président de l’Assemblée nationale, le président du Sénat et en conseil des ministres ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le président de la CADA (Commission d’accès aux documents administratifs).",
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Elle comprend en outre, avec voix consultative, le Défenseur des droits. "
                      "Depuis la loi n° 2014-873 du 4 août 2014 pour l’égalité réelle entre les femmes et les hommes, la parité doit être assurée au sein de la CNIL.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.2
              Text(
                "1.2 — Le fonctionnement",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le président de la CNIL est nommé par décret du président de la République parmi les membres de la commission pour une durée de cinq ans (article 9). "
                      "Le gouvernement, les autorités publiques et les dirigeants d’entreprises publiques ou privées ne peuvent s’opposer à l’action de la commission "
                      "et doivent prendre toutes les mesures utiles pour faciliter sa tâche (article 18).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La CNIL établit chaque année un rapport public qu’elle présente au président de la République, au Premier ministre et au Parlement (article 8). "
                      "Dans l’exercice de leurs attributions, les agents de la commission sont soumis au secret professionnel "
                      "dans les conditions prévues aux articles 226-13 et 413-10 du Code pénal (article 11).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.3
              Text(
                "1.3 — Une autorité administrative indépendante",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La CNIL est une autorité administrative indépendante (AAI). "
                      "Il s’agit d’un organisme public agissant au nom de l’État, sans être placé sous l’autorité du gouvernement ou d’un ministre. "
                      "Cette indépendance renforce sa légitimité lorsqu’elle contrôle l’action de l’État lui-même, notamment en matière de fichiers de police et de justice.",
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — MISSIONS DE LA CNIL
          // =====================================================
          _HypoCard(
            title: "Chapitre 2 — Les missions de la CNIL",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les missions de la CNIL sont définies par l’article 8 de la loi n° 78-17 du 6 janvier 1978. "
                      "Pour accomplir ces missions, la commission peut adopter des recommandations et prendre des décisions individuelles ou réglementaires dans les cas prévus par la loi.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.1
              Text(
                "2.1 — Informer des droits et des obligations",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La CNIL informe toutes les personnes concernées et tous les responsables de traitements de leurs droits et obligations. "
                      "Elle peut, à cette fin, apporter une information adaptée aux collectivités territoriales, à leurs groupements ainsi qu’aux petites et moyennes entreprises.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.2
              Text(
                "2.2 — Veiller au respect de la loi et aux dispositions relatives à la protection des données",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Elle veille à ce que les traitements de données à caractère personnel soient mis en œuvre conformément à la loi Informatique et Libertés, "
                      "au RGPD et aux autres textes relatifs à la protection des données personnelles. "
                      "Dans ce cadre, elle dispose de pouvoirs de contrôle sur place ou sur pièces et peut prononcer des mises en demeure ou des sanctions.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.3
              Text(
                "2.3 — Délivrer un label",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La CNIL délivre des labels à des produits ou à des procédures tendant à la protection des données à caractère personnel, "
                      "attestant leur conformité aux dispositions de la loi. Ces labels constituent un outil de confiance pour les usagers et les partenaires.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.4
              Text(
                "2.4 — Se tenir informée de l’évolution des technologies de l’information",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La CNIL se tient informée de l’évolution des technologies de l’information et de la communication. "
                      "Elle rend publique, le cas échéant, son appréciation des conséquences de ces évolutions sur l’exercice des droits et libertés, "
                      "par exemple à propos de la vidéoprotection, des objets connectés, de l’intelligence artificielle ou de la reconnaissance faciale.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.5
              Text(
                "2.5 — Présenter des observations devant toute juridiction",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La CNIL peut présenter des observations devant toute juridiction, à l’occasion d’un litige relatif à l’application de la loi Informatique et Libertés "
                      "ou des dispositions relatives à la protection des données à caractère personnel prévues par les textes législatifs et réglementaires, "
                      "par le droit de l’Union européenne ou par les engagements internationaux de la France.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les infractions aux dispositions de la loi du 6 janvier 1978 sont prévues et réprimées par les articles 226-16 à 226-24 du Code pénal. "
                      "Il s’agit de délits, assortis de peines d’amende et parfois d’emprisonnement.",
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 3 — PROTECTION DES DONNÉES
          // =====================================================
          _HypoCard(
            title: "Chapitre 3 — La protection des données",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Constitue un fichier de données à caractère personnel tout ensemble structuré de données à caractère personnel accessibles selon des critères déterminés, "
                      "que cet ensemble soit centralisé, décentralisé ou réparti de manière fonctionnelle ou géographique (article 2 de la loi).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le RGPD a supprimé la plupart des déclarations préalables de fichiers auprès de la CNIL. "
                      "Seules subsistent certaines formalités pour des secteurs sensibles, comme la santé ou la police-justice.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.1
              Text(
                "3.1 — Conditions de mise en œuvre de certains traitements de données relevant de l’État",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le législateur a expressément maintenu, pour certaines catégories de traitements à risques relevant du secteur public, "
                      "et en particulier pour les traitements dits de souveraineté, un régime de demande d’avis auprès de la CNIL. "
                      "Sont visés les traitements qui intéressent la sûreté de l’État, la défense ou la sécurité publique, "
                      "ou ceux ayant pour objet la prévention, la recherche, la constatation ou la poursuite des infractions pénales, "
                      "ainsi que l’exécution des condamnations pénales ou des mesures de sûreté (article 31).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les traitements de données à caractère personnel mis en œuvre pour le compte de l’État, "
                      "agissant dans l’exercice de ses prérogatives de puissance publique, qui portent sur des données génétiques "
                      "ou sur des données biométriques nécessaires à l’authentification ou au contrôle de l’identité des personnes, "
                      "sont autorisés par décret en Conseil d’État, après avis motivé et publié de la CNIL (article 32).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les actes autorisant la création d’un tel traitement doivent préciser notamment :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la finalité du traitement et, le cas échéant, sa dénomination ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: "le service auprès duquel s’exerce le droit d’accès ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "les catégories de données à caractère personnel enregistrées ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "les destinataires ou catégories de destinataires habilités à recevoir communication de ces données ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le cas échéant, les dérogations à l’obligation d’information des personnes concernées ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le cas échéant, les limitations et restrictions aux droits des personnes concernées ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le cas échéant, la désignation, parmi les responsables conjoints du traitement, du point de contact pour les personnes concernées.",
                ),
              ]),
              const SizedBox(height: 14),

              // 3.2
              Text(
                "3.2 — Les droits des personnes sur leurs données",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Sont ici évoquées principalement les dispositions relatives aux traitements mis en œuvre à des fins de prévention et de détection des infractions pénales, "
                      "d’enquêtes et de poursuites en la matière ou d’exécution de sanctions pénales, ainsi qu’à la libre circulation de ces données.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 3.2.1
              Text(
                "3.2.1 — Information de la personne concernée (article 104)",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le responsable du traitement doit mettre à disposition de la personne concernée notamment :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "l’identité et les coordonnées du responsable de traitement et, le cas échéant, celles de son représentant ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le cas échéant, les coordonnées du délégué à la protection des données (DPO) ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "les finalités poursuivies par le traitement auquel les données sont destinées ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le droit d’introduire une réclamation auprès de la Commission nationale de l’informatique et des libertés (CNIL) et les coordonnées de celle-ci ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "l’existence du droit de demander au responsable de traitement l’accès aux données personnelles, leur rectification ou leur effacement, "
                      "ainsi que le droit de demander la limitation du traitement des données personnelles concernant la personne.",
                ),
              ]),
              const SizedBox(height: 10),

              // 3.2.2
              Text(
                "3.2.2 — Un droit d’accès direct (article 105)",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Toute personne peut demander si des données à caractère personnel la concernant sont ou ne sont pas traitées. "
                      "Si tel est le cas, elle peut obtenir des informations sur ce traitement (finalités, base juridique, catégories de données concernées, etc.).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 3.2.3
              Text(
                "3.2.3 — Droit de rectification, de complément et d’effacement (article 106)",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La personne concernée peut demander au responsable d’un fichier de procéder à la rectification des données personnelles inexactes, "
                      "au complément des données incomplètes, ainsi qu’à l’effacement des données dont la conservation serait contraire à la loi. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les décisions judiciaires et les dossiers faisant l’objet d’une procédure pénale ne sont pas régis par ces dispositions : "
                      "l’accès à ces données et les conditions de rectification ou d’effacement sont prévus par le Code de procédure pénale (article 111), "
                      "par exemple pour les modalités d’effacement des données inscrites dans le TAJ (articles 230-8 et 230-9 du C.P.P.).",
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 24),

          // PETIT FOCUS OPÉRATIONNEL
          _NotaBox(
            title: "Enjeux pratiques pour les services de police",
            bodySpans: [
              TextSpan(
                text:
                    "Les fichiers de police (TAJ, FPR, fichiers de la circulation, etc.) sont soumis au contrôle de la CNIL. "
                    "Toute création ou consultation doit reposer sur un fondement légal clair, une finalité déterminée et un accès strictement limité aux missions de service. "
                    "En cas de doute, il convient de se référer aux textes réglementaires et aux référents « protection des données » de l’unité.",
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE DE CONTENU (bloc structuré)
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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

/// ------------------------------------------------------------------
/// PARAGRAPHES (texte simple ou riche)
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? "",
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans);

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans});

  final String title = 'NOTA';
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title :",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / MISE EN GARDE
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withValues(alpha: .95),
          ),
          children: [
            TextSpan(
              text: "$title : ",
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
