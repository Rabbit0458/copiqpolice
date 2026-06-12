// lib/pa/dps_dpg/cadres_juridiques/commission_rogatoire_chapitre2_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCommissionRogatoireChapitre2Page extends StatelessWidget {
  const PaCommissionRogatoireChapitre2Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre2';

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

    final Color cardPurple = isDark
        ? const Color(0xFF1B1530)
        : const Color(0xFFEDE7F6);
    const cardPurpleAccent = Color(0xFF5E35B1);

    final Color cardTeal = isDark
        ? const Color(0xFF00363A)
        : const Color(0xFFE0F2F1);
    const cardTealAccent = Color(0xFF00695C);

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
          'Commission rogatoire — Chapitre 2',
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
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            'Chapitre 2\nLe formalisme de la commission rogatoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mentions obligatoires, forme écrite, diffusion et principales distinctions '
            'entre commissions rogatoires générales, spéciales, contre une personne '
            'dénom­mée, contre X et internationales.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 12),

          const _IntroBullet(
            text:
                'Toute commission rogatoire doit être écrite, datée, signée par le magistrat '
                'qui la délivre et indiquer la nature de l’infraction et l’objet des poursuites.',
          ),
          const _IntroBullet(
            text:
                'Le formalisme de la commission rogatoire garantit la traçabilité des actes '
                'délégués et la protection des droits des personnes mises en cause.',
          ),
          const SizedBox(height: 14),

          // ================================================================
          // ARTICLE 151 AL. 2 CPP & RAPPEL DE LA FORME ÉCRITE
          // ================================================================
          const _ExempleBox(
            title: 'Article 151 alinéa 2 du Code de procédure pénale',
            bodySpans: [
              TextSpan(
                text:
                    'La commission rogatoire indique la nature de l’infraction et l’objet des '
                    'poursuites. Elle est datée et signée par le magistrat qui la délivre et '
                    'revêtue de son sceau.',
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _Paragraph(
            'La commission rogatoire doit donc obligatoirement revêtir une forme écrite. '
            'En pratique, l’officier de police judiciaire conserve et peut exhiber la '
            'commission rogatoire au cours de ses opérations, même si aucun texte n’impose '
            'expressément cette présentation matérielle.',
          ),
          const SizedBox(height: 8),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'Lorsque la commission rogatoire prescrit des opérations simultanées ',
            ),
            TextSpan(
              text: 'en plusieurs lieux du territoire, ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  'le juge d’instruction peut en ordonner la diffusion, par tout moyen adapté, '
                  'aux autres juges d’instruction ou aux officiers de police judiciaire '
                  'chargés de son exécution, conformément à l’article D.35 du Code de '
                  'procédure pénale.',
            ),
          ]),
          const SizedBox(height: 18),

          // ================================================================
          // 2.1 — COMMISSION ROGATOIRE GÉNÉRALE / SPÉCIALE
          // ================================================================
          _ConditionCard(
            title:
                '2.1 — Commission rogatoire générale, commission rogatoire spéciale',
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _SubTitle('2.1.1 — La commission rogatoire générale'),
              _Paragraph(
                'La commission rogatoire dite « générale » peut être large quant aux actes '
                'd’enquête et d’instruction qu’elle autorise. Le magistrat instructeur ne '
                'détaille pas nécessairement chaque acte, mais confère à l’officier de '
                'police judiciaire une certaine latitude pour accomplir tous les actes '
                'nécessaires à la manifestation de la vérité.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'En revanche, la commission rogatoire ne peut jamais être générale quant '
                'aux infractions : elle doit viser une ou plusieurs infractions déterminées, '
                'correspondant précisément à l’objet des poursuites.',
              ),
              SizedBox(height: 12),
              _SubTitle('2.1.2 — La commission rogatoire spéciale'),
              _Paragraph(
                'Par opposition à la commission rogatoire générale, la commission rogatoire '
                'dite « spéciale » délègue une mission précisément définie à l’officier de '
                'police judiciaire. Elle mentionne un ou plusieurs actes limitativement '
                'énumérés par le magistrat.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Exemples : entendre un témoin déterminé, saisir un dossier ou un support '
                    'informatique identifié, procéder à une perquisition dans un lieu donné, '
                    'exploiter une vidéoprotection, etc.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ================================================================
          // 2.2 — COMMISSION ROGATOIRE CONTRE PERSONNE DÉNOMMÉE / CONTRE X
          // ================================================================
          _ConditionCard(
            title:
                '2.2 — Commission rogatoire contre personne dénommée, ou contre X',
            cardColor: cardPurple,
            accent: cardPurpleAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF4527A0),
            children: const [
              _SubTitle(
                '2.2.1 — La commission rogatoire délivrée contre une personne dénommée',
              ),
              _Paragraph(
                'Lorsque le juge d’instruction estime qu’il existe, à l’encontre d’une '
                'personne déterminée, des indices suffisants de participation à une '
                'infraction, il peut envisager sa mise en examen et délivrer une '
                'commission rogatoire afin de préciser certains points encore obscurs.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Dans ce cas, la commission rogatoire mentionne expressément dans son '
                'libellé l’identité de la personne mise en examen et la désignation de '
                'l’infraction qui lui est reprochée.',
              ),
              SizedBox(height: 12),
              _SubTitle('2.2.2 — La commission rogatoire délivrée contre X'),
              _Paragraph(
                'La commission rogatoire peut également être délivrée « contre X », lorsque '
                'les auteurs de l’infraction ne sont pas encore identifiés ou lorsque des '
                'vérifications supplémentaires sont nécessaires avant toute mise en examen.',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'Premier cas : l’infraction est connue, une information judiciaire est '
                    'ouverte, mais l’enquête n’a pas encore permis, au moment de la '
                    'délivrance de la commission rogatoire, d’identifier les véritables '
                    'auteurs. La commission rogatoire décrira alors l’infraction et les '
                    'circonstances, sans pouvoir désigner les personnes mises en cause.',
              ),
              _BulletPoint(
                text:
                    'Deuxième cas : une information est ouverte et des indices apparaissent '
                    'contre une ou plusieurs personnes déterminées. Il appartient alors au '
                    'juge d’instruction d’apprécier si ces personnes peuvent ou non être '
                    'mises en examen.',
              ),
              _BulletPoint(
                text:
                    'La mise en examen ne peut intervenir qu’après que le juge d’instruction '
                    's’est assuré que la personne a, au vu des éléments recueillis, pu '
                    'prendre part à l’acte reproché dans des conditions de nature à engager '
                    'sa responsabilité pénale.',
              ),
              _Paragraph(
                'Dans cette perspective, une commission rogatoire délivrée contre X peut '
                'permettre au juge d’instruction de recueillir toutes les informations '
                'complémentaires nécessaires avant de prendre une décision de mise en '
                'examen nommément désignée.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ================================================================
          // 2.3 — COMMISSIONS ROGATOIRES INTERNATIONALES
          // ================================================================
          _ConditionCard(
            title: '2.3 — Les commissions rogatoires internationales',
            cardColor: cardTeal,
            accent: cardTealAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: const [
              _Paragraph(
                'Des commissions rogatoires internationales peuvent être adressées à des '
                'autorités étrangères pour exécution ou, inversement, être reçues de '
                'l’étranger par les autorités françaises. Le plus souvent, ces mécanismes '
                's’inscrivent dans le cadre de conventions internationales bilatérales ou '
                'multilatérales conclues entre États.',
              ),
              SizedBox(height: 10),
              _SubTitle('2.3.1 — Forme'),
              _Paragraph(
                'Les commissions rogatoires internationales revêtent en principe une forme '
                'comparable, quel que soit l’État destinataire. L’autorité qui émet la '
                'demande doit être clairement identifiée dans le document.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'La commission rogatoire internationale doit exposer de la manière la plus '
                'précise possible les faits reprochés, indiquer les qualifications pénales '
                'retenues ainsi que la référence des textes applicables et préciser '
                'exactement l’objet de la mission confiée à l’État requis.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Elle est, en pratique, souvent accompagnée d’une traduction dans la langue '
                'de l’État requis et porte le sceau de l’autorité qui la délivre.',
              ),
              SizedBox(height: 10),
              _SubTitle('2.3.2 — Mission'),
              _Paragraph(
                'Les commissions rogatoires internationales ont pour objet principal '
                'l’accomplissement d’actes d’instruction ou la communication de pièces '
                'à conviction.',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'Les missions portent le plus souvent sur l’audition de témoins, les '
                    'vérifications bancaires ou la réalisation de perquisitions à '
                    'l’étranger.',
              ),
              SizedBox(height: 10),
              _SubTitle('2.3.3 — Exécution'),
              _Paragraph.rich([
                TextSpan(
                  text: 'L’article 694-5 du Code de procédure pénale ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'prévoit que les interrogatoires, auditions ou confrontations '
                      'réalisés à l’étranger à la demande des autorités judiciaires '
                      'françaises sont exécutés conformément aux dispositions du Code de '
                      'procédure pénale français, sauf si une convention internationale '
                      'prévoit des modalités différentes.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                'L’article 4 de la convention relative à l’entraide judiciaire en matière '
                'pénale entre les États membres de l’Union européenne du 29 mai 2000 '
                'dispose que l’État requis respecte, en principe, les formalités de '
                'procédure expressément indiquées par l’État requérant. Il peut toutefois '
                'écarter les formalités ou procédures qui seraient contraires aux '
                'principes fondamentaux de son propre système juridique.',
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ================================================================
          // NOTA / JURISPRUDENCE
          // ================================================================
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'la jurisprudence rappelle que le magistrat instructeur français n’a pas '
                    'compétence pour apprécier la régularité d’un acte au regard de la '
                    'législation étrangère. La ',
              ),
              TextSpan(
                text: 'lex fori ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text:
                    's’applique en effet aux conditions de fond comme de forme des actes '
                    'd’instruction réalisés en France. (Chambre criminelle de la Cour de '
                    'cassation, décision n°16-87114 du 7 juin 2017).',
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// =====================================================================
///  WIDGETS UTILISÉS (mêmes classes que pour le chapitre 1)
/// =====================================================================

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
