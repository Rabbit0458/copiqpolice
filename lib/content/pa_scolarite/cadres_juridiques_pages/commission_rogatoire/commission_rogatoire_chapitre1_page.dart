// lib/pa/dps_dpg/cadres_juridiques/commission_rogatoire_chapitre1_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCommissionRogatoireChapitre1Page extends StatelessWidget {
  const PaCommissionRogatoireChapitre1Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);

    final Color cardGreen = isDark
        ? const Color(0xFF0F2416)
        : const Color(0xFFE8F5E9);
    const cardGreenAccent = Color(0xFF2E7D32);

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
          'Commission rogatoire — Chapitre 1',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ==================================================================
          // TITRE PRINCIPAL
          // ==================================================================
          Text(
            'Chapitre 1\nLes autorités délégantes et les autorités délégataires',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Origine de la commission rogatoire, juridictions habilitées à la délivrer '
            'et services de police ou de gendarmerie chargés de son exécution.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 14),

          // ==================================================================
          // PETIT RÉSUMÉ SOUS FORME DE PUCE D'INTRO
          // ==================================================================
          const _IntroBullet(
            text:
                'Les juridictions d’instruction et de jugement peuvent délivrer une commission rogatoire.',
          ),
          const _IntroBullet(
            text:
                'En pratique, la plupart des commissions rogatoires émanent du juge d’instruction.',
          ),
          const _IntroBullet(
            text:
                'L’exécution revient aux officiers de police judiciaire, dans les limites de leurs compétences matérielle et territoriale.',
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // 1.1 — LES AUTORITÉS DÉLÉGANTES
          // ==================================================================
          const _SubTitle('1.1 — Les autorités délégantes'),
          const SizedBox(height: 4),
          const _Paragraph(
            'Toute juridiction d’instruction ou de jugement dispose du pouvoir de délivrer '
            'une commission rogatoire. Il s’agit notamment : du juge d’instruction '
            '(article 81 du Code de procédure pénale — CPP), de la chambre de '
            'l’instruction (article 205 CPP), du tribunal de police (article 538 CPP), '
            'du tribunal correctionnel (article 463 CPP), du président de la cour '
            'd’assises (article 283 CPP) et du président de la cour criminelle '
            'départementale (article 380-19 CPP).',
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'En pratique, la situation la plus courante demeure celle où la commission '
            'rogatoire émane du juge d’instruction, dans le cadre d’une information '
            'judiciaire qu’il dirige.',
          ),
          const SizedBox(height: 10),

          // EXEMPLE / CITATION ARTICLE 81 AL. 4 CPP
          const _ExempleBox(
            title: 'Article 81 alinéa 4 du Code de procédure pénale',
            bodySpans: [
              TextSpan(
                text:
                    'Lorsque le juge d’instruction ne peut pas accomplir lui-même tous les actes '
                    'nécessaires à l’information, il peut donner commission rogatoire aux '
                    'officiers de police judiciaire afin qu’ils exécutent, pour son compte, '
                    'les actes d’information nécessaires dans les conditions et sous les '
                    'réserves prévues aux articles 151 et 152 du Code de procédure pénale.',
              ),
            ],
          ),
          const SizedBox(height: 10),

          // CIRCULAIRE 1er MARS 1993 -> EXEMPLE
          const _ExempleBox(
            title: 'Circulaire du 1er mars 1993 (extrait)',
            bodySpans: [
              TextSpan(
                text:
                    'La circulaire précise que la possibilité de délivrer une commission '
                    'rogatoire est réservée aux situations où il est réellement impossible '
                    'pour le juge d’instruction d’agir lui-même. Il peut s’agir, par exemple, '
                    'd’opérations qui, en pratique, sont réalisées par les officiers de '
                    'police judiciaire (missions de surveillance, de recherche, filatures) '
                    'ou d’actes nécessitant des moyens matériels dont le magistrat ne '
                    'dispose pas.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // 1.2 — LES AUTORITÉS DÉLÉGATAIRES
          // ==================================================================
          const _SubTitle('1.2 — Les autorités délégataires'),
          const SizedBox(height: 4),
          const _Paragraph.rich([
            TextSpan(
              text: 'L’article 151 alinéa 1 du Code de procédure pénale ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  'prévoit que le juge d’instruction peut, par commission rogatoire, requérir '
                  'tout juge de son tribunal, tout autre juge d’instruction ou tout officier '
                  'de police judiciaire, lequel en informe alors le procureur de la République, '
                  'afin de procéder aux actes d’information nécessaires dans les lieux où '
                  'chacun d’eux est territorialement compétent.',
            ),
          ]),
          const SizedBox(height: 8),
          const _Paragraph(
            'En pratique policière, on retient surtout que tous les officiers de police '
            'judiciaire du ressort d’un même tribunal ont vocation à exécuter les '
            'commissions rogatoires, sous réserve du respect de leurs compétences '
            'territoriales et des instructions données par le magistrat.',
          ),
          const SizedBox(height: 10),
          const _Paragraph(
            'Le juge d’instruction dispose d’une liberté de choix quant à la formation ou au '
            'service chargé d’exécuter la commission rogatoire (article D.2 alinéa 3 CPP). '
            'Il doit toutefois tenir compte de la spécialisation de certains services ou '
            'directions (par exemple, la direction nationale de la police judiciaire, la '
            'direction nationale de la police aux frontières – article D.4 CPP). Le choix du '
            'service exécutant dépend donc des circonstances de l’affaire.',
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'En raison de la hiérarchisation des services de police et de gendarmerie, '
            'l’article D.33 du Code de procédure pénale précise que lorsque le juge '
            'd’instruction adresse une commission rogatoire à un officier de police '
            'judiciaire chef de service ou de détachement, celui-ci peut en confier '
            'l’exécution à un autre officier de police judiciaire placé sous son autorité, '
            'à condition que ce dernier agisse dans les limites de sa compétence territoriale.',
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'La circulaire du 1er mars 1993 admet que, pour une même affaire, le juge '
            'd’instruction puisse délivrer plusieurs commissions rogatoires à différents '
            'services de police ou de gendarmerie, lorsque des vérifications distinctes '
            'doivent être menées dans des lieux différents et selon des diligences bien '
            'séparées.',
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'Seuls les officiers de police judiciaire peuvent recevoir directement une '
            'commission rogatoire. Cependant, les agents de police judiciaire et les '
            'assistants d’enquête peuvent, sous certaines conditions, être chargés par les '
            'officiers de police judiciaire d’exécuter certains actes dans le cadre de cette '
            'délégation.',
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // BLOC 1.2.1 — COMPÉTENCE MATÉRIELLE (ConditionCard + BulletPoint)
          // ==================================================================
          _ConditionCard(
            title:
                '1.2.1 — Compétence matérielle des officiers de police judiciaire',
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: 'Base légale : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'article 151 du Code de procédure pénale. L’officier de police judiciaire '
                      'exécute, sur commission rogatoire, les actes d’information nécessaires '
                      'qui lui sont délégués par le juge d’instruction.',
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Les actes d’instruction réalisés doivent être directement liés à la '
                    'répression de l’infraction visée par les poursuites (article 151 alinéa 3 CPP).',
              ),
              _BulletPoint(
                text:
                    'L’officier de police judiciaire ne peut pas interroger ni confronter une '
                    'personne mise en examen. Il ne peut entendre les parties civiles ni les '
                    'témoins assistés que si ces derniers en font eux-mêmes la demande '
                    '(article 152 alinéa 2 CPP).',
              ),
              _BulletPoint(
                text:
                    'L’officier de police judiciaire ne peut ni ordonner une expertise, ni '
                    'délivrer des mandats : ces prérogatives demeurent réservées au magistrat.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // BLOC 1.2.2 — COMPÉTENCE TERRITORIALE (ConditionCard + IntroBullet)
          // ==================================================================
          _ConditionCard(
            title:
                '1.2.2 — Compétence territoriale des officiers de police judiciaire',
            cardColor: cardGreen,
            accent: cardGreenAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 18 alinéa 1 du Code de procédure pénale : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'les officiers de police judiciaire sont compétents dans les limites '
                      'territoriales où ils exercent habituellement leurs fonctions.',
                ),
              ]),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    'L’article 18 alinéa 3 étend la compétence territoriale d’un officier de '
                    'police judiciaire à l’ensemble du territoire national, à condition qu’il '
                    'en informe au préalable le juge d’instruction en charge de l’enquête. '
                    'Cette information peut être donnée par tout moyen et doit être mentionnée '
                    'dans un procès-verbal.',
              ),
              _IntroBullet(
                text:
                    'Le juge peut exiger que les enquêteurs soient assistés par un officier de '
                    'police judiciaire territorialement compétent. À défaut d’instruction '
                    'expresse, il appartient aux enquêteurs d’apprécier si cette assistance '
                    'est nécessaire.',
              ),
              _IntroBullet(
                text:
                    'Aucune information préalable n’est requise lorsque le déplacement a lieu '
                    'dans un ressort limitrophe de celui où l’officier exerce ses fonctions. '
                    'Paris et les départements des Hauts-de-Seine, de Seine-Saint-Denis et du '
                    'Val-de-Marne sont, à ce titre, considérés comme un seul et même ressort.',
              ),
              SizedBox(height: 10),
              _Paragraph(
                'L’article 18 alinéa 4 permet en outre aux officiers de police judiciaire, sur '
                'commission rogatoire expresse du juge d’instruction et avec l’accord des '
                'autorités compétentes, de procéder à des auditions sur le territoire d’un '
                'État étranger. Dans ce cas, leur compétence est limitée à l’infraction pour '
                'laquelle ils ont été initialement saisis.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Le procureur de la République territorialement compétent doit être informé de '
                'ces opérations internationales. En pratique, cette information est souvent '
                'transmise par l’officier de police judiciaire lui-même, même si elle émane '
                'à l’origine du magistrat ayant prescrit l’acte.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // NOTA / INFO FINALE (APJ, APJ adjoints, assistants d'enquête)
          // ==================================================================
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'seuls les officiers de police judiciaire sont compétents pour mettre en '
                    'œuvre une commission rogatoire. Cependant, les agents de police '
                    'judiciaire et les agents de police judiciaire adjoints peuvent les '
                    'assister dans les limites territoriales où les officiers exercent leurs '
                    'attributions (article 21-1 CPP). Les assistants d’enquête peuvent eux '
                    'aussi être chargés, par les officiers de police judiciaire, de certaines '
                    'tâches matérielles ou techniques dans le cadre de l’exécution de la '
                    'commission rogatoire (article 21-3 CPP).',
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// ======================================================================
///  WIDGETS UTILISÉS DANS LA PAGE
/// ======================================================================

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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (1., 2., 3. …)
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
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
/// PUCE D’INTRO
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

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
            '$title :',
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
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
