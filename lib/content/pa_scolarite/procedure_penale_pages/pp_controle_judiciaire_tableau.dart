import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPControleJudiciaireTableauPage extends StatelessWidget {
  const PaPPControleJudiciaireTableauPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_tableau';

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
          'Tableau — Contrôle judiciaire',
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
          // ===================================================================
          // TITRE
          // ===================================================================
          Text(
            'TABLEAU\nContrôle judiciaire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              letterSpacing: .3,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Synthèse des autorités compétentes pour ordonner le placement sous contrôle judiciaire '
            'ou en modifier les modalités, avec les principaux textes de référence.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================================================================
          // BLOC 1 — PLACEMENT
          // ===================================================================
          _ConditionCard(
            title: 'PLACEMENT sous contrôle judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                'Qui peut ordonner le placement sous contrôle judiciaire et à quel moment de la procédure ?',
              ),

              SizedBox(height: 10),
              _SubTitle('Par le juge d’instruction'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge d’instruction peut placer une personne sous contrôle judiciaire en raison des nécessités de '
                      'l’instruction ou à titre de mesure de sûreté, conformément à ',
                ),
                TextSpan(
                  text: 'l’Article 137 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      '. La décision prend la forme d’une ordonnance de placement, prévue par ',
                ),
                TextSpan(
                  text: 'l’Article 139 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                'Moment : à tout moment au cours de l’instruction.',
              ),

              SizedBox(height: 12),
              _SubTitle('Par le juge des libertés et de la détention'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le juge des libertés et de la détention peut décider d’un contrôle judiciaire :',
                ),
              ]),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'lorsqu’il est saisi par le juge d’instruction pour un placement en détention provisoire et qu’il refuse cette mesure, '
                    'en la remplaçant par un contrôle judiciaire, conformément à l’',
              ),
              // phrase suivante en rouge dans un paragraphe séparé pour être propre
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 145 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' ;'),
              ]),
              _BulletPoint(
                text:
                    'dans le cadre de la comparution sur reconnaissance préalable de culpabilité, où il peut assortir la peine proposée '
                    'd’un contrôle judiciaire, en application de l’',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article 495-10 du Code de procédure pénale',
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 4),
              _Paragraph(
                'Moment : lorsqu’il est saisi par le juge d’instruction (ou dans le cadre de la C.R.P.C.).',
              ),

              SizedBox(height: 12),
              _SubTitle('Par la chambre de l’instruction'),
              _Paragraph(
                'La chambre de l’instruction peut ordonner le placement sous contrôle judiciaire dans plusieurs situations :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'en cas d’appel d’une ordonnance du juge d’instruction ou de saisine directe par le procureur de la République ;',
              ),
              _BulletPoint(
                text:
                    'lorsqu’elle décide de la mise en liberté de la personne mise en examen et substitue le contrôle judiciaire à la détention ;',
              ),
              _BulletPoint(
                text:
                    'lorsqu’elle dessaisit le juge d’instruction en évoquant l’affaire et en connaissant elle-même de l’information.',
              ),
              SizedBox(height: 4),
              _Paragraph(
                'Moment : lorsque la chambre est saisie de l’information ou d’un appel portant sur la situation de la personne mise en examen.',
              ),

              SizedBox(height: 12),
              _SubTitle('Par les juridictions de jugement'),
              _Paragraph(
                'Les juridictions de jugement (tribunal correctionnel, cour d’assises, juridictions pour mineurs) peuvent elles aussi '
                'prononcer un contrôle judiciaire :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'à l’audience, sur réquisitions du ministère public ou à la demande de la personne poursuivie ou de la partie civile ;',
              ),
              _BulletPoint(
                text:
                    'depuis leur saisine par l’ordonnance ou l’acte de renvoi et jusqu’à la décision de jugement.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ===================================================================
          // BLOC 2 — MODIFICATION
          // ===================================================================
          _ConditionCard(
            title: 'MODIFICATION du contrôle judiciaire',
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: const [
              _Paragraph(
                'Les mêmes autorités peuvent adapter, alléger ou renforcer les obligations de contrôle judiciaire en fonction '
                'de l’évolution de la procédure et de la situation de la personne mise en examen.',
              ),

              SizedBox(height: 10),
              _SubTitle('Par le juge d’instruction'),
              _Paragraph(
                'À tout moment de l’instruction, le juge d’instruction peut :',
              ),
              SizedBox(height: 4),
              _BulletPoint(text: 'imposer de nouvelles obligations ;'),
              _BulletPoint(
                text: 'modifier une ou plusieurs obligations existantes ;',
              ),
              _BulletPoint(
                text: 'supprimer certaines obligations devenues inutiles ;',
              ),
              _BulletPoint(
                text:
                    'accorder une dispense temporaire d’observer certaines obligations lorsque la situation le justifie.',
              ),

              SizedBox(height: 12),
              _SubTitle('Par le juge des libertés et de la détention'),
              _Paragraph(
                'Le juge des libertés et de la détention peut également modifier le contrôle judiciaire lorsqu’il est saisi :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'dans le cadre d’un débat sur la détention provisoire (placement ou prolongation) ;',
              ),
              _BulletPoint(
                text:
                    'à l’occasion d’une audience de contrôle des mesures de sûreté, en renforçant ou en assouplissant le contrôle judiciaire.',
              ),

              SizedBox(height: 12),
              _SubTitle('Par la chambre de l’instruction'),
              _Paragraph(
                'La chambre de l’instruction, lorsqu’elle connaît d’un appel ou lorsqu’elle s’est réservée le contentieux du contrôle '
                'judiciaire, peut :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text: 'confirmer les obligations existantes ou les modifier ;',
              ),
              _BulletPoint(
                text:
                    'substituer d’autres obligations plus adaptées (par exemple interdire certains lieux, personnes, activités, etc.) ;',
              ),
              _BulletPoint(
                text:
                    'lever tout ou partie des obligations lorsque les nécessités de l’instruction ont évolué.',
              ),

              SizedBox(height: 12),
              _SubTitle('Par les juridictions de jugement'),
              _Paragraph(
                'Les juridictions de jugement disposent, jusqu’au règlement définitif de l’affaire, du pouvoir de :',
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    'maintenir le contrôle judiciaire prononcé au cours de l’instruction ;',
              ),
              _BulletPoint(
                text:
                    'adapter les obligations aux conditions de la comparution de la personne (travail, domicile, éloignement de la victime, etc.) ;',
              ),
              _BulletPoint(
                text:
                    'prononcer la mainlevée totale du contrôle judiciaire lorsque celui-ci ne se justifie plus.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ===================================================================
          // NOTA
          // ===================================================================
          const _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'Ce tableau reprend les grands principes applicables au contrôle judiciaire. Les durées et les modalités '
                    'de certaines procédures ont été adaptées par la réforme récente de la justice pénale, notamment la ',
              ),
              TextSpan(
                text: 'loi n° 2023-1059 du 20 novembre 2023',
                style: TextStyle(
                  color: articleRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text:
                    ', dont plusieurs dispositions sont entrées en vigueur à compter du 3 septembre 2024 et impactent les procédures '
                    'applicables devant le tribunal correctionnel.',
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
