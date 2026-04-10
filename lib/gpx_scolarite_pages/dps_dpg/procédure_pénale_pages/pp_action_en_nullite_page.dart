import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPActionEnNullitePage extends StatelessWidget {
  const PPActionEnNullitePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_en_nullite';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
          'Action en nullité',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            'Action en nullité des actes de procédure',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Conditions, acteurs et effets de l’annulation d’un acte de procédure, '
            'selon qu’il existe ou non une information judiciaire.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          const _SubTitle('Chapitre 2 : L’annulation de l’acte'),

          const _Paragraph(
            'L’action en nullité permet d’obtenir l’annulation d’un acte ou d’une pièce de procédure '
            'entachée d’irrégularité. Elle ne se présente pas de la même façon selon que les faits '
            'donnant lieu aux poursuites font ou non l’objet d’une information judiciaire. '
            'Une fois la nullité prononcée, elle produit des effets sur la procédure elle-même, '
            'mais entraîne également des conséquences pour les parties.',
          ),

          const SizedBox(height: 18),

          // ================= CARD 1 — ACTION EN NULLITÉ & INFORMATION =========
          _ConditionCard(
            title:
                '2.1 – L’action en nullité en présence d’une information judiciaire',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque les faits donnant lieu à des poursuites font l’objet d’une information judiciaire, '
                      "l'appréciation des nullités relève de la chambre de l'instruction. ",
                ),
                TextSpan(
                  text: 'Article 170 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' attribue compétence à cette juridiction pour apprécier les éventuelles nullités et précise les personnes pouvant la saisir.',
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Le prononcé de la nullité repose à la fois sur des règles légales et sur la jurisprudence '
                'de la Cour de cassation. Il peut porter sur un acte déterminé ou sur une pièce de la procédure.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ================= CARD 2 — SAISINE DE LA CHAMBRE ===================
          _ConditionCard(
            title: '2.1.1 – La saisine de la chambre de l’instruction',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _SubTitle('2.1.1.1 – Les personnes habilitées à agir'),

              const _SubTitle('2.1.1.1.1 – Le juge d’instruction'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsqu’une information judiciaire est ouverte, s’il apparaît au juge d’instruction qu’un acte '
                      'ou une pièce de la procédure est frappé de nullité, il saisit la chambre de l’instruction aux fins d’annulation, '
                      'après avoir pris l’avis du procureur de la République et informé les parties. ',
                ),
                TextSpan(
                  text: 'Article 173 alinéa 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' vise les « actes ou pièces de la procédure », notamment lorsque l’acte se confond avec la pièce (par exemple une décision prescrivant une interception et le procès-verbal la transcrivant).',
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('2.1.1.1.2 – Le procureur de la République'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'S’il estime qu’une nullité a été commise, le procureur de la République peut requérir du juge d’instruction '
                      'la communication de la procédure en vue de sa transmission à la chambre de l’instruction. '
                      'Il présente une requête aux fins d’annulation et en informe les parties. ',
                ),
                TextSpan(
                  text: 'Article 173 alinéa 2 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('2.1.1.1.3 – Les parties'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les parties peuvent saisir la chambre de l’instruction par une requête motivée. À peine d’irrecevabilité, '
                      'une copie de cette requête doit être adressée au juge d’instruction, qui transmet le dossier au président de la chambre de l’instruction. '
                      'La requête doit faire l’objet d’une déclaration au greffe de la chambre. ',
                ),
                TextSpan(
                  text: 'Article 173 alinéa 3 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque la détention provisoire se poursuit au-delà de trois mois après l’ouverture de l’information et que l’avis de fin d’information n’a pas été délivré, '
                      'le président de la chambre de l’instruction, le ministère public ou les parties peuvent saisir la chambre afin qu’elle examine l’ensemble de la procédure. '
                      'L’audience doit se tenir dans les huit jours de la demande, et les parties peuvent déposer des mémoires, contenant notamment des requêtes en annulation, '
                      'au moins deux jours ouvrables avant l’audience (',
                ),
                TextSpan(
                  text: 'Article 221-3 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 10),

              const _SubTitle(
                '2.1.1.1.4 – Le témoin assisté et la partie civile',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le témoin assisté peut également présenter une requête en annulation dans les mêmes formes que les parties, '
                      'conformément à l’',
                ),
                TextSpan(
                  text: 'Article 173 alinéa 3 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Sont toutefois exclus de l’action en nullité les actes susceptibles d’appel (par exemple certaines décisions en matière de détention provisoire ou de contrôle judiciaire), '
                      'comme le précise l’',
                ),
                TextSpan(
                  text: 'Article 173 alinéa 4 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les délais pour agir sont encadrés : la personne mise en examen, le témoin assisté et la partie civile disposent notamment de délais de six mois pour certains actes antérieurs, '
                      'en application de l’',
                ),
                TextSpan(
                  text: 'Article 173-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),

              const SizedBox(height: 14),
              const _SubTitle(
                '2.1.1.1.2 – Réception de la requête et pouvoirs du président',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dans les huit jours de la réception du dossier par le greffe, le président de la chambre de l’instruction peut, par ordonnance non susceptible de recours, '
                      'déclarer la requête irrecevable dans certains cas (défaut de déclaration au greffe, acte susceptible d’appel, dépassement des délais, requête non motivée, etc.), '
                      'en application de l’',
                ),
                TextSpan(
                  text: 'Article 173 alinéa 5 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              const _IntroBullet(
                text:
                    'En cas d’irrecevabilité, le dossier est renvoyé au juge d’instruction.',
              ),
              const _IntroBullet(
                text:
                    'Si la requête est recevable, le président réunit la chambre de l’instruction et la procédure est transmise au procureur général pour mise en état.',
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le délai de mise en état est de quarante-huit heures en matière de détention provisoire et de dix jours en toute autre matière, '
                      'conformément à l’',
                ),
                TextSpan(
                  text: 'Article 194 alinéa 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // ================= CARD 3 — POUVOIRS DE LA CHAMBRE ==================
          _ConditionCard(
            title: '2.1.1.1.2 – Les pouvoirs de la chambre de l’instruction',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La chambre de l’instruction doit statuer dans les deux mois à compter de la transmission du dossier au procureur général (',
                ),
                TextSpan(
                  text: 'Article 194 alinéa 2 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Une fois saisie, toutes les nullités doivent être invoquées devant elle, sans que cela empêche la chambre de les relever d’office (',
                ),
                TextSpan(
                  text: 'Article 174 alinéa 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      '). À défaut, les parties ne sont plus recevables à les soulever, sauf si elles ne pouvaient en avoir connaissance.',
                ),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('Purge des nullités selon la nature des faits'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En matière criminelle, l’ordonnance de mise en accusation devant la cour d’assises, lorsqu’elle devient définitive, '
                      'couvre les vices de la procédure, sauf notamment lorsque : ',
                ),
                TextSpan(
                  text: 'Article 181 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: ' le prévoit.'),
              ]),
              const _IntroBullet(
                text:
                    'L’accusé n’a pas été régulièrement informé de sa mise en examen, de l’avis de fin d’information ou de l’ordonnance de mise en accusation, '
                    'sauf manœuvre ou négligence de sa part.',
              ),
              const _IntroBullet(
                text:
                    'Les parties n’ont pas pu avoir préalablement connaissance des vices de procédure.',
              ),

              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En matière délictuelle, les parties ne sont plus recevables à présenter une requête en nullité à l’expiration d’un délai d’un mois si la personne mise en examen est détenue, '
                      'ou de trois mois dans les autres cas, à compter de l’avis de fin d’information (',
                ),
                TextSpan(
                  text: 'Article 175 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les nullités de l’information sont également « purgées » par le renvoi ordonné par le juge d’instruction ou la chambre de l’instruction, '
                      'sauf si les moyens de nullité ne pouvaient être connus avant la clôture (',
                ),
                TextSpan(
                  text: 'Article 385 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      '), disposition applicable aussi en matière contraventionnelle.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          // ================= CARD 4 — PRONONCÉ DE LA NULLITÉ ==================
          _ConditionCard(
            title: '2.1.1.2 – Le prononcé de la nullité',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              const _SubTitle('2.1.1.2.1 – Nullités d’ordre privé'),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les nullités dites « d’ordre privé » sont régies notamment par l’',
                ),
                TextSpan(
                  text: 'Article 802 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : en cas de violation des formes prescrites à peine de nullité ou d’inobservation d’une formalité substantielle, '
                      'toute juridiction, y compris la Cour de cassation, ne peut prononcer la nullité que si l’irrégularité a eu pour effet de porter atteinte '
                      'aux intérêts de la partie qu’elle concerne.',
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph(
                'Sont visés à la fois les actes accomplis par le juge d’instruction et ceux réalisés en enquête par la police judiciaire, '
                'dès lors qu’ils s’intègrent à la procédure d’instruction. L’Article 802 du Code de Procédure Pénale couvre les nullités textuelles '
                'comme les nullités substantielles, mais ne s’applique pas aux nullités d’ordre public.',
              ),

              const SizedBox(height: 12),
              const _SubTitle('2.1.1.2.2 – Nullités d’ordre public'),
              const _Paragraph(
                'Les nullités d’ordre public ne reposent pas sur un critère légal précis. Elles visent la protection de règles et de principes fondamentaux '
                'qui s’imposent à tous et dont la violation est jugée inacceptable, indépendamment des intérêts privés des parties.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'La jurisprudence permet d’identifier certaines catégories de nullités d’ordre public, par exemple :',
              ),
              const _IntroBullet(
                text:
                    'Les règles relatives à l’organisation, la composition et les compétences des juridictions.',
              ),
              const _IntroBullet(
                text:
                    'L’interdiction de confier une mission technique assimilable à une expertise à un officier de police judiciaire par voie de commission rogatoire.',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Il s’agit globalement de l’ensemble des règles qui garantissent le bon fonctionnement du système répressif et la protection des intérêts généraux de la société.',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ================= CARD 5 — SANS INFORMATION JUDICIAIRE =============
          _ConditionCard(
            title:
                '2.1.2 – Action en nullité sans information judiciaire (enquête, délit, contravention)',
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Lorsque les faits poursuivis ne font pas l’objet d’une information judiciaire, en matière délictuelle, ',
                ),
                TextSpan(
                  text: 'l’Article 385 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' confère compétence au tribunal correctionnel pour constater les nullités de la procédure.',
                ),
              ]),
              const SizedBox(height: 6),
              const _IntroBullet(
                text:
                    'Le tribunal correctionnel peut constater toutes les nullités lorsqu’il est saisi par citation directe, comparution immédiate ou comparution différée.',
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’Article 385 du Code de Procédure Pénale pose également la règle selon laquelle « dans tous les cas, les exceptions de nullité doivent être présentées '
                      'avant toute défense au fond ». En conséquence, la nullité ne peut pas être invoquée pour la première fois devant la cour d’appel ou la Cour de cassation.',
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En matière contraventionnelle, les mêmes principes s’appliquent : ',
                ),
                TextSpan(
                  text: 'l’Article 522 du Code de Procédure Pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' attribue au tribunal de police la compétence pour constater les nullités des procédures dont il est saisi.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          const _NotaBox(
            title: 'À RETENIR',
            bodySpans: [
              TextSpan(
                text:
                    'L’action en nullité est un outil central de contrôle de la régularité de la procédure pénale. '
                    'Selon qu’il existe ou non une information judiciaire, la compétence pour statuer relève soit de la chambre de l’instruction, '
                    'soit des juridictions de jugement (tribunal correctionnel, tribunal de police). '
                    'Les nullités d’ordre privé supposent un grief causé à la partie, alors que les nullités d’ordre public protègent des principes fondamentaux '
                    'dont la violation est sanctionnée indépendamment des intérêts particuliers.',
              ),
            ],
          ),

          const SizedBox(height: 26),
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
