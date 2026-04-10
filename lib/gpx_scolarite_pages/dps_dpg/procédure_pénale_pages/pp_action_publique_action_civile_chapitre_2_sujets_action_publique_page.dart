import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPActionPubliqueChapitre2SujetsActionPubliquePage
    extends StatelessWidget {
  const PPActionPubliqueChapitre2SujetsActionPubliquePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_action_civile/chapitre_2_sujets_action_publique';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.75);

    final Color cardBg = isDark
        ? const Color(0xFF2B3036)
        : const Color(0xFFF5F7FB);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleBlue = isDark ? Colors.white : const Color(0xFF0D47A1);

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
          'Chapitre 2 — Sujets de l’action publique',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // =================== EN-TÊTE CHAPITRE ============================
          Text(
            'Les sujets de l’action publique',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Qui peut exercer l’action publique, et contre qui est-elle dirigée ? '
            'Ce chapitre distingue les sujets actifs (ceux qui mettent en mouvement '
            'ou exercent l’action publique) et les sujets passifs (ceux contre qui '
            'elle est dirigée).',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // =================== INTRO GENERALE ==============================
          _ConditionCard(
            title: 'Définition générale des sujets de l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: const [
              _Paragraph(
                'L’expression « sujets de l’action publique » regroupe :',
              ),
              SizedBox(height: 6),
              _IntroBullet(
                text:
                    'les personnes qui exercent l’action publique : les sujets actifs ;',
              ),
              _IntroBullet(
                text:
                    'les personnes contre lesquelles l’action publique est dirigée : '
                    'les sujets passifs.',
              ),
              SizedBox(height: 10),
              _Paragraph(
                'L’action publique appartient à la société, qui seule a le droit de '
                'l’exercer ou d’y renoncer. En pratique, la société agit par '
                'l’intermédiaire de représentants qualifiés : les magistrats du '
                'ministère public et, dans certains cas, des fonctionnaires de '
                'certaines administrations. Certaines juridictions et la partie lésée '
                'peuvent également mettre en mouvement l’action publique.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 2.1 SUJETS ACTIFS ==========================
          const _SubTitle('2.1 — Les sujets actifs de l’action publique'),
          const SizedBox(height: 4),
          const _Paragraph(
            'Les sujets actifs de l’action publique sont les personnes ou autorités '
            'habilitées par la loi à mettre en mouvement et à exercer l’action publique : '
            'principalement le ministère public, certaines administrations, mais aussi, '
            'dans des cas particuliers, les juridictions et la partie lésée.',
          ),
          const SizedBox(height: 12),

          // ----------------- 2.1.1 LE MINISTERE PUBLIC --------------------
          _ConditionCard(
            title: '2.1.1 — Le ministère public',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _Paragraph(
                'L’ensemble des officiers du ministère public près d’une juridiction '
                'déterminée constitue ce que l’on appelle le parquet. Historiquement, '
                'sous l’Ancien Régime, les procureurs et avocats du Roi ne siégeaient '
                'pas sur l’estrade des juges, mais sur le « parquet » de la salle '
                'd’audience, au même niveau que les justiciables.',
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: 'Article 1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’action publique est mise en mouvement et exercée par les '
                      'magistrats auxquels elle est confiée par la loi.',
                ),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('Absence de disposition de l’action publique'),
              const _Paragraph(
                'Le ministère public n’a pas la « disposition » de l’action publique. '
                'L’action publique appartient à la société qui l’exerce par son intermédiaire. '
                'Si les membres du ministère public disposaient librement de l’action publique, '
                'ils pourraient transiger avec le délinquant, se désister de recours, ou encore '
                'acquiescer aux prétentions du prévenu. La loi ne leur reconnaît pas de tels '
                'pouvoirs de renonciation générale.',
              ),
              const SizedBox(height: 6),

              const _BulletPoint(
                text:
                    'Une fois l’action publique régulièrement mise en mouvement, le ministère '
                    'public ne peut en principe plus l’arrêter unilatéralement.',
              ),
              const SizedBox(height: 6),

              const _NotaBox(
                title: 'Point clé',
                bodySpans: [
                  TextSpan(
                    text:
                        'l’action publique est d’ordre public. Le ministère public agit au nom '
                        'de la société : il poursuit ou renonce à poursuivre dans le cadre fixé '
                        'par la loi, et non selon des accords privés avec le délinquant.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ----------------- 2.1.2 ADMINISTRATIONS ------------------------
          _ConditionCard(
            title: '2.1.2 — Les administrations qui exercent l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _Paragraph(
                'Des pouvoirs diversifiés sont reconnus à certaines administrations '
                'publiques pour constater, poursuivre ou réparer les infractions portant '
                'atteinte aux intérêts dont elles ont la charge. Dans certains cas, elles '
                'détiennent un droit direct de poursuite et exercent alors l’action publique '
                'au même titre que le ministère public.',
              ),
              const SizedBox(height: 8),

              const _SubTitle('2.1.2.1 — Administration chargée des forêts'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'En matière d’infractions forestières soumises au tribunal de police, ',
                ),
                TextSpan(
                  text:
                      'le directeur régional de l’administration chargée des forêts ou le fonctionnaire qu’il désigne ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text:
                      'remplit toutes les fonctions du ministère public, sous l’autorité du procureur de la République.',
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article L. 161-22 du code forestier',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' et '),
                TextSpan(
                  text: 'article 45 alinéa 2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' encadrent ce pouvoir de représentation devant le tribunal de police.',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Ce pouvoir concerne les infractions forestières et assimilées, certains '
                    'délits de chasse dans les bois soumis au régime forestier et certaines '
                    'infractions de pêche fluviale.',
              ),
              const _BulletPoint(
                text:
                    'L’administration chargée des forêts partage le droit de poursuivre avec '
                    'le ministère public, qui conserve intégralement son propre pouvoir d’action.',
              ),
              const _BulletPoint(
                text:
                    'Contrairement au ministère public, cette administration peut transiger '
                    'avec le délinquant. Si la poursuite est déjà engagée, la transaction '
                    'éteint l’action publique et dessaisit le juge.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('2.1.2.2 — Administration de l’équipement'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Le directeur départemental de l’équipement ou l’agent qu’il désigne, ',
                ),
                TextSpan(
                  text:
                      'en application des articles L. 116-4 et L. 116-5 du Code de la voirie routière',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', peut, concurremment avec les magistrats du parquet, exercer les '
                      'fonctions de ministère public devant le tribunal de police pour les '
                      'infractions concernant la voirie nationale (empiétement, dégradation '
                      'du domaine public, etc.).',
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Ces fonctionnaires peuvent transiger tant qu’aucun jugement définitif '
                    'n’a été rendu.',
              ),
              const SizedBox(height: 10),

              const _SubTitle('2.1.2.3 — Administrations fiscales'),
              const _Paragraph(
                'Les administrations fiscales disposent de pouvoirs de poursuite, mais ceux-ci '
                'ne s’appliquent pas aux peines d’emprisonnement. Elles prononcent des amendes '
                'et d’autres sanctions de nature fiscale (majorations, confiscations, contraintes, etc.).',
              ),
              const SizedBox(height: 8),

              const _SubTitle('2.1.2.4 — Contributions indirectes'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’administration des contributions indirectes, représentée par son directeur départemental, ',
                ),
                TextSpan(
                  text:
                      'poursuit les infractions fiscales sur le fondement de l’article L. 235 du Livre des procédures fiscales',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),

              const _SubTitle('2.1.2.5 — Administration des douanes'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’administration des douanes dispose du droit de poursuivre les infractions douanières. ',
                ),
                TextSpan(
                  text: 'Article 343 du Code des douanes',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : le ministère public poursuit les délits douaniers devant le tribunal '
                      'correctionnel, mais l’administration des douanes intervient pour obtenir '
                      'les sanctions pécuniaires.',
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: 'Lorsque l’article 28-1 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' est mis en œuvre, le ministère public peut saisir le service d’enquêtes '
                      'judiciaires des finances ou demander l’ouverture d’une information judiciaire '
                      'pour l’application de sanctions fiscales.',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    'Les administrations des contributions indirectes et des douanes peuvent transiger. '
                    'La transaction intervenant avant jugement éteint l’action fiscale.',
              ),
              const _BulletPoint(
                text:
                    'Si le même fait présente aussi une qualification de droit commun, la transaction '
                    'fiscale demeure sans effet sur l’action publique exercée au titre du droit commun.',
              ),
              const SizedBox(height: 10),

              const _NotaBox(
                title: 'À retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'certaines administrations disposent de pouvoirs proches de ceux du ministère public, '
                        'mais avec une logique de protection d’intérêts spécifiques (forêts, voirie, douanes, '
                        'fiscalité) et souvent la possibilité de transiger.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ----------------- 2.1.3 CAS PARTICULIERS -----------------------
          _ConditionCard(
            title:
                '2.1.3 — Cas particuliers de mise en mouvement de l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _SubTitle(
                '2.1.3.1 — Juridictions de jugement et chambre de l’instruction',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Lorsque des infractions sont commises à l’audience des cours et tribunaux, ',
                ),
                TextSpan(
                  text:
                      'les articles 675 et suivants du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' permettent à la juridiction de se saisir d’office et de juger l’auteur '
                      'des faits, en appliquant les peines prévues par la loi.',
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Exception : en cas de délit d’outrage à magistrat (article 434-24 du Code pénal), '
                    'la juridiction ne se saisit pas elle-même pour éviter tout soupçon de partialité. '
                    'Les faits sont transmis au ministère public.',
              ),
              const _BulletPoint(
                text:
                    'Exception également lorsque le fait commis à l’audience constitue un crime, '
                    'car une instruction préparatoire est alors obligatoire.',
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Dans ces cas, le président d’audience dresse procès-verbal des faits et saisit '
                'le ministère public, qui décide de la suite à donner. La chambre de l’instruction '
                'peut par ailleurs, d’office, ordonner des poursuites pour des faits connexes.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Articles 202 et suivants du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' : ces textes encadrent ce pouvoir.'),
              ]),
              const SizedBox(height: 10),

              const _SubTitle('2.1.3.2 — Le Défenseur des droits'),
              const _Paragraph(
                'Le Défenseur des droits dispose, en cas de discriminations avérées, '
                'd’un pouvoir de transaction pénale lorsque l’action publique n’a pas '
                'encore été mise en mouvement. L’auteur des faits peut se voir proposer '
                'le paiement d’une amende transactionnelle et, éventuellement, l’indemnisation '
                'de la victime (montant maximal de 3 000 euros pour une personne physique, '
                '15 000 euros pour une personne morale).',
              ),
              const SizedBox(height: 8),

              const _SubTitle('2.1.3.3 — La partie lésée'),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La victime, bien qu’elle ne puisse exercer elle-même l’action publique, peut la déclencher. ',
                ),
                TextSpan(
                  text: 'Article 1 alinéa 2 du Code de Procédure Pénale',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : la partie lésée peut mettre en mouvement l’action publique dans les conditions prévues par la loi.',
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'Soit en citant directement le prévenu devant le tribunal pour une infraction '
                    'qui n’est pas un crime (citation directe).',
              ),
              const _BulletPoint(
                text:
                    'Soit en déposant une plainte avec constitution de partie civile devant le juge '
                    'd’instruction, ce qui déclenche l’action publique.',
              ),
              const SizedBox(height: 6),

              const _NotaBox(
                title: 'En pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'ce droit permet à la victime de contourner l’inaction éventuelle du ministère public '
                        'et d’obtenir l’ouverture d’une procédure.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================== 2.2 SUJETS PASSIFS ==========================
          _ConditionCard(
            title: '2.2 — Les sujets passifs de l’action publique',
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              const _SubTitle('2.2.1 — Contre l’auteur ou le complice'),
              const _Paragraph(
                'L’action publique tend au prononcé d’une peine. En vertu du principe de '
                'la personnalité des peines, elle ne peut être dirigée que contre les auteurs '
                'ou complices de l’infraction. Elle peut être exercée même si l’auteur est '
                'inconnu (information ouverte contre X).',
              ),
              const SizedBox(height: 4),
              const _BulletPoint(
                text:
                    'L’action publique ne peut pas être exercée contre les héritiers du '
                    'délinquant. Si ce dernier décède au cours de la procédure, '
                    'l’action publique est éteinte.',
              ),
              const SizedBox(height: 8),

              const _SubTitle(
                '2.2.2 — Contre le représentant légal d’une personne morale',
              ),
              const _Paragraph(
                'Lorsque l’infraction est commise par une personne morale, l’action publique '
                'est exercée à l’encontre de son représentant légal (ou d’un délégué désigné '
                'à cet effet), qui la représente dans tous les actes de la procédure. La '
                'personne morale encourt alors des peines spécifiques (amende, interdictions, '
                'fermeture d’établissement, etc.).',
              ),
              const SizedBox(height: 8),

              const _SubTitle(
                '2.2.3 — Contre les personnes pénalement responsables du fait d’autrui',
              ),
              const _Paragraph(
                'En dépit du principe de la personnalité des peines, certaines sanctions '
                'peuvent être prononcées contre des personnes qui n’ont pas matériellement '
                'commis l’infraction, mais dont la responsabilité est engagée à raison des '
                'actes d’autrui. Il s’agit principalement de la responsabilité du chef '
                'd’entreprise, prévue par la loi ou dégagée par la jurisprudence.',
              ),
              const SizedBox(height: 6),

              const _BulletPoint(
                text:
                    'Exemple : un serveur sert de l’alcool à un client en état d’ébriété en '
                    'violation des règles. La contravention est imputée au tenancier, même si '
                    'l’infraction a été matériellement commise par le préposé.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article R. 3353-2 du Code de la santé publique',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' incrimine la vente ou l’offre de boissons alcooliques à '
                      'une personne manifestement ivre.',
                ),
              ]),
              const SizedBox(height: 6),

              _BulletPoint(
                text:
                    'Exemple : les amendes prononcées contre les conducteurs d’un véhicule '
                    'peuvent, en tout ou partie, être supportées par l’employeur.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text: 'Article L. 121-1 du Code de la route',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' permet au juge de mettre à la charge de l’employeur tout ou partie de l’amende.',
                ),
              ]),
              const SizedBox(height: 6),

              const _BulletPoint(
                text:
                    'Exemple : le directeur d’une entreprise à l’origine d’une pollution des eaux '
                    'peut être condamné même s’il n’est pas démontré qu’il a personnellement '
                    'organisé la pollution. Sa responsabilité découle de sa qualité de dirigeant.',
              ),
              const SizedBox(height: 10),

              const _NotaBox(
                title: 'À garder en tête',
                bodySpans: [
                  TextSpan(
                    text:
                        'la responsabilité pénale du fait d’autrui ne remet pas en cause le principe '
                        'de la personnalité des peines, mais l’adapte aux réalités de la vie des '
                        'affaires : le chef d’entreprise doit répondre des manquements graves commis '
                        'dans le cadre de l’activité qu’il dirige.',
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
