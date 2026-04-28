import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPOrganisationMinisterePublicContenuPage extends StatelessWidget {
  const PPOrganisationMinisterePublicContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_organisation_ministere_public_contenu';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    TextStyle sectionTitleStyle = GoogleFonts.fustat(
      fontWeight: FontWeight.w800,
      fontSize: 17,
      color: isDark ? Colors.white : const Color(0xFF0D47A1),
    );

    TextStyle paragraphStyle = GoogleFonts.fustat(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1.45,
      color: textSoft,
    );

    TextSpan law(String label) => TextSpan(
      text: label,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );

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
          'Organisation du ministère public',
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
            'L’organisation hiérarchique du ministère public',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Le ministère public est aussi appelé « parquet ». Sous l’Ancien Régime, '
            'les procureurs et les avocats du Roi ne siégeaient pas sur l’estrade avec les juges, '
            'mais sur le parquet de la salle d’audience, au même niveau que les justiciables. '
            'On parle également de « magistrature debout », par opposition à la magistrature assise, '
            'car à l’audience le représentant du ministère public se lève pour prendre ses réquisitions.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 20),

          // ======================= CHAPITRE 1 ===============================
          Text(
            'Chapitre 1 – Composition du ministère public',
            style: sectionTitleStyle,
          ),
          const SizedBox(height: 8),

          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Le ministère public est représenté auprès de chaque juridiction répressive. '
                      'Il assiste aux débats des juridictions de jugement et toutes les décisions '
                      'sont prononcées en sa présence. Il assure, en outre, l’exécution des décisions de justice, conformément à ',
                ),
                law('l’Article 32 du Code de Procédure Pénale'),
                const TextSpan(text: '.'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Devant le tribunal correctionnel',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'En première instance, les fonctions de ministère public sont assurées par les membres du parquet du tribunal judiciaire. '
            'Ce parquet est dirigé par un procureur de la République et comprend, selon la taille du tribunal, un nombre variable de procureurs adjoints, de vice-procureurs et de substituts.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 8),

          Text(
            'Devant le tribunal de police',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Pour les contraventions de cinquième classe, les fonctions du ministère public sont exercées par le procureur de la République du tribunal judiciaire '
            'dans le ressort duquel est situé le tribunal de police, ou par l’un de ses substituts. '
            'Pour les autres classes de contraventions, le procureur de la République peut également exercer ces fonctions s’il le juge opportun, '
            'en lieu et place du commissaire de police, qui les occupe habituellement.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 8),

          Text(
            'Devant les juridictions de second degré',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Près des Cours d’appel, le parquet est appelé parquet général. Il est dirigé par un procureur général et comprend, selon la taille de la Cour d’appel, '
            'un nombre variable d’avocats généraux et de substituts généraux. Le ministère public est représenté par l’un de ces magistrats devant la chambre de l’instruction '
            'et devant la chambre des appels correctionnels.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 8),

          Text(
            'Devant la Cour d’assises ou la cour criminelle',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Lorsque la cour criminelle ou la Cour d’assises siège au siège de la Cour d’appel, le ministère public est représenté par un membre du parquet général. '
            'Si la cour criminelle ou la Cour d’assises est instituée dans une autre ville, c’est un membre du parquet du tribunal judiciaire qui exerce ces fonctions. '
            'Le procureur général peut, le cas échéant, déléguer tout magistrat des parquets de son ressort.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 8),

          Text(
            'Devant la Cour de cassation',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Le parquet est également dénommé parquet général. Il est composé d’un procureur général, de premiers avocats généraux et d’avocats généraux. '
            'Le parquet général près la Cour de cassation n’exerce pas l’action publique : son rôle est de veiller, en toute indépendance, à l’exacte application de la loi pénale.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 8),

          Text(
            'Devant les juridictions spécialisées',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),

          Text(
            '• Juridictions pour mineurs : un ou plusieurs magistrats du parquet du tribunal judiciaire, désignés par le procureur général, '
            'sont spécialement chargés des affaires de mineurs devant le tribunal pour enfants ou le juge des enfants. '
            'Devant la Cour d’assises des mineurs, ce rôle est exercé par le procureur général ou par un membre du ministère public du ressort de la Cour d’appel '
            'spécialement chargé des affaires de mineurs.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),
          const SizedBox(height: 4),
          Text(
            '• Cour de justice de la République : compétente pour juger les membres du gouvernement pour les crimes ou délits commis dans l’exercice de leurs fonctions, '
            'le ministère public y est exercé par le procureur général près la Cour de cassation, assisté d’un premier avocat général et de deux avocats généraux.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),
          const SizedBox(height: 4),
          Text(
            '• Juridictions militaires : les juridictions de droit commun sont compétentes pour les infractions commises en temps de paix sur le territoire de la République '
            'par des militaires dans l’exercice de leurs fonctions. Le tribunal judiciaire de Paris est compétent pour les infractions commises en temps de paix hors du territoire national '
            'par les membres des forces armées françaises ou à leur encontre. Le ministère public y est représenté par le procureur de la République près le tribunal judiciaire de Paris, '
            'qui désigne les magistrats du parquet spécialement chargés de ces dossiers. '
            'En temps de guerre, il est créé des tribunaux territoriaux des forces armées et un Haut Tribunal des forces armées ; '
            'les fonctions du ministère public y sont exercées par un commissaire du gouvernement, magistrat du corps judiciaire détaché auprès du ministre de la Défense.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 22),

          // ======================= CHAPITRE 2 ===============================
          Text(
            'Chapitre 2 – Statut du ministère public',
            style: sectionTitleStyle,
          ),
          const SizedBox(height: 10),

          Text(
            '2.1 – Nomination',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Les membres du ministère public sont des magistrats. Ils sont nommés par décret du président de la République, '
                      'pris sur proposition du garde des Sceaux et après avis du Conseil supérieur de la magistrature, en application de ',
                ),
                law(
                  'l’Article 26 de l’ordonnance n° 58-1270 du 22 décembre 1958 portant loi organique relative au statut de la magistrature',
                ),
                const TextSpan(
                  text:
                      '. Au cours de leur carrière, ils peuvent changer d’affectation et passer d’un poste du ministère public à un poste du siège, et inversement.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '2.2 – Contrôle disciplinaire',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Les magistrats du parquet ne bénéficient pas du même statut administratif que les magistrats du siège. '
            'Ils sont hiérarchisés et dépendent directement du garde des Sceaux, qui détient le pouvoir disciplinaire à leur égard. '
            'Les sanctions peuvent aller de l’avertissement à la révocation, en passant par la mutation d’office, les membres du ministère public étant amovibles.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 10),

          Text(
            '2.3 – Subordination hiérarchique',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Le ministère public forme un corps hiérarchisé dont le chef est le garde des Sceaux. '
                      'Le ministre de la Justice, chargé de conduire la politique d’action publique déterminée par le gouvernement, '
                      'peut adresser aux procureurs généraux et aux procureurs de la République des directives générales de politique pénale. '
                      'Il ne peut en revanche leur adresser aucune instruction dans une affaire individuelle, en vertu de ',
                ),
                law('l’Article 30 du Code de Procédure Pénale'),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Chargés d’animer et de coordonner l’action des procureurs de la République en matière de prévention et de répression des infractions, '
                      'les procureurs généraux peuvent adresser des directives de politique pénale aux procureurs de la République placés sous leur autorité, '
                      'et leur enjoindre par instructions écrites d’engager ou de faire engager des poursuites, ou de saisir la juridiction compétente, conformément à ',
                ),
                law('l’Article 35 du Code de Procédure Pénale'),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Le procureur général a sous son autorité tous les membres du parquet de la Cour d’appel, les procureurs de la République près les tribunaux judiciaires '
                      'du ressort et tous les officiers du ministère public près les tribunaux de police, comme le prévoit ',
                ),
                law('l’Article 37 du Code de Procédure Pénale'),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Le procureur de la République a autorité sur tous les membres de son parquet et sur les officiers du ministère public près les tribunaux de police, '
                      'conformément à ',
                ),
                law('l’Article 44 du Code de Procédure Pénale'),
                const TextSpan(
                  text:
                      '. Il anime et coordonne, dans le ressort du tribunal judiciaire, la politique de prévention de la délinquance, comme le précise ',
                ),
                law('l’Article 39-1 du Code de Procédure Pénale'),
                const TextSpan(text: '.'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '2.4 – Liberté de décision',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Le principe de subordination hiérarchique n’est pas absolu. Les procureurs généraux et les procureurs de la République disposent de pouvoirs propres : '
                      'ils sont investis du droit d’exercer l’action publique et la juridiction saisie par eux l’est valablement, '
                      'même en cas d’instructions contraires. Une désobéissance peut entraîner des sanctions disciplinaires, '
                      'mais ne rend pas nulles les poursuites engagées.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Les magistrats du parquet développent librement, devant la juridiction saisie, les observations orales qu’ils estiment les plus conformes au bien de la justice, '
                      'conformément à ',
                ),
                law('l’Article 33 du Code de Procédure Pénale'),
                const TextSpan(
                  text:
                      '. Cette liberté demeure même lorsque des réquisitions écrites différentes ont été prises sur la base d’instructions hiérarchiques. '
                      'C’est ce que traduit l’adage : « la plume est serve mais la parole est libre ». ',
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ======================= CHAPITRE 3 ===============================
          Text(
            'Chapitre 3 – Caractéristiques du ministère public',
            style: sectionTitleStyle,
          ),
          const SizedBox(height: 10),

          Text(
            '3.1 – Indivisibilité du ministère public',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Contrairement aux magistrats du siège, qui doivent rester les mêmes pendant toute la durée d’un procès, '
            'les magistrats d’un même parquet peuvent se remplacer les uns les autres au cours de la même affaire. '
            'L’acte accompli par un membre du parquet engage ainsi l’ensemble du ministère public.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 10),

          Text(
            '3.2 – Irrécusabilité',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'Un juge du siège peut être récusé pour certains motifs, en application de ',
                ),
                law('l’Article 668 du Code de Procédure Pénale'),
                const TextSpan(text: ' et de '),
                law('l’Article 341 du Code de Procédure Civile'),
                const TextSpan(
                  text:
                      '. Un juré de Cour d’assises peut également être récusé sans motif, en vertu de ',
                ),
                law('l’Article 297 du Code de Procédure Pénale'),
                const TextSpan(
                  text:
                      '. En revanche, le représentant du ministère public, qui est partie principale au procès pénal, ne peut jamais être récusé '
                      'par le prévenu ou la partie civile, conformément à ',
                ),
                law('l’Article 669 alinéa 2 du Code de Procédure Pénale'),
                const TextSpan(text: '.'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '3.3 – Irresponsabilité',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: paragraphStyle,
              children: [
                const TextSpan(
                  text:
                      'L’irresponsabilité des magistrats signifie qu’ils ne peuvent, en principe, voir leur responsabilité engagée du seul fait d’avoir initié des poursuites '
                      'qui se terminent par un non-lieu, une relaxe ou un acquittement. '
                      'Toutefois, cette irresponsabilité n’est pas absolue : lorsqu’un magistrat du parquet commet une faute personnelle, sa responsabilité civile peut être recherchée. '
                      'En cas de faute lourde ou de déni de justice, l’État est tenu de réparer le dommage causé, en vertu de ',
                ),
                law('l’Article L. 141-1 du Code de l’Organisation Judiciaire'),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Les membres du parquet, comme tous les autres magistrats, peuvent enfin faire l’objet de poursuites pénales s’ils commettent une infraction. '
            'Selon les circonstances, l’affaire peut être renvoyée devant une autre juridiction pour garantir l’impartialité.',
            textAlign: TextAlign.justify,
            style: paragraphStyle,
          ),

          const SizedBox(height: 22),

          // ======================= ORGANIGRAMME ============================
          Text(
            'Organigramme – La hiérarchie du ministère public',
            style: sectionTitleStyle,
          ),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(.20)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white24
                    : const Color(0xFFBBBBBB).withOpacity(.7),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrgLine(
                  label: 'Le garde des Sceaux – Ministre de la Justice',
                  isTop: true,
                ),
                _OrgLine(
                  label:
                      'Parquet de la Cour de cassation\nProcureur général et avocats généraux',
                ),
                _OrgLine(
                  label:
                      'Parquet général de la Cour d’appel\nProcureur général, avocats généraux et substituts généraux',
                ),
                _OrgLine(
                  label:
                      'Parquet du tribunal judiciaire (échelon du département)\nProcureur de la République et substituts',
                ),
                _OrgLine(
                  label:
                      'Parquet près le tribunal de police (échelon de l’arrondissement)\nCommissaire de police, commandant ou capitaine de police,\n'
                      'ou membre du parquet du tribunal judiciaire, ou maire (à titre exceptionnel)',
                  isBottom: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Petite ligne de l’organigramme
class _OrgLine extends StatelessWidget {
  const _OrgLine({
    required this.label,
    this.isTop = false,
    this.isBottom = false,
  });

  final String label;
  final bool isTop;
  final bool isBottom;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isTop)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 10,
              width: 1.4,
              color: Colors.grey.withOpacity(.5),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 4),
            Icon(Icons.account_tree_rounded, size: 18, color: bulletColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.fustat(
                  fontSize: 13.2,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF222222),
                ),
              ),
            ),
          ],
        ),
        if (!isBottom) const SizedBox(height: 6),
      ],
    );
  }
}
