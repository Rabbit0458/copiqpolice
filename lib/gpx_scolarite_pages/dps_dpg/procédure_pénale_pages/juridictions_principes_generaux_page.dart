import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JuridictionsPrincipesGenerauxPage extends StatelessWidget {
  const JuridictionsPrincipesGenerauxPage({super.key});

  /// Chemin/route demandé
  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/juridictions_principes_generaux';

  TextSpan _cppArticle(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _cjpmArticle(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Juridictions – Principes généraux')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau version
              Center(
                child: Text(
                  'Version au 01/07/2025  © SDCP - Tous droits réservés',
                  style: GoogleFonts.fustat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white60
                        : const Color(0xFF424242).withOpacity(.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),

              ////////////////////////////////////////////////////////////
              /// CHAPITRE 1 – LES JURIDICTIONS DE JUGEMENT / PRINCIPES
              ////////////////////////////////////////////////////////////
              _ConditionCard(
                title: 'Chapitre 1 : Les juridictions de jugement',
                cardColor: isDark
                    ? const Color(0xFF121212)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: const [
                  _Paragraph(
                    'Le tribunal évoque le lieu où sont sanctionnées les personnes '
                    'qui ont violé la loi et où les personnes en conflit viennent '
                    'chercher justice.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Il existe plusieurs catégories de tribunaux organisés selon la '
                    'nature et la gravité des litiges qui leur sont soumis.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Certaines juridictions sont chargées de régler les litiges entre '
                    'les citoyens et les pouvoirs publics : ce sont les tribunaux de '
                    "l'ordre administratif.",
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Dans le cas de litiges entre les personnes ou d’atteintes portées '
                    'à la société, les tribunaux judiciaires sont compétents. Ils '
                    'comprennent des juridictions civiles et des juridictions pénales.',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: 'Les juridictions pénales',
                cardColor: isDark
                    ? const Color(0xFF101218)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF1A237E),
                titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
                children: [
                  const _Paragraph(
                    'Parmi les juridictions pénales, il faut distinguer les juridictions '
                    'de droit commun des juridictions d’exception.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Les juridictions de droit commun ont compétence pour juger toutes '
                    'les infractions d’une catégorie déterminée, sauf celles dont un '
                    'texte spécial leur a retiré la connaissance.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Les juridictions d’exception, quant à elles, n’ont qu’une '
                    "compétence d’attribution étroitement délimitée par la loi, "
                    'soit en considération de la nature des infractions, soit en raison '
                    'de la qualité des auteurs (mineurs par exemple).',
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle('1.1 - Les juridictions de droit commun'),
                  const _Paragraph(
                    'Elles statuent au fond sur l’affaire. On y trouve notamment : '
                    'le tribunal de police, le tribunal correctionnel et la cour d’assises.',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ///////////////////////////////////////////
              /// 1.1.1 – LE TRIBUNAL DE POLICE
              ///////////////////////////////////////////
              _ConditionCard(
                title: '1.1.1 - Le tribunal de police',
                cardColor: isDark
                    ? const Color(0xFF111820)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal de police est régi principalement par les ',
                    ),
                    _cppArticle(
                      'Articles 521 à 549 du Code de procédure pénale',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 10),

                  const _SubTitle('1.1.1.1 - Organisation'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal de police est constitué par un juge du tribunal '
                          'judiciaire, un officier du ministère public et par un greffier (',
                    ),
                    _cppArticle('Article 523 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les fonctions du ministère public sont remplies par le procureur '
                          'de la République près le tribunal judiciaire, et ce '
                          'obligatoirement pour les contraventions de 5ᵉ classe ne '
                          'relevant pas de la procédure de l’amende forfaitaire (',
                    ),
                    _cppArticle(
                      'Article 45 alinéa 1 du Code de procédure pénale',
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En cas d’empêchement du commissaire de police, le procureur '
                          'général désigne, pour une année entière, un ou plusieurs '
                          'remplaçants qu’il choisit parmi les commissaires et les '
                          'commandants ou capitaines de police en résidence dans le '
                          'ressort du tribunal judiciaire (',
                    ),
                    _cppArticle('Article 46 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Pour les infractions forestières, les fonctions du ministère '
                          'public sont dévolues au directeur régional de '
                          "l'administration chargée des forêts ou au fonctionnaire qu’il "
                          'désigne (',
                    ),
                    _cppArticle('Article 46 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 12),
                  const _SubTitle('1.1.1.2 - Compétences'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal de police est compétent pour juger toutes les '
                          'contraventions (',
                    ),
                    _cppArticle('Article 521 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Est compétent le tribunal de police du lieu de commission ou de '
                          'constatation de l’infraction ou celui de la résidence du prévenu (',
                    ),
                    _cppArticle(
                      'Article 522 alinéa 1 du Code de procédure pénale',
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En cas de contravention aux règles relatives au chargement ou à '
                          'l’équipement de véhicule, ou aux conditions de travail dans les '
                          'transports routiers, ou encore à la coordination des transports, '
                          'est compétent le tribunal du siège de l’entreprise détentrice du '
                          'véhicule (',
                    ),
                    _cppArticle(
                      'Article 522 alinéa 2 du Code de procédure pénale',
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal de police n’est pas compétent pour juger les '
                          'contraventions de 5ᵉ classe commises par les mineurs '
                          '(compétence des juridictions pour enfants). Les contraventions '
                          'des 4 premières classes commises par des mineurs relèvent de la '
                          'compétence du tribunal de police (',
                    ),
                    _cjpmArticle(
                      'Article L.423-1 du Code de la justice pénale des mineurs',
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 12),
                  const _SubTitle('1.1.1.3 - Modes de saisine'),
                  const _Paragraph(
                    'Les modes de saisine du tribunal de police sont définis à '
                    "l'article 531 du C.P.P.",
                  ),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        'Citation directe : consiste à faire citer l’auteur d’une '
                        'contravention, par le biais d’un huissier, directement devant le '
                        'tribunal de police.',
                  ),
                  const _IntroBullet(
                    text:
                        'Convocation en justice : elle est notifiée au prévenu soit par un '
                        'greffier, un officier ou agent de police judiciaire, un assistant '
                        'd’enquête agissant sous le contrôle de l’officier ou de l’agent de '
                        'police judiciaire, un fonctionnaire ou agent d’une administration '
                        'relevant de l’article 28, ou un délégué ou médiateur du procureur '
                        'de la République, soit, si le prévenu est détenu, par le chef de '
                        "l’établissement pénitentiaire.",
                  ),
                  const _IntroBullet(text: 'Comparution volontaire.'),
                ],
              ),
              const SizedBox(height: 18),

              ///////////////////////////////////////////
              /// 1.1.2 – TRIBUNAL CORRECTIONNEL
              ///////////////////////////////////////////
              _ConditionCard(
                title: '1.1.2 - Le tribunal correctionnel',
                cardColor: isDark
                    ? const Color(0xFF111820)
                    : const Color(0xFFE8F5E9),
                accent: const Color(0xFF2E7D32),
                titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal correctionnel est la formation de jugement normale '
                          'du tribunal judiciaire dans le domaine pénal. Il est régi par les ',
                    ),
                    _cppArticle(
                      'Articles 381 à 495-25 du Code de procédure pénale',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 12),

                  const _SubTitle('1.1.2.1 - Composition'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal correctionnel, dans sa formation ordinaire, est une '
                          'juridiction collégiale composée d’un président et de deux juges (',
                    ),
                    _cppArticle(
                      'Article 398 alinéa 1 du Code de procédure pénale',
                    ),
                    const TextSpan(
                      text:
                          '). Le parquet est représenté par le procureur de la République.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal correctionnel peut siéger à juge unique, notamment '
                          'pour les délits énumérés à ',
                    ),
                    _cppArticle('l’Article 398-1 du Code de procédure pénale'),
                    const TextSpan(
                      text:
                          ' (ex. délits liés aux chèques, au code de la route, aux armes, '
                          'à la chasse…).',
                    ),
                  ]),

                  const SizedBox(height: 12),
                  const _SubTitle('1.1.2.2 - Compétence'),
                  _Paragraph.rich([
                    const TextSpan(text: 'Selon '),
                    _cppArticle('l’Article 381 du Code de procédure pénale'),
                    const TextSpan(
                      text:
                          ', le tribunal correctionnel juge les délits, c’est-à-dire les '
                          'infractions que la loi punit d’une peine d’emprisonnement ou '
                          'd’une amende supérieure ou égale à 3 750 euros.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Le tribunal correctionnel est compétent pour juger tous les délits '
                    'qui ne sont pas renvoyés devant une juridiction particulière.',
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Il est apte à connaître des contraventions connexes à un délit et '
                          'peut également juger une contravention dont il a été saisi par '
                          'erreur sous la qualification de délit (',
                    ),
                    _cppArticle('Article 466 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Compétence territoriale : le tribunal du lieu de l’infraction, de '
                          'la résidence ou du lieu d’arrestation ou de détention du prévenu, '
                          'même lorsque cette arrestation ou cette détention a été opérée ou '
                          'est effectuée pour une autre cause.',
                    ),
                  ]),

                  const SizedBox(height: 12),
                  const _SubTitle('1.1.2.3 - Modes de saisine'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les modes de saisine du tribunal correctionnel sont listés à ',
                    ),
                    _cppArticle('l’Article 388 du Code de procédure pénale'),
                    const TextSpan(text: ' :'),
                  ]),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        'Comparution volontaire (Article 389 du Code de procédure pénale).',
                  ),
                  const _IntroBullet(
                    text:
                        'Citation directe émanant du ministère public, de la partie civile '
                        'ou de toute administration légalement habilitée (Article 390 du '
                        'Code de procédure pénale).',
                  ),
                  const _IntroBullet(
                    text:
                        'Convocation en justice (Article 390-1 du Code de procédure '
                        'pénale).',
                  ),
                  const _IntroBullet(
                    text:
                        'Convocation par procès-verbal dite du « rendez-vous judiciaire » '
                        '(Article 394 du Code de procédure pénale).',
                  ),
                  const _IntroBullet(
                    text:
                        'Comparution immédiate (Article 395 du Code de procédure '
                        'pénale).',
                  ),
                  const _IntroBullet(
                    text:
                        'Comparution différée (Article 397-1-1 du Code de procédure '
                        'pénale).',
                  ),
                  const _IntroBullet(
                    text:
                        'Ordonnance du juge d’instruction ou de la chambre de '
                        'l’instruction (Articles 179 et 213 du Code de procédure pénale).',
                  ),
                  const _IntroBullet(
                    text:
                        'Saisine d’office, notamment en cas d’infraction commise à '
                        'l’audience d’une juridiction de jugement (Articles 675 à 678 du '
                        'Code de procédure pénale).',
                  ),

                  const SizedBox(height: 12),
                  const _SubTitle('1.1.2.4 - Procédures simplifiées'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Plusieurs procédures simplifiées existent devant le tribunal '
                          'correctionnel : ',
                    ),
                    _cppArticle(
                      'Articles 495 à 495-6 du Code de procédure pénale',
                    ),
                    const TextSpan(text: ' (ordonnance pénale), '),
                    _cppArticle(
                      'Articles 495-7 à 495-16 du Code de procédure pénale',
                    ),
                    const TextSpan(
                      text:
                          ' (comparution sur reconnaissance préalable de culpabilité), ',
                    ),
                    _cppArticle(
                      'Articles 495-17 à 495-25 du Code de procédure pénale',
                    ),
                    const TextSpan(
                      text:
                          ' (amende forfaitaire délictuelle). Elles sont détaillées dans le '
                          'fascicule n° 14 – Action publique et action civile.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal correctionnel statue également au civil sur les '
                          'réparations des dommages causés aux victimes lorsqu’elles se '
                          'sont constituées partie civile, et ce quel que soit le taux des '
                          'dommages et intérêts demandés. La partie civile peut se '
                          'constituer :',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        'soit avant l’audience au greffe, soit pendant l’audience, par '
                        'déclaration consignée par le greffier ou dépôt de conclusions '
                        '(Article 419 du Code de procédure pénale) ;',
                  ),
                  const _BulletPoint(
                    text:
                        'soit au stade de l’enquête devant les enquêteurs (Article 420-1 '
                        'alinéa 2 du Code de procédure pénale) ;',
                  ),
                  const _BulletPoint(
                    text:
                        'soit par lettre recommandée avec avis de réception, par '
                        'télécopie ou par le moyen d’une communication électronique '
                        'parvenue au moins 24 heures avant la date de l’audience '
                        '(Article 420-1 alinéa 1 du Code de procédure pénale).',
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ///////////////////////////////////////////
              /// 1.1.3 – COUR D’ASSISES
              ///////////////////////////////////////////
              _ConditionCard(
                title: "1.1.3 - La cour d'assises",
                cardColor: isDark
                    ? const Color(0xFF151218)
                    : const Color(0xFFFFF3E0),
                accent: const Color(0xFFEF6C00),
                titleColor: isDark ? Colors.white : const Color(0xFFE65100),
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          "La cour d’assises est compétente pour juger les crimes. Elle est "
                          'régie par les ',
                    ),
                    _cppArticle(
                      'Articles 231 à 380-15 du Code de procédure pénale',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 10),

                  const _SubTitle('1.1.3.1 - Composition'),
                  const _Paragraph(
                    'Il y a une cour d’assises par département. Elle se tient en principe '
                    'au siège de la cour d’appel ou au chef-lieu du département, dans les '
                    'locaux du tribunal judiciaire.',
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle('1.1.3.1.1 - La cour'),
                  const _Paragraph(
                    'La cour d’assises a une composition originale car elle rassemble un '
                    'élément professionnel, la cour, et un élément non professionnel, le '
                    'jury.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'La cour est composée de trois membres : un président et deux '
                    'assesseurs. Le président est un conseiller à la cour d’appel, désigné '
                    'pour chaque session par le premier président de la cour d’appel. '
                    'Les assesseurs sont choisis soit parmi les conseillers de la cour '
                    'd’appel, soit parmi les présidents, vice-présidents ou juges du '
                    'tribunal judiciaire du lieu de la tenue des assises. L’un des '
                    'assesseurs peut être un magistrat honoraire.',
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle('1.1.3.1.2 - Le jury'),
                  const _Paragraph(
                    'Le jury populaire est composé de six jurés lorsque la cour d’assises '
                    'statue en premier ressort et de neuf jurés lorsqu’elle statue en appel.',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les jurés, au moment de la constitution du jury, doivent prêter '
                          'serment (',
                    ),
                    _cppArticle('Article 304 du Code de procédure pénale'),
                    const TextSpan(
                      text:
                          '), ce serment rappelant notamment la présomption d’innocence et '
                          'la règle selon laquelle le doute profite à l’accusé et aux '
                          'intérêts des victimes.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Pour être juré, il faut : être Français, âgé d’au moins 23 ans, '
                    'savoir lire et écrire, et jouir de ses droits civils et civiques.',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text: 'Certaines incompatibilités sont prévues par les ',
                    ),
                    _cppArticle(
                      'Articles 256 et 257 du Code de procédure pénale',
                    ),
                    const TextSpan(
                      text:
                          ' : elles peuvent tenir aux fonctions exercées (préfets, '
                          'fonctionnaires de police, militaires…), à la capacité (incapables '
                          'majeurs, majeurs en tutelle…) ou à la moralité (personnes en '
                          'état d’accusation, sous mandat de dépôt ou d’arrêt, personnes '
                          'dont le bulletin n° 1 du casier judiciaire mentionne une '
                          'condamnation pour crime ou pour certains délits).',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Certaines personnes peuvent être dispensées des fonctions de juré '
                    'lorsqu’elles sont âgées de plus de 70 ans ou lorsque leur résidence '
                    'principale n’est pas située dans le département siège de la cour '
                    'd’assises, dès lors qu’elles justifient d’un motif grave reconnu '
                    'valable.',
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle('Désignation des jurés'),
                  const _Paragraph(
                    'À partir des listes électorales, chaque commune dresse une liste '
                    'comportant un certain nombre de noms fixé par arrêté. Ces listes sont '
                    'envoyées au greffe de la juridiction où siège la cour d’assises.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Une commission composée de magistrats, du bâtonnier de l’ordre des '
                    'avocats et de personnalités électives locales établit ensuite la '
                    'liste annuelle du jury. Elle exclut les personnes ne pouvant exercer '
                    'les fonctions de juré, puis procède à un tirage au sort.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Trente jours avant l’ouverture de la session d’assises, le premier '
                    'président de la cour d’appel ou son délégué, ou le président du '
                    'tribunal judiciaire siège de la cour d’assises ou son délégué, tire '
                    'au sort en audience publique les noms de 35 jurés titulaires et 10 '
                    'suppléants qui composeront la liste de session du jury. Ces nombres '
                    'sont portés à 45 titulaires et 15 suppléants pour la cour d’assises '
                    'de Paris ainsi que pour certaines cours désignées par arrêté du '
                    'ministre de la Justice.',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Quand il estime qu’un nombre important de jurés risque de ne pas '
                          'répondre à la convocation, le premier président de la cour '
                          'd’appel peut décider une augmentation de ces effectifs (',
                    ),
                    _cppArticle('Article 266 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Cette liste est signifiée à chaque accusé au plus tard l’avant-'
                          'veille de l’ouverture des débats (',
                    ),
                    _cppArticle('Article 282 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Avant le jugement de chaque nouvelle affaire, le président de la '
                          'cour d’assises tire au sort, à partir de la liste de session, les '
                          'noms des 6 ou 9 jurés qui composeront le jury de jugement. À '
                          'mesure que les noms sortent de l’urne, l’accusé peut récuser '
                          'jusqu’à 4 jurés en premier ressort et jusqu’à 5 jurés en appel ; '
                          'le ministère public peut récuser plus de 3 jurés en premier '
                          'ressort et plus de 4 en appel (',
                    ),
                    _cppArticle(
                      'Articles 297 et 298 du Code de procédure pénale',
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Quinze jours au moins avant l’ouverture de la session, le '
                          'greffier de la cour d’assises convoque, par courrier, chacun des '
                          'jurés titulaires et suppléants. Cette convocation rappelle '
                          'l’obligation pour tout citoyen de répondre à celle-ci. Si '
                          'nécessaire, le greffier peut requérir les services de police ou '
                          'de gendarmerie afin de rechercher les jurés qui n’auraient pas '
                          'répondu et de leur remettre la convocation (',
                    ),
                    _cppArticle('Article 267 du Code de procédure pénale'),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle('1.1.3.1.3 - Le parquet général'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le ministère public est représenté devant la cour d’assises par '
                          "l’avocat général si la cour siège au niveau de la cour d’appel, "
                          'ou par le procureur de la République si elle siège dans les '
                          'locaux du tribunal judiciaire.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle('1.1.3.2 - Compétence'),
                  _Paragraph.rich([
                    const TextSpan(text: 'Selon '),
                    _cppArticle('l’Article 231 du Code de procédure pénale'),
                    const TextSpan(
                      text:
                          ', « la cour d’assises a plénitude de juridiction pour juger en '
                          'premier ressort ou en appel les personnes renvoyées devant elle '
                          'par la décision de mise en accusation ». Elle connaît donc des '
                          'crimes et de certaines infractions connexes.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  '© SDCP - Tous droits réservés',
                  style: GoogleFonts.fustat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : const Color(0xFF757575),
                  ),
                ),
              ),
            ],
          ),
        ),
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
