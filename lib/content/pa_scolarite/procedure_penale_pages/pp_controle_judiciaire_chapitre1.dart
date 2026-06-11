import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPControleJudiciaireChapitre1Page extends StatelessWidget {
  const PaPPControleJudiciaireChapitre1Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_chapitre1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color accent = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    const Color articleRed = Color(0xFFD32F2F);

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
          'Le contrôle judiciaire — Chapitre 1',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            'LE CONTRÔLE JUDICIAIRE',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.1,
              letterSpacing: .4,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          const _Paragraph.rich([
            TextSpan(
              text:
                  'Les nombreuses critiques apportées au système de la détention provisoire ont conduit le législateur, par la loi du 17 juillet 1970, à créer le contrôle judiciaire. Le but initial de cette mesure était d’éviter le recours à la détention provisoire chaque fois qu’elle n’était pas absolument nécessaire.',
            ),
          ]),
          const SizedBox(height: 6),
          const _Paragraph(
            'La loi n° 2000-516 du 15 juin 2000, renforçant la protection de la présomption d’innocence et les droits des victimes, a aménagé plusieurs dispositions relatives au contrôle judiciaire.',
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title:
                'CHAPITRE 1 — Conditions de mise en œuvre du contrôle judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _SubTitle('1.1 — Définition'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le contrôle judiciaire est une mesure de contrainte qui permet de restreindre l’exercice de la liberté de la personne mise en cause par l’imposition d’obligations et par un contrôle exercé sur elle. Il est prévu à ',
                ),
                TextSpan(
                  text: 'l’article 137 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. Cette mesure reste très souple et peut s’adapter à des situations extrêmement diverses.',
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle('1.1.1 — Conditions de mise en œuvre'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le contrôle judiciaire n’est possible que si la personne poursuivie est punissable d’une peine d’emprisonnement correctionnel au minimum. Cette règle résulte de ',
                ),
                TextSpan(
                  text: 'l’article 138 alinéa 1 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. Il est donc exclu pour une simple contravention ou pour un délit uniquement puni d’une peine d’amende.',
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                'Le contrôle judiciaire peut être prononcé à l’encontre d’une personne laissée en liberté ou à l’occasion de la libération d’une personne provisoirement détenue.',
              ),

              SizedBox(height: 10),

              _SubTitle('1.1.2 — À qui s’applique-t-il ?'),
              _Paragraph(
                'Le contrôle judiciaire peut s’appliquer à toute personne mise en examen : personne physique ou personne morale. Il peut également être mis en œuvre à l’encontre d’un mineur, dans le respect des règles particulières de la justice pénale des mineurs.',
              ),

              SizedBox(height: 14),

              _SubTitle(
                '1.2 — Conditions du placement sous contrôle judiciaire',
              ),
              _Paragraph(
                'La décision de placement sous contrôle judiciaire peut être prise par plusieurs autorités, selon le stade de la procédure. Il s’agit toujours d’une décision motivée et individualisée, tenant compte de la personnalité de l’intéressé et des nécessités de la procédure.',
              ),
              SizedBox(height: 10),
              _BulletPoint(text: 'par le juge d’instruction ;'),
              _BulletPoint(
                text: 'par le juge des libertés et de la détention ;',
              ),
              _BulletPoint(text: 'par la chambre de l’instruction ;'),
              _BulletPoint(
                text: 'par la juridiction de jugement compétente.',
              ),

              SizedBox(height: 12),

              _SubTitle('1.2.1 — Décision du juge d’instruction'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge d’instruction ne peut prononcer le contrôle judiciaire qu’en raison des nécessités de l’instruction ou à titre de mesure de sûreté, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 137 alinéa 2 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. La décision prend la forme d’une ordonnance de placement sous contrôle judiciaire, prévue par ',
                ),
                TextSpan(
                  text: 'l’article 139 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              SizedBox(height: 10),

              _SubTitle(
                '1.2.2 — Décision du juge des libertés et de la détention',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque le juge des libertés et de la détention est saisi par le juge d’instruction en vue d’un placement en détention provisoire, il peut, par ordonnance motivée, refuser la détention et décider un placement sous contrôle judiciaire. Cette faculté est expressément prévue par ',
                ),
                TextSpan(
                  text: 'l’article 145 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge des libertés et de la détention peut également ordonner un contrôle judiciaire dans le cadre de la procédure de comparution sur reconnaissance préalable de culpabilité, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 495-10 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              SizedBox(height: 10),

              _SubTitle(
                '1.2.3 — Placement par la chambre de l’instruction',
              ),
              _Paragraph(
                'La chambre de l’instruction peut ordonner le placement sous contrôle judiciaire dans différentes hypothèses :',
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    'en cas d’appel ou de saisine directe de la chambre par le procureur de la République ;',
              ),
              _BulletPoint(
                text:
                    'lorsqu’elle décide de la mise en liberté de la personne mise en examen, ou lorsqu’elle statue sur l’appel d’une ordonnance de placement sous contrôle judiciaire ou d’une ordonnance refusant la mise en liberté ;',
              ),
              _BulletPoint(
                text:
                    'lorsqu’elle dessaisit le juge d’instruction en évoquant l’affaire et en la jugeant elle-même.',
              ),

              SizedBox(height: 10),

              _SubTitle(
                '1.2.4 — Placement par les juridictions de jugement',
              ),
              _Paragraph(
                'Les juridictions de jugement (tribunal correctionnel, cour d’assises, juridiction pour mineurs) peuvent, depuis leur saisine par l’ordonnance ou l’acte de renvoi, ordonner le placement sous contrôle judiciaire et ce jusqu’à la décision définitive de jugement.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title:
                '1.3 — Obligations du contrôle judiciaire applicables aux personnes physiques',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Les obligations susceptibles d’être imposées dans le cadre du contrôle judiciaire sont énumérées par ',
                ),
                TextSpan(
                  text: 'l’article 138 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. Les autorités compétentes choisissent, parmi ces mesures, celles qui apparaissent les mieux adaptées à la personnalité de la personne mise en examen et aux nécessités de la procédure.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Certaines obligations ont pour objet d’assurer une véritable surveillance de la personne (obligation de pointage, interdiction de paraître dans certains lieux, interdiction de rencontrer certaines personnes, remise de documents, etc.).',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'D’autres mesures ont un objectif d’assistance de la personne (obligation de suivre un traitement, obligation d’exercice d’une activité professionnelle ou de formation, etc.), tandis que les dernières visent directement à garantir les droits de la victime (interdiction d’entrer en contact avec elle, de se rendre à son domicile ou à son lieu de travail, etc.).',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title:
                '1.4 — Obligations du contrôle judiciaire applicables aux personnes morales',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le contrôle judiciaire peut également être ordonné à l’encontre d’une personne morale mise en examen. ',
                ),
                TextSpan(
                  text: 'L’article 706-45 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' prévoit que le juge d’instruction peut placer la personne morale sous contrôle judiciaire et prononcer à son encontre une ou plusieurs des obligations prévues aux alinéas 2 à 6 de ce texte.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Ces obligations sont adaptées à la nature même de la personne morale : interdiction d’exercer certaines activités, obligation de constituer des garanties, mise en conformité avec la réglementation, etc.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title: '1.5 — Organisation du contrôle judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Le juge d’instruction doit veiller personnellement à la bonne application des mesures de contrôle judiciaire qu’il a ordonnées. Pour ce faire, il désigne des personnes physiques ou morales (services de police ou de gendarmerie, service judiciaire, contrôleur judiciaire…) chargées de vérifier que la personne mise en examen se conforme effectivement aux obligations imposées.',
              ),
              SizedBox(height: 6),
              _Paragraph(
                'Ces intervenants rendent compte régulièrement au juge d’instruction du comportement de l’intéressé et l’informent sans délai si celui-ci se soustrait à tout ou partie de ses obligations.',
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque la personne mise en examen se soustrait volontairement aux obligations du contrôle judiciaire, le juge d’instruction peut décerner à son encontre un mandat d’arrêt ou un mandat d’amener. S’il l’estime nécessaire, il peut également saisir le juge des libertés et de la détention aux fins de placement en détention provisoire. Ce dernier peut alors décerner un mandat de dépôt, conformément à ',
                ),
                TextSpan(
                  text: 'l’article 141-2 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Ces mêmes pouvoirs appartiennent aux juridictions de jugement lorsqu’elles sont saisies de l’affaire : elles peuvent adapter les obligations, les renforcer, ou décider d’un placement en détention provisoire en cas de manquement grave.',
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Dans la logique de l’échelle des mesures de contrainte, le contrôle judiciaire constitue une alternative à la détention provisoire. Il doit toujours être préféré dès lors qu’il permet d’atteindre les objectifs de la procédure (présence de la personne, protection des victimes, prévention du renouvellement de l’infraction…) sans recourir à l’incarcération.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
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
  const _NotaBox({required this.bodySpans});

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
