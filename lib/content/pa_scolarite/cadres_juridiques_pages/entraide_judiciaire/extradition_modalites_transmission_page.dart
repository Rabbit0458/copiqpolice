import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaExtraditionModalitesTransmissionPage extends StatelessWidget {
  const PaExtraditionModalitesTransmissionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/extradition_modalites_transmission';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color cardColor = isDark
? const Color(0xFF1E222A)
: const Color(0xFFFFFFFF);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

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
          'Modalités de transmission\net schémas procéduraux',
          textAlign: TextAlign.center,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          Text(
            'Extradition & mandat d’arrêt européen',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Synthèse des schémas de transmission des demandes d’extradition '
            '(procédure de droit commun et procédure simplifiée) ainsi que de '
            'l’exécution du mandat d’arrêt européen par la France.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.4,
              color: isDark
                  ? Colors.white70
                  : const Color(0xFF1F1F1F).withValues(alpha: .80),
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1. FRANCE ÉTAT REQUÉRANT ==================
          _ConditionCard(
            title:
                'Modalités de transmission de la demande d’extradition — France État requérant',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _SubTitle(
                'Chaîne de transmission en procédure de droit commun',
              ),
              _IntroBullet(
                text:
                    'Le procureur de la République compétent établit la demande '
                    'd’extradition sur la base d’un titre exécutoire (décision de '
                    'condamnation ou mandat d’arrêt).',
              ),
              _IntroBullet(
                text:
                    'La demande est transmise au procureur général, qui émet un avis '
                    'sur l’opportunité de la démarche et la régularité du dossier.',
              ),
              _IntroBullet(
                text:
                    'Lorsque l’État requis ne fait pas partie de l’Union européenne, '
                    'la demande passe par la Chancellerie avant d’être adressée '
                    'au ministre des Affaires étrangères.',
              ),
              _IntroBullet(
                text:
                    'Le ministre des Affaires étrangères transmet la demande à l’État requis, '
                    'qui se prononce sur un accord ou un refus d’extradition.',
              ),
              SizedBox(height: 8),
              _SubTitle(
                'Particularité lorsque l’État requis est membre de l’Union européenne',
              ),
              _Paragraph(
                'Si l’État requis est membre de l’Union européenne mais que la procédure '
                'du mandat d’arrêt européen n’est pas applicable, le procureur général peut, '
                'après avis, transmettre plus directement le dossier au ministre des Affaires '
                'étrangères, afin de réduire les délais de circulation de la demande.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 2. FRANCE ÉTAT REQUIS (DROIT COMMUN) ======
          _ConditionCard(
            title:
                'Procédure d’extradition de droit commun — France État requis',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle(
                'Acheminement de la demande vers l’autorité judiciaire',
              ),
              const _IntroBullet(
                text:
                    'L’État requérant adresse la demande d’extradition au ministère des '
                    'Affaires étrangères français.',
              ),
              const _IntroBullet(
                text:
                    'Le ministère des Affaires étrangères transmet la demande au garde des Sceaux.',
              ),
              const _IntroBullet(
                text:
                    'Le garde des Sceaux la renvoie ensuite au procureur général territorialement '
                    'compétent, après vérification de la régularité formelle de la requête.',
              ),
              const SizedBox(height: 8),
              const _SubTitle('Intervention du procureur général'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le procureur général territorialement compétent fait procéder à '
                      'l’arrestation de la personne recherchée. L’agent chargé de l’exécution '
                      'ne peut s’introduire dans le domicile d’un citoyen qu’entre 6 heures '
                      'et 21 heures, conformément à l’',
                ),
                TextSpan(
                  text: 'article 134 alinéa 1 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La personne interpellée bénéficie des droits attachés à la garde à vue, '
                      'prévus aux ',
                ),
                TextSpan(
                  text: 'articles 63-1 à 63-7 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' (information sur les droits, possibilité de prévenir un proche, '
                      'd’être examinée par un médecin, etc.).',
                ),
              ]),
              const _IntroBullet(
                text:
                    'La personne doit être déférée au procureur général dans les 48 heures '
                    'suivant son arrestation.',
              ),
              const _IntroBullet(
                text:
                    'Après vérification de son identité, le procureur général l’informe, '
                    'dans une langue qu’elle comprend, de l’existence et du contenu de la '
                    'demande d’extradition, ainsi que de sa faculté de consentir ou non à '
                    'son extradition et des conséquences juridiques de ce choix.',
              ),
              const _IntroBullet(
                text:
                    'Si le procureur général décide de ne pas laisser la personne en liberté, '
                    'il la présente au premier président de la cour d’appel ou au magistrat '
                    'du siège désigné par lui, qui peut ordonner l’écrou extraditionnel, un '
                    'contrôle judiciaire ou une assignation à résidence sous surveillance '
                    'électronique.',
              ),
              const SizedBox(height: 8),
              const _SubTitle('Rôle de la chambre de l’instruction'),
              const _BulletPoint(
                text:
                    'En cas de consentement de la personne à son extradition : comparution '
                    'devant la chambre de l’instruction dans un délai de 5 jours à compter '
                    'de sa présentation au procureur général ; la chambre constate le '
                    'consentement et en donne acte dans les 7 jours.',
              ),
              const _BulletPoint(
                text:
                    'En cas de refus de consentir : comparution devant la chambre de '
                    'l’instruction dans un délai de 10 jours ; la chambre rend un avis motivé '
                    'sur la demande d’extradition dans un délai d’un mois, avis susceptible '
                    'd’un pourvoi en cassation sur la forme.',
              ),
              const SizedBox(height: 8),
              const _SubTitle('Effets de la décision'),
              const _Paragraph(
                'Si la chambre de l’instruction rend un avis défavorable, l’extradition ne '
                'peut pas être accordée et la personne est remise en liberté si elle n’est pas '
                'détenue pour une autre cause. Dans les autres cas, l’extradition est autorisée '
                'par décret du Premier ministre, pris sur rapport du ministre de la Justice.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 3. PROCÉDURE SIMPLIFIÉE ===================
          _ConditionCard(
            title:
                'Procédure d’extradition — forme simplifiée entre États membres de l’Union européenne',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _SubTitle('Champ d’application'),
              _Paragraph(
                'La procédure simplifiée d’extradition est réservée aux demandes émanant '
                'd’un État partie à la Convention du 10 mars 1995 relative à la procédure '
                'simplifiée d’extradition entre États membres de l’Union européenne, lorsque '
                'la procédure du mandat d’arrêt européen n’est pas applicable.',
              ),
              SizedBox(height: 8),
              _SubTitle('Chaîne procédurale'),
              _IntroBullet(
                text:
                    'L’État requérant adresse sa demande au garde des Sceaux, sans intervenir '
                    'du ministère des Affaires étrangères lorsque la convention le permet.',
              ),
              _IntroBullet(
                text:
                    'Le garde des Sceaux transmet la demande au procureur général '
                    'territorialement compétent.',
              ),
              _IntroBullet(
                text:
                    'Le procureur général met en œuvre les mêmes étapes que dans la '
                    'procédure de droit commun : arrestation, présentation dans les 48 heures, '
                    'notification du titre, informations sur la faculté de consentir ou non, '
                    'et éventuel placement sous écrou extraditionnel ou mesures de contrôle.',
              ),
              _IntroBullet(
                text:
                    'L’affaire est ensuite portée devant la chambre de l’instruction, qui '
                    'statue sur la base du consentement ou non de la personne recherchée.',
              ),
              SizedBox(height: 8),
              _SubTitle('Spécificités de la procédure simplifiée'),
              _BulletPoint(
                text:
                    'Si la personne consent à son extradition, la chambre de l’instruction lui '
                    'donne acte de ce consentement dans un délai de 7 jours à compter de sa '
                    'comparution.',
              ),
              _BulletPoint(
                text:
                    'Si la personne ne consent pas, la chambre de l’instruction dispose d’un '
                    'délai d’un mois pour rendre un avis motivé, comme en droit commun.',
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: 'Spécificité essentielle',
                bodySpans: [
                  TextSpan(
                    text:
                        'Lorsque les conditions légales sont réunies, la chambre de '
                        'l’instruction accorde directement l’extradition : il n’y a plus de '
                        'décret d’extradition. La remise de l’intéressé à l’État requérant '
                        'doit intervenir dans un délai de 20 jours à compter de la '
                        'notification de la décision à cet État ; passé ce délai, la mise en '
                        'liberté de la personne doit être ordonnée si elle se trouve encore '
                        'sur le territoire français.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 4. EXÉCUTION DU MAE — SCHÉMA ===============
          _ConditionCard(
            title:
                'Exécution du mandat d’arrêt européen par la France — schéma synthétique',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle(
                'Diffusion et appréhension de la personne recherchée',
              ),
              const _IntroBullet(
                text:
                    'Le mandat d’arrêt européen est diffusé : soit directement au procureur '
                    'général territorialement compétent si la personne se trouve dans un '
                    'lieu connu, soit via les systèmes de signalement (Système d’information '
                    'Schengen, INTERPOL) lorsqu’elle n’est pas localisée.',
              ),
              const _IntroBullet(
                text:
                    'Lorsqu’elle est repérée, la personne est appréhendée puis conduite '
                    'dans les 48 heures devant le procureur général.',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Durant ce délai, elle bénéficie des droits prévus aux ',
                ),
                TextSpan(
                  text: 'articles 63-1 à 63-7 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _SubTitle(
                'Rôle du procureur général et de la chambre de l’instruction',
              ),
              const _IntroBullet(
                text:
                    'Le procureur général notifie le mandat d’arrêt européen à la personne, '
                    'l’informe de ses droits, de la possibilité de consentir ou de s’opposer '
                    'à sa remise et des conséquences juridiques de ce choix.',
              ),
              const _IntroBullet(
                text:
                    'Sauf décision contraire du premier président de la cour d’appel, la '
                    'personne est incarcérée à la maison d’arrêt afin de garantir sa '
                    'présence aux actes de la procédure.',
              ),
              const _IntroBullet(
                text:
                    'La chambre de l’instruction est saisie dans les 5 jours de la '
                    'présentation de la personne au procureur général.',
              ),
              const _BulletPoint(
                text:
                    'Si la personne consent à sa remise : la chambre de l’instruction statue '
                    'dans un délai de 7 jours ; la décision est irrévocable et la règle de la '
                    'spécialité peut être levée si la personne y renonce.',
              ),
              const _BulletPoint(
                text:
                    'Si la personne ne consent pas : la chambre de l’instruction statue dans '
                    'un délai de 20 jours ; la décision peut faire l’objet d’un pourvoi en '
                    'cassation.',
              ),
              const SizedBox(height: 6),
              const _SubTitle('Remise de la personne'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque la chambre de l’instruction rend un arrêt autorisant la remise, '
                      'le procureur général prend les mesures nécessaires afin d’organiser le '
                      'transfert de la personne vers l’État d’émission. Cette remise intervient, '
                      'en principe, dans un délai de 10 jours suivant la date à laquelle la '
                      'décision de remise est devenue définitive, conformément à l’',
                ),
                TextSpan(
                  text: 'article 695-37 du Code de procédure pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. La remise peut être différée pour des motifs humanitaires ou lorsque '
                      'la personne doit encore exécuter une peine en France pour d’autres '
                      'faits que ceux visés par le mandat d’arrêt européen.',
                ),
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
