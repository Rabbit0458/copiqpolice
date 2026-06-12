import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — DROIT AU RESPECT DE LA VIE PRIVÉE
///
///   CHAPITRE 1 — LE RESPECT DE LA VIE PRIVÉE
///     1.1  La vidéoprotection
///     1.2  La protection pénale de la vie privée
///     1.3  La protection civile du respect de la vie privée
///
///   CHAPITRE 2 — LE DROIT AU SECRET DES CORRESPONDANCES
///     2.1  Protection pénale
///     2.2  Exceptions (contrôles, saisies, interceptions)
///
///   CHAPITRE 3 — LE DROIT AU RESPECT DU DOMICILE
///     3.1  Notion de domicile
///     3.2  Violation de domicile
///     3.3  Cas légaux permettant aux policiers de pénétrer dans un domicile
///     3.4  Le cas particulier de la fouille des véhicules
/// ===================================================================
class PaDroitViePriveePage extends StatelessWidget {
  const PaDroitViePriveePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/individuelles/droit_vie_privee';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF6A1B9A)
        : const Color(0xFF6A1B9A);
    final Color referenceColor = isDark
        ? const Color(0xFFBA68C8)
        : const Color(0xFF6A1B9A);
    const dangerColor = Color(0xFFFF3B30);

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
          "Droit au respect de la vie privée",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // =====================================================
          // INTRODUCTION GÉNÉRALE
          // =====================================================
          Text(
            "Vie privée, domicile, correspondances et image",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  "Le droit au respect de la vie privée protège la sphère personnelle de chaque individu : domicile, correspondances, image, "
                  "secret des informations relatives à la vie personnelle, familiale, sentimentale, professionnelle, à la santé, au patrimoine, aux opinions, etc. "
                  "Toute atteinte portée à cette sphère ne peut être légale que si elle est expressément prévue par un texte et strictement nécessaire à la réalisation de l’objectif poursuivi. ",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  "La protection de ce droit trouve son fondement dans plusieurs textes juridiques majeurs :\n",
              style: TextStyle(color: textColor),
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "l’article 12 de la Déclaration universelle des droits de l’Homme de l’Organisation des Nations unies, qui dispose que : "
                  "« Nul ne fera l’objet d’immixtions arbitraires dans sa vie privée, sa famille, son domicile ou sa correspondance, ni d’atteintes à son honneur et à sa réputation. "
                  "Toute personne a droit à la protection de la loi contre de telles immixtions ou de telles atteintes » ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "l’article 8 de la Convention européenne de sauvegarde des droits de l’Homme et des libertés fondamentales, "
                  "qui consacre le droit de toute personne au respect de sa vie privée et familiale, de son domicile et de sa correspondance ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la Déclaration des droits de l’Homme et du citoyen de 1789, notamment son article 2 qui garantit la liberté, la sûreté et la propriété, "
                  "et son article 9 relatif à la présomption d’innocence ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi du 17 juillet 1970, qui assure la protection de la vie privée tant sur le plan pénal que sur le plan civil ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "l’article 9 du Code civil, qui énonce que « chacun a droit au respect de sa vie privée » ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "de nombreuses incriminations du Code pénal, qui sanctionnent la violation du secret des correspondances, la violation de domicile et diverses atteintes à l’intimité de la vie privée.",
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  "Le Conseil constitutionnel, après avoir longtemps refusé d’ériger le respect de la vie privée en principe de valeur constitutionnelle, "
                  "a précisé, dans une décision du 18 janvier 1995 rendue à l’occasion de la loi d’orientation et de programmation relative à la sécurité, "
                  "que la méconnaissance du droit au respect de la vie privée pouvait être de nature à porter atteinte à la liberté individuelle. "
                  "Par cette décision, les atteintes les plus graves au droit au respect de la vie privée relevaient alors de la compétence exclusive du juge judiciaire. ",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  "Par la suite, le Conseil constitutionnel a rattaché explicitement ce principe à l’article 2 de la Déclaration des droits de l’Homme et du citoyen "
                  "dans sa décision du 23 juillet 1999. "
                  "Ce rattachement a renforcé la protection constitutionnelle du droit au respect de la vie privée, qui relève désormais à la fois des juridictions de l’ordre judiciaire et de l’ordre administratif. "
                  "Cette analyse a été confirmée à l’occasion de questions prioritaires de constitutionnalité.",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 10),
          _NotaBox(
            title: "Enjeu opérationnel pour les forces de l’ordre",
            bodySpans: [
              TextSpan(
                text:
                    "Toute intervention de police peut impliquer, directement ou indirectement, la vie privée : contrôle dans un domicile, "
                    "recueil d’informations personnelles, mise en œuvre de systèmes de vidéoprotection, fouille d’un véhicule, "
                    "exploitation de téléphones ou de messageries, diffusion d’images, interceptions de communications, etc. "
                    "La moindre erreur de base légale ou de procédure peut être constitutive d’une atteinte illégale à la vie privée, "
                    "exposant l’agent et l’institution à des conséquences pénales, civiles et disciplinaires.",
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — LE RESPECT DE LA VIE PRIVÉE
          // =====================================================
          _HypoCard(
            title:
                "Chapitre 1 — Le respect de la vie privée : un droit général protégé par le droit pénal et par le droit civil",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "La vie privée n’est pas définie de manière précise par la loi du 17 juillet 1970. Les juridictions françaises en ont cependant une conception très large. "
                      "La jurisprudence et la doctrine définissent la vie privée comme le droit, pour tout individu, d’interdire à des tiers d’avoir accès à sa vie personnelle afin d’en préserver l’anonymat et l’intimité. ",
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Relèvent ainsi de la vie privée tout ce qui a trait à la vie sentimentale, à la vie familiale, à l’état de santé, à la naissance, à la mort, au patrimoine, à la situation financière, "
                      "aux convictions personnelles, aux loisirs, à la vie professionnelle lorsqu’elle touche à l’intimité, à l’image de la personne, etc. "
                      "Il en résulte que la divulgation de faits relevant de la vie privée n’est licite que si ces faits sont déjà notoirement connus ou si la personne intéressée a donné son consentement. ",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La loi du 17 juillet 1970 a organisé la protection de la vie privée sur deux plans complémentaires : ",
                ),
                TextSpan(
                  text: "un plan pénal",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "un plan civil.",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Idée clé",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le droit au respect de la vie privée est une liberté fondamentale bénéficiant d’une double protection : "
                        "protection pénale (par la création d’infractions spécifiques) et protection civile (par l’action en responsabilité et les mesures d’urgence destinées à faire cesser l’atteinte).",
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // 1.1 — LA VIDÉOPROTECTION
          // =====================================================
          _HypoCard(
            title: "1.1 — La vidéoprotection",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "La loi du 21 janvier 1995 d’orientation et de programmation relative à la sécurité a autorisé le recours aux systèmes de vidéoprotection, anciennement appelés « vidéosurveillance ». "
                      "Le titre V du Code de la sécurité intérieure, aux articles L. 251-1 et suivants, fixe les dispositions générales, les conditions de fonctionnement, les contrôles, "
                      "les droits d’accès ainsi que les dispositions pénales applicables. "
                      "L’objectif est de concilier la prévention des atteintes à l’ordre public avec la protection de la vie privée.",
                ),
              ]),
              const SizedBox(height: 12),

              // 1.1.1
              Text(
                "1.1.1 — Dispositions générales",
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
                      "L’article L. 251-2 du Code de la sécurité intérieure prévoit que des systèmes de vidéoprotection peuvent être mis en œuvre sur la voie publique par les autorités publiques compétentes afin d’assurer notamment :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la protection des bâtiments et installations publics et de leurs abords ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la sauvegarde des installations utiles à la défense nationale ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: "la régulation des flux de transport ;"),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la constatation des infractions aux règles de la circulation ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la prévention des atteintes à la sécurité des personnes et des biens dans des lieux particulièrement exposés aux risques d’agression, de vol ou de trafic de stupéfiants, "
                      "ainsi que la prévention, dans des zones particulièrement exposées, des fraudes douanières et des délits relatifs à des fonds provenant de ces infractions ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la prévention des actes de terrorisme, dans les conditions prévues par les articles L. 223-1 et suivants du Code de la sécurité intérieure ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la prévention des risques naturels ou technologiques ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le secours aux personnes et la défense contre l’incendie ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la sécurité des installations accueillant du public dans les parcs d’attraction ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le contrôle du respect de l’obligation d’assurance de responsabilité civile pour les véhicules terrestres à moteur ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la prévention et la constatation des infractions relatives à l’abandon d’ordures, de déchets, de matériaux ou d’autres objets.",
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Des systèmes de vidéoprotection peuvent également être mis en œuvre dans des lieux et établissements ouverts au public, afin d’y assurer la sécurité des personnes et des biens "
                      "lorsque ces lieux sont particulièrement exposés à des risques d’agression ou de vol. ",
                ),
              ]),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Après information du maire de la commune concernée et autorisation des autorités publiques compétentes, "
                      "des commerçants peuvent mettre en œuvre sur la voie publique un système de vidéoprotection pour assurer la protection des abords immédiats de leurs bâtiments et installations "
                      "dans les lieux particulièrement exposés à des risques d’agression ou de vol. Les conditions de mise en œuvre et les types de bâtiments concernés sont définis par décret en Conseil d’État. ",
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les opérations de vidéoprotection de la voie publique doivent être réalisées de telle sorte qu’elles ne permettent pas de visualiser l’intérieur des immeubles d’habitation, "
                      "ni, de façon spécifique, les entrées de ces immeubles (article L. 251-3 du Code de la sécurité intérieure).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Dans chaque département, une commission départementale de vidéoprotection, présidée par un magistrat honoraire ou, à défaut, par une personnalité qualifiée nommée par le premier président de la cour d’appel, "
                      "est chargée de donner un avis au représentant de l’État dans le département (ou, à Paris, au préfet de police) sur les demandes d’autorisation de systèmes de vidéoprotection "
                      "et d’exercer un contrôle sur les conditions de fonctionnement des systèmes autorisés. "
                      "La personnalité qualifiée est choisie en raison de sa compétence en matière de vidéoprotection ou de libertés individuelles (article L. 251-4 du Code de la sécurité intérieure).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 14),

              // 1.1.2
              Text(
                "1.1.2 — Autorisations et conditions de fonctionnement",
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
                      "L’installation d’un système de vidéoprotection est subordonnée à une autorisation du représentant de l’État dans le département "
                      "(et, à Paris, du préfet de police), délivrée, sauf en matière de défense nationale, après avis de la commission départementale de vidéoprotection. "
                      "Lorsque le système comporte des caméras implantées sur le territoire de plusieurs départements, l’autorisation est délivrée par le représentant de l’État dans le département "
                      "où est situé le siège social du demandeur ou, si ce siège est à Paris, par le préfet de police, après avis de la commission départementale compétente. "
                      "Les représentants de l’État des autres départements concernés sont informés de cette décision (article L. 252-1 du Code de la sécurité intérieure).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’autorisation préfectorale prescrit toutes les précautions utiles, en particulier en ce qui concerne la qualité des personnes chargées de l’exploitation du système et de la visualisation des images, "
                      "ainsi que les mesures nécessaires pour assurer le respect des dispositions des articles L. 251-1 à L. 255-1 du Code de la sécurité intérieure (article L. 252-2). "
                      "Elle peut prévoir que des agents individuellement désignés et habilités des services de police et de gendarmerie nationales, des douanes, des services d’incendie et de secours, "
                      "ainsi que les agents des services de police municipale et de la Ville de Paris, soient destinataires des images et enregistrements. "
                      "Dans ce cas, l’autorisation précise les modalités de transmission des images, les conditions d’accès aux enregistrements et la durée de conservation des images, "
                      "dans la limite d’un mois à compter de cette transmission ou de cet accès, sans préjudice de la conservation nécessaire à une procédure pénale (article L. 252-3).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les systèmes de vidéoprotection sont autorisés pour une durée de cinq ans renouvelable. "
                      "Ils doivent être conformes à des normes techniques fixées par arrêté du ministre de l’Intérieur (article L. 252-4 du Code de la sécurité intérieure). "
                      "En dehors des cas d’enquête de flagrance, d’enquête préliminaire ou d’information judiciaire, les enregistrements doivent être détruits dans un délai maximum fixé par l’autorisation, "
                      "sans pouvoir excéder un mois (article L. 252-5).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Lorsque l’urgence et l’exposition particulière à un risque d’actes de terrorisme le justifient (article L. 223-4 du Code de la sécurité intérieure), "
                      "le représentant de l’État dans le département, et à Paris le préfet de police, peuvent délivrer, sans avis préalable de la commission départementale, "
                      "une autorisation provisoire d’installation d’un système de vidéoprotection pour une durée maximale de quatre mois. "
                      "Le président de la commission est immédiatement informé et peut la réunir afin qu’elle donne un avis sur cette autorisation provisoire. "
                      "Une procédure similaire est prévue en cas de manifestation ou de rassemblement de grande ampleur présentant des risques particuliers pour la sécurité des personnes et des biens "
                      "(articles L. 252-6 et L. 252-7 du Code de la sécurité intérieure).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 14),

              // 1.1.3
              Text(
                "1.1.3 — Contrôle et droit d’accès",
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
                      "La commission départementale de vidéoprotection peut, à tout moment, exercer un contrôle sur les conditions de fonctionnement des systèmes de vidéoprotection, "
                      "sauf en matière de défense nationale, pour vérifier leur conformité aux articles L. 251-2 et L. 251-3 du Code de la sécurité intérieure. "
                      "Elle peut émettre des recommandations et proposer la suspension ou la suppression des dispositifs non autorisés, non conformes à leur autorisation ou faisant l’objet d’un usage anormal. "
                      "Elle informe le maire de la commune concernée de ses propositions (article L. 253-1).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les membres de la commission départementale disposent d’un droit d’accès, de six heures à vingt et une heures, aux lieux, locaux, enceintes, installations ou établissements "
                      "où est mis en œuvre un système de vidéoprotection, à l’exclusion des parties affectées au domicile privé. "
                      "Le procureur de la République territorialement compétent est préalablement informé. "
                      "Le responsable des locaux professionnels privés est informé de son droit de s’opposer à la visite. "
                      "En cas d’opposition, la visite ne peut avoir lieu qu’après autorisation du juge des libertés et de la détention du tribunal judiciaire compétent. "
                      "En cas d’urgence, de gravité des faits ou de risque de destruction de documents, la visite peut être autorisée sans information préalable du responsable, "
                      "sur décision du même juge. La visite se déroule alors sous son autorité et en présence de l’occupant ou de son représentant, "
                      "assisté éventuellement d’un conseil, ou, à défaut, en présence de deux témoins (article L. 253-3).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "À la demande de la commission départementale ou de sa propre initiative, le représentant de l’État dans le département, et à Paris le préfet de police, "
                      "peuvent ordonner la fermeture, pour une durée de trois mois, d’un établissement ouvert au public dans lequel est maintenu un système de vidéoprotection sans autorisation. "
                      "À l’issue de ce délai, si aucune régularisation n’a été demandée, l’autorité administrative peut enjoindre au responsable de démonter le système. "
                      "En cas de refus, une nouvelle mesure de fermeture pour trois mois peut être prise (article L. 253-4). "
                      "Toute personne intéressée peut saisir la commission départementale de vidéoprotection de toute difficulté liée au fonctionnement d’un système (article L. 253-5).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.1.4
              Text(
                "1.1.4 — Dispositions pénales",
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
                      "Le fait d’entraver l’action de la commission départementale de vidéoprotection est puni d’un an d’emprisonnement et de quinze mille euros d’amende (article L. 254-1 du Code de la sécurité intérieure). "
                      "Par ailleurs, le Code pénal sanctionne l’installation de caméras dans des lieux réservés à l’intimité (toilettes, cabines d’essayage, chambres, locaux syndicaux), "
                      "la conservation d’images au-delà de la durée autorisée, leur diffusion illicite ou le détournement de finalité, "
                      " lorsque les images sont utilisées pour porter atteinte à la vie privée ou à la réputation d’une personne.",
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // 1.2 — PROTECTION PÉNALE DE LA VIE PRIVÉE
          // =====================================================
          _HypoCard(
            title: "1.2 — La protection pénale de la vie privée",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "L’expansion démographique, le développement des moyens d’information et de communication, ainsi que le perfectionnement des techniques de captation de paroles ou d’images, "
                      "constituent des menaces potentielles pour le droit au respect de la vie privée. "
                      "Avant la loi du 17 juillet 1970 tendant à renforcer la garantie des droits individuels, aucune disposition générale ne sanctionnait les atteintes à la vie privée. "
                      "Cette loi a érigé plusieurs atteintes en infractions pénales spécifiques.",
                ),
              ]),
              const SizedBox(height: 12),

              // 1.2.1
              Text(
                "1.2.1 — L’atteinte à l’intimité de la vie privée",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-1 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "est puni le fait, au moyen d’un procédé quelconque, de porter volontairement atteinte à l’intimité de la vie privée d’autrui, notamment :",
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "en captant, enregistrant ou transmettant, sans le consentement de leur auteur, des paroles prononcées à titre privé ou confidentiel ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "en fixant, enregistrant ou transmettant, sans le consentement de la personne concernée, l’image d’une personne se trouvant dans un lieu privé ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "en captant, enregistrant ou transmettant, par quelque moyen que ce soit, la localisation, en temps réel ou en différé, d’une personne sans son consentement.",
                ),
              ]),
              const SizedBox(height: 4),
              const _NotaBox(
                title: "Pour les policiers",
                bodySpans: [
                  TextSpan(
                    text:
                        "La captation clandestine d’images, de sons ou de données de localisation par un agent, en dehors de tout cadre légal "
                        "(enquête, information judiciaire, réquisition d’un magistrat), peut constituer directement une atteinte à l’intimité de la vie privée au sens de l’article 226-1 du Code pénal. "
                        "Cette incrimination fait l’objet d’un développement approfondi dans le fascicule de droit pénal spécial relatif aux crimes et délits contre les personnes.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 1.2.2
              Text(
                "1.2.2 — Conservation, divulgation ou utilisation d’un enregistrement ou d’un document obtenu par une atteinte à la vie privée",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-2 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "incrimine le fait de conserver, de porter ou de laisser porter à la connaissance du public, ou d’utiliser, un enregistrement ou un document "
                      "obtenu dans les conditions prévues par l’article 226-1 du Code pénal, sans le consentement de la personne concernée. "
                      "Il s’agit d’une infraction de conséquence, qui sanctionne la diffusion ou l’exploitation d’un enregistrement illicite. "
                      "Cette incrimination fait également l’objet d’un développement spécifique en droit pénal spécial.",
                ),
              ]),
              const SizedBox(height: 12),

              // 1.2.3
              Text(
                "1.2.3 — Les caméras piétons",
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
                      "L’article L. 241-1 du Code de la sécurité intérieure pérennise le dispositif des caméras individuelles portées par les agents de la police nationale et les militaires de la gendarmerie nationale "
                      "dans l’exercice de leurs missions de prévention des atteintes à l’ordre public, de protection de la sécurité des personnes et des biens, et de missions de police judiciaire. "
                      "Ces enregistrements ne peuvent être permanents. Ils peuvent être mis en œuvre en tous lieux, y compris dans des lieux privés, en vue :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "de la prévention des incidents au cours des interventions ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "du constat des infractions et de la poursuite de leurs auteurs par la collecte de preuves ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: "de la formation et de la pédagogie des agents.",
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Lorsque la sécurité des agents ou celle des personnes et des biens est menacée, les images captées au moyen de ces caméras peuvent être transmises en temps réel "
                      "au poste de commandement du service concerné et aux personnels impliqués dans la conduite de l’intervention. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Des obligations strictes pèsent sur les fonctionnaires autorisés à porter ces caméras : elles sont fournies par le service, doivent être portées de manière apparente "
                      "et doivent être dotées d’un signal permettant d’indiquer qu’un enregistrement est en cours ; "
                      "les personnes filmées doivent être informées, sauf circonstances rendant cette information impossible ; "
                      "les agents ne peuvent accéder aux enregistrements qu’à la condition que cette consultation soit nécessaire pour faciliter la recherche d’auteurs d’infractions, "
                      "la prévention d’atteintes imminentes à l’ordre public, le secours aux personnes ou l’établissement fidèle des faits dans les comptes rendus d’intervention. "
                      "Les articles R. 241-1 à R. 241-7 du Code de la sécurité intérieure précisent les modalités de traitement des données issues de ces enregistrements. "
                      "Une instruction du premier mars deux mille dix-sept, complétée par une instruction conjointe de la direction générale de la police nationale et de la direction générale de la gendarmerie nationale du dix-neuf novembre deux mille dix-neuf, "
                      "fixe les règles d’emploi opérationnel des caméras piétons.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 1.2.4
              Text(
                "1.2.4 — Diffusion, sans l’accord de la personne concernée, d’un enregistrement ou d’un document à caractère sexuel",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text: "Article 226-2-1 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
                TextSpan(
                  text:
                      "incrimine le fait, en l’absence d’accord de la personne pour la diffusion, de porter à la connaissance du public ou d’un tiers tout enregistrement ou tout document "
                      "portant sur des paroles ou des images présentant un caractère sexuel, obtenu avec le consentement exprès ou présumé de la personne, ou réalisé par elle-même, "
                      "à l’aide d’un des procédés prévus à l’article 226-1 du Code pénal. "
                      "Cette pratique est couramment désignée sous le terme de « pornodivulgation », souvent connue sous l’appellation anglophone « revenge porn ». "
                      "Cette infraction est détaillée dans le fascicule de droit pénal spécial consacré aux crimes et délits contre les personnes.",
                ),
              ]),
              const SizedBox(height: 10),

              // 1.2.5
              Text(
                "1.2.5 — L’atteinte à l’intimité d’une personne : le voyeurisme",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-3-1 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "définit et réprime le voyeurisme comme « le fait d’user de tout moyen afin d’apercevoir les parties intimes d’une personne que celle-ci, "
                      "du fait de son habillement ou de sa présence dans un lieu clos, a cachées à la vue des tiers, lorsque cela est commis à l’insu ou sans le consentement de la personne ». "
                      "Cette infraction vise à protéger l’intimité corporelle et la dignité de la personne.",
                ),
              ]),
              const SizedBox(height: 10),

              // 1.2.6
              Text(
                "1.2.6 — L’atteinte à la représentation de la personne (montages, trucages, hypertrucages)",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-8 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "incrimine le fait de porter à la connaissance du public ou d’un tiers, par quelque moyen que ce soit, un montage réalisé avec les paroles ou l’image d’une personne, "
                      "sans son consentement, lorsqu’il n’apparaît pas clairement qu’il s’agit d’un montage ou lorsqu’il n’en est pas fait mention. "
                      "Est également puni, dans les mêmes conditions, le fait de diffuser un contenu visuel ou sonore généré par un traitement algorithmique, "
                      "représentant l’image ou les paroles d’une personne, sans son consentement, lorsqu’il n’apparaît pas à l’évidence qu’il s’agit d’un contenu généré artificiellement "
                      "ou lorsqu’il n’en est pas fait mention. "
                      "Ce texte vise notamment les hypertrucages (« deepfakes ») créés à l’aide d’outils d’intelligence artificielle. "
                      "L’enjeu principal n’est pas seulement l’intimité, mais la protection de la dignité et de l’honnêteté de la représentation de la personne.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // 1.3 — PROTECTION CIVILE DU RESPECT DE LA VIE PRIVÉE
          // =====================================================
          _HypoCard(
            title: "1.3 — La protection civile du respect de la vie privée",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 9 du Code civil : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "énonce que « chacun a droit au respect de sa vie privée ». "
                      "Les juridictions rappellent fréquemment que toute personne est fondée à fixer elle-même les limites de ce qui peut être rendu public ou non. "
                      "Les personnalités publiques bénéficient, au même titre que toute autre personne, de ce droit au respect de leur vie privée, "
                      "notamment en matière de santé, de vie sentimentale ou familiale.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "De nombreux arrêts ont confirmé cette protection, concernant notamment Brigitte Bardot, Isabelle Adjani, Alain Delon, Jacques Brel, etc., "
                      "à propos de la publication de photographies ou d’éléments relevant de leur intimité.",
                ),
              ]),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Le droit au respect de la vie privée s’étend au-delà de la mort, incluant le respect dû à la dépouille mortelle. "
                      "La publication, sans l’accord de la famille, de photographies d’une personne célèbre sur son lit de mort a été jugée constitutive d’une atteinte au droit au respect de la vie privée des proches. ",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Des décisions ont ainsi concerné, par exemple, Jean Gabin, Pauline Carton, Coluche, et d’autres personnalités dont l’image a été diffusée après leur décès sans autorisation.",
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Toute divulgation d’aspects de la vie privée d’une personne, sans son consentement, peut être sanctionnée civilement. "
                      "Plusieurs textes fondamentaux encadrent les actions ouvertes à la victime :",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "article 1240 du Code civil : « tout fait quelconque de l’homme, qui cause à autrui un dommage, oblige celui par la faute duquel il est arrivé à le réparer ». "
                      "Une atteinte à la vie privée peut donc fonder une action en responsabilité civile ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "article 9, alinéa 2, du Code civil : « les juges peuvent, sans préjudice de la réparation du dommage subi, prescrire toutes mesures, telles que séquestre, saisie et autres, "
                      "propres à empêcher ou faire cesser une atteinte à l’intimité de la vie privée ; ces mesures peuvent, s’il y a urgence, être ordonnées en référé » ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "article 835 du Code de procédure civile : le président du tribunal judiciaire ou le juge des contentieux de la protection peuvent, en référé, "
                      "prescrire les mesures conservatoires ou de remise en état qui s’imposent, pour prévenir un dommage imminent ou faire cesser un trouble manifestement illicite. "
                      "Ce texte fait du juge des référés le juge de droit commun des atteintes à la vie privée en urgence.",
                ),
              ]),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: "Exemple jurisprudentiel",
                bodySpans: [
                  TextSpan(
                    text:
                        "La diffusion de photographies d’une personnalité publique prises dans sa propriété privée, sans son consentement, "
                        "constitue une atteinte à la vie privée, même si la personne est de grande notoriété. "
                        "Le droit à l’information du public ne justifie pas la divulgation d’éléments dépourvus d’intérêt général.",
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — LE SECRET DES CORRESPONDANCES
          // =====================================================
          _HypoCard(
            title: "Chapitre 2 — Le droit au secret des correspondances",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "L’inviolabilité des correspondances, qu’elles soient écrites, téléphoniques ou électroniques, protège la relation – souvent secrète – entre, en principe, deux personnes identifiées. "
                      "Cette protection vise les échanges de pensées et de sentiments par tout moyen de communication : lettres, courriels, messages électroniques, "
                      "services de messagerie instantanée, communications téléphoniques, échanges par voie numérique, etc. "
                      "Toute ingérence dans ce secret constitue, en principe, une infraction pénale, sauf si elle est expressément autorisée par la loi pour des motifs d’ordre public.",
                ),
              ]),
              const SizedBox(height: 12),

              Text(
                "2.1 — La protection pénale du droit au secret des correspondances",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              // 2.1.1
              Text(
                "2.1.1 — Atteinte au secret des correspondances commise par des particuliers",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-15 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "définit et réprime le fait, commis de mauvaise foi, d’ouvrir, de supprimer, de retarder ou de détourner des correspondances "
                      "arrivées ou non à destination et adressées à des tiers, ou d’en prendre frauduleusement connaissance. "
                      "Sont également punis, dans les mêmes conditions, le fait d’intercepter, de détourner, d’utiliser ou de divulguer des correspondances émises, transmises ou reçues par voie électronique, "
                      "ou le fait de procéder à l’installation d’appareils permettant de réaliser de telles interceptions. "
                      "Cette infraction est étudiée en détail dans le fascicule de droit pénal spécial relatif aux crimes et délits contre les personnes.",
                ),
              ]),
              const SizedBox(height: 8),

              // 2.1.2
              Text(
                "2.1.2 — Atteinte au secret des correspondances commise par des fonctionnaires publics",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 432-9 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "prévoit que le fait, pour une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, "
                      "agissant dans l’exercice ou à l’occasion de l’exercice de ses fonctions, d’ordonner, de commettre ou de faciliter, hors les cas prévus par la loi, "
                      "le détournement, la suppression ou l’ouverture de correspondances, ou la révélation de leur contenu, est puni de trois ans d’emprisonnement et de quarante-cinq mille euros d’amende. "
                      "Sont également punis, dans les mêmes conditions, les actes d’interception ou de détournement de correspondances électroniques, ou la divulgation de leur contenu, "
                      "commis par ces mêmes personnes ou par les agents d’exploitants de réseaux ouverts au public de communications électroniques ou de fournisseurs de services de télécommunications. "
                      "Cette infraction est étudiée dans le fascicule de droit pénal spécial consacré aux crimes et délits contre la nation, l’État et la paix publique.",
                ),
              ]),
              const SizedBox(height: 12),

              // 2.2
              Text(
                "2.2 — Les exceptions au principe d’inviolabilité des correspondances",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Ces exceptions sont strictement définies par la loi et justifiées par des motifs d’ordre public : poursuites pénales, lutte contre la criminalité organisée ou le terrorisme, "
                      "sécurité nationale, protection des droits d’autrui, prévention de certaines infractions graves, etc.",
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "2.2.1 — Les contrôles et saisies",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Lorsque ces contrôles et saisies sont réalisés dans un cadre judiciaire, ils peuvent être effectués par le juge d’instruction, "
                      "par le procureur de la République en cas de flagrant délit, ou par un officier de police judiciaire agissant sur commission rogatoire ou dans un cadre de flagrance. "
                      "Des contrôles administratifs sont également possibles, par exemple pour la correspondance des personnes détenues (à l’exception des échanges avec leur avocat ou leur aumônier), "
                      "ou dans certains établissements psychiatriques pour le courrier des malades mentaux. ",
                ),
              ]),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Dans des contextes particuliers, comme en temps de guerre, dans le cadre de régimes d’exception (état d’urgence, état de siège, état de crise) "
                      "ou encore en matière de faillite, la correspondance peut faire l’objet de censures ou de contrôles dans le but de protéger les droits d’autrui, "
                      "la masse des créanciers ou la sécurité de l’État.",
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "2.2.2 — Les interceptions de correspondances émises par la voie des communications électroniques",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Il convient de distinguer les interceptions ordonnées par l’autorité judiciaire dans le cadre du droit commun ou de la criminalité et de la délinquance organisées, "
                      "et les interceptions dites « de sécurité », autorisées à des fins de renseignement.",
                ),
              ]),
              const SizedBox(height: 6),

              Text(
                "2.2.2.1 — Les interceptions ordonnées par l’autorité judiciaire en droit commun",
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
                      "Les articles 100 à 100-8 du Code de procédure pénale encadrent les interceptions judiciaires de correspondances émises par la voie des télécommunications. "
                      "Ces interceptions ne peuvent être ordonnées que si la peine encourue pour l’infraction est au moins égale à trois ans d’emprisonnement "
                      "et si les nécessités de l’information l’exigent. "
                      "Elles sont décidées par le juge d’instruction, par une décision écrite et motivée, pour une durée maximale de quatre mois, renouvelable dans les mêmes conditions de forme. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Lorsque l’interception vise le cabinet ou le domicile d’un avocat, le bâtonnier doit être informé ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "lorsque la personne visée est un parlementaire, le président de l’assemblée concernée doit être informé préalablement ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "lorsque l’interception concerne un magistrat, le premier président ou le procureur général de la juridiction où il réside doit être informé.",
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "2.2.2.1.2 — Les interceptions dans le cadre de la criminalité et de la délinquance organisées",
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
                      "L’article 706-95 du Code de procédure pénale permet, lorsque les nécessités d’une enquête de flagrance ou d’une enquête préliminaire portant sur des infractions "
                      "relevant des articles 706-73 et 706-73-1 (criminalité et délinquance organisées) l’exigent, "
                      "au juge des libertés et de la détention, saisi par le procureur de la République, d’autoriser l’interception, l’enregistrement et la transcription de correspondances électroniques "
                      "pour une durée maximale d’un mois, renouvelable une fois dans les mêmes conditions. "
                      "Les opérations sont réalisées sous le contrôle du juge des libertés et de la détention. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’article 706-95-1 du Code de procédure pénale permet également, dans les mêmes domaines, d’autoriser l’accès à distance, à l’insu de la personne visée, "
                      "aux correspondances stockées par voie électronique, au moyen d’un identifiant informatique. "
                      "Les données ainsi obtenues peuvent être saisies, enregistrées ou copiées sur tout support. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "2.2.2.2 — Les interceptions de sécurité et l’accès aux données de connexion",
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
                      "La loi du vingt-quatre juillet deux mille quinze relative au renseignement a donné un cadre légal aux techniques mises en œuvre par les services de renseignement, "
                      "et notamment aux interceptions de sécurité et aux accès aux données de connexion. "
                      "Elle a instauré un régime d’autorisation administrative qui concerne l’ensemble des techniques de recueil de renseignement. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’autorisation d’une interception de sécurité est délivrée par le Premier ministre, par une décision écrite et motivée, "
                      "pour une durée maximale de quatre mois renouvelable (article L. 821-4 du Code de la sécurité intérieure). "
                      "Cette décision doit préciser la ou les techniques utilisées, le service demandeur, la ou les finalités et motifs des mesures, la durée de validité, "
                      "ainsi que les personnes, lieux ou véhicules concernés (article L. 821-2). ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La Commission nationale de contrôle des techniques de renseignement, autorité administrative indépendante, veille à ce que ces techniques soient mises en œuvre "
                      "conformément aux dispositions du Code de la sécurité intérieure (article L. 833-1). "
                      "Même dans la lutte contre le terrorisme ou la criminalité organisée, le secret des correspondances demeure la règle : "
                      "toute ingérence doit rester exceptionnelle, nécessaire et proportionnée.",
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — LE DROIT AU RESPECT DU DOMICILE
          // =====================================================
          _HypoCard(
            title: "Chapitre 3 — Le droit au respect du domicile",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // 3.1
              Text(
                "3.1 — La notion de domicile",
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
                      "La chambre criminelle de la Cour de cassation a jugé, le vingt-deux janvier mille neuf cent quatre-vingt-dix-sept, "
                      "que constitue un domicile « non seulement le lieu où une personne a son principal établissement, mais encore le lieu où, qu’elle y habite ou non, "
                      "elle a le droit de se dire chez elle, quels que soient le titre juridique de son occupation et l’affectation donnée aux locaux ». "
                      "La notion de domicile comprend donc aussi bien le domicile légal, la résidence habituelle que le lieu de séjour occasionnel, "
                      "à condition qu’il protège l’intimité de la personne.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La protection attachée au domicile ne recouvre pas exactement la distinction entre lieux publics et lieux privés. "
                      "Dans les établissements ouverts au public, comme un hôpital ou un centre d’accueil pour personnes toxicomanes, "
                      "il convient de distinguer :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "les espaces publics (halls d’accueil, salles d’attente), où les forces de l’ordre peuvent procéder à des contrôles ou à des interpellations ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "les espaces privés (chambres de patients, bureaux individuels du personnel), qui doivent être considérés comme des domiciles et bénéficier de la protection afférente.",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Pour tenir compte de certaines situations, la Cour de cassation a développé la notion de « lieu normalement clos ». "
                      "Même lorsqu’un endroit ne constitue pas à proprement parler un domicile, il n’est pas pour autant libre d’accès pour les forces de l’ordre s’il est normalement fermé au public. "
                      "Ces lieux bénéficient alors d’une protection proche de celle accordée au domicile.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Sont considérés comme des domiciles, notamment :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "l’appartement loué, la maison de campagne, la maison de vacances, la demeure momentanément inoccupée ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "les dépendances d’une maison se trouvant dans l’enceinte ou à proximité immédiate de celle-ci, dès lors qu’elles en constituent le prolongement : débarras, garage, balcon, terrasse, poulailler, remise, cour close d’un immeuble, etc. ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le logement occupé sans titre mais paisiblement, la chambre d’hôtel ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le bureau ou les locaux professionnels fermés au public (pendant les heures de fermeture) ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le véhicule aménagé pour l’habitation, la caravane, la roulotte, la tente servant de résidence ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le yacht de plaisance, le voilier de haute mer ou la péniche habitable.",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La jurisprudence a également admis que certains lieux peuvent être assimilés au domicile, par exemple :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: "un box fermé non attenant au domicile ;"),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "un garage situé dans un parking souterrain, lorsque ce garage est considéré comme l’annexe du domicile principal.",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "À l’inverse, ne sont pas considérés comme des domiciles :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: "le logement vide de meubles entre deux locations ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: "l’immeuble en construction ;"),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "l’appartement partiellement détruit et devenu inhabitable ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: "la cour non close d’un immeuble ;"),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "la hutte de chasse dépourvue d’aménagement pour l’habitation ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: "le local exclusivement réservé à la vente ;"),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le bloc opératoire (même si l’accès en est strictement limité pour des raisons médicales) ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: "le casier d’une consigne de gare ;"),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le véhicule automobile qui ne se trouve pas au domicile et qui n’est pas aménagé pour l’habitation ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le bateau ne comportant aucun aménagement intérieur destiné à l’habitation.",
                ),
              ]),
              const SizedBox(height: 12),

              // 3.2
              Text(
                "3.2 — La violation de domicile",
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
                      "Le domicile est traditionnellement décrit comme « inviolable et sacré ». "
                      "Toute personne qui pénètre, hors des cas prévus par la loi, dans le domicile d’autrui commet une violation de domicile.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                "3.2.1 — Violation de domicile commise par un particulier",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-4 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "incrimine le fait, pour un particulier, de s’introduire dans le domicile d’autrui à l’aide de manœuvres, de menaces, de voies de fait ou de contrainte, "
                      "hors les cas où la loi le permet, ainsi que le fait de se maintenir dans ce domicile après s’y être introduit dans ces conditions. "
                      "Constitue également un domicile, au sens de ce texte, tout local d’habitation contenant des biens meubles appartenant à la personne, "
                      "qu’elle y habite ou non, qu’il s’agisse de sa résidence principale ou secondaire. "
                      "Cette infraction est analysée en détail dans le fascicule de droit pénal spécial relatif aux crimes et délits contre les personnes.",
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                "3.2.2 — Violation de domicile commise par un fonctionnaire",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 432-8 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "prévoit que le fait, pour une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, "
                      "agissant dans l’exercice ou à l’occasion de l’exercice de ses fonctions, de s’introduire ou de tenter de s’introduire dans le domicile d’autrui contre le gré de celui-ci, "
                      "hors les cas prévus par la loi, est puni de deux ans d’emprisonnement et de trente mille euros d’amende. "
                      "Cette infraction appartient au droit pénal spécial des crimes et délits contre la nation, l’État et la paix publique.",
                ),
              ]),
              const SizedBox(height: 12),

              // 3.3
              Text(
                "3.3 — Les cas légaux permettant aux policiers de pénétrer dans un domicile",
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
                      "Certaines dispositions légales autorisent les forces de l’ordre à pénétrer dans un domicile, y compris sans le consentement de l’occupant. "
                      "On distingue les introductions possibles même en dehors des heures légales et celles qui ne peuvent avoir lieu que pendant les heures légales. "
                      "En principe, les heures légales d’intervention sont fixées entre six heures et vingt et une heures (article 59 du Code de procédure pénale).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.3.1 — Les cas d’introduction possibles même en dehors des heures légales",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Réclamation faite de l’intérieur de la maison (article 59 du Code de procédure pénale) : il s’agit de l’appel au secours, de cris ou de hurlements laissant présumer un danger. "
                      "L’introduction est justifiée même si l’appel s’avère ensuite fantaisiste ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Maison atteinte ou menacée par un incendie ou une inondation : la réclamation de l’intérieur n’est pas nécessaire, le péril peut même être ignoré des occupants ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Assistance à personne en péril (article 223-6, alinéa 2, du Code pénal) : dès lors que des indices sérieux laissent penser qu’une personne est en grave danger dans un domicile "
                      "(appel sans réponse, odeur suspecte, absence anormale d’une personne vivant seule, etc.), l’introduction est justifiée par l’obligation de porter assistance ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Intervention de police administrative en cas de danger imminent pour la sécurité des personnes (par exemple en matière d’admission en soins psychiatriques sans consentement) ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Mise en œuvre de dispositions spéciales relatives à la criminalité et à la délinquance organisées (articles 706-73 et 706-73-1 du Code de procédure pénale) : "
                      "des visites domiciliaires, perquisitions et saisies peuvent avoir lieu en dehors des heures légales, sous conditions de contrôle judiciaire strict ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Perquisitions en dehors des heures légales autorisées pour certains crimes graves contre les personnes, lorsque les nécessités de l’enquête de flagrance ou de l’information l’exigent ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Visites domiciliaires destinées à prévenir des actes de terrorisme, dans le cadre des dispositions du Code de la sécurité intérieure issues de la loi du trente octobre deux mille dix-sept : "
                      "la visite ne peut en principe commencer avant six heures ni après vingt et une heures, sauf autorisation spéciale du juge des libertés et de la détention ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "État de nécessité : certaines introductions sont justifiées par la nécessité de faire cesser un danger actuel ou imminent, "
                      "par exemple pour interrompre une fuite de gaz ou arrêter une alarme causant un trouble grave au voisinage.",
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                "3.3.2 — Les cas d’introduction pendant les heures légales",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Exécution d’un mandat d’amener, d’un mandat d’arrêt ou d’un mandat de recherche : la visite du domicile a pour but d’appréhender la personne visée, "
                      "en principe à son dernier domicile connu ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Exécution de décisions de condamnation et de contraintes judiciaires ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Interpellation d’une personne recherchée, dans le respect des heures légales ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Réalisation de perquisitions dans le cadre d’enquêtes criminelles ou délictuelles (articles 56 et suivants du Code de procédure pénale) ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Réalisation d’opérations de contrôle prévues par certaines réglementations, notamment en matière de droit du travail, de lutte contre le travail dissimulé, "
                      "de séjour irrégulier ou de règles d’hygiène ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Arrestation d’une personne en vue de l’exécution d’une peine privative de liberté : sur autorisation du ministère public, l’entrée dans le domicile de la personne condamnée "
                      "a pour unique but de l’appréhender (article 716-5 du Code de procédure pénale).",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Certains lieux bénéficient d’une protection renforcée : les locaux diplomatiques (convention de Vienne du dix-huit avril mille neuf cent soixante et un), "
                      "ainsi que les bâtiments de l’Assemblée nationale et du Sénat. "
                      "L’introduction des forces de l’ordre dans ces lieux n’est possible que sous des conditions très strictes, notamment avec le consentement du chef de mission diplomatique "
                      "ou sur réquisition du président de l’assemblée concernée.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.4
              Text(
                "3.4 — Le cas particulier de la fouille des véhicules",
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
                      "La fouille des véhicules, comme les contrôles d’identité, pose des questions sensibles en matière de libertés publiques. "
                      "La loi du dix-huit mars deux mille trois pour la sécurité intérieure a cherché à concilier le respect de la liberté individuelle et l’efficacité des investigations policières, "
                      "en encadrant l’intervention du procureur de la République et les pouvoirs des officiers de police judiciaire. "
                      "En principe, un véhicule n’est pas assimilé à un domicile, sauf s’il est spécialement aménagé pour être habité. "
                      "La fouille d’un véhicule n’est pas juridiquement une perquisition, mais elle porte tout de même atteinte à la vie privée et doit respecter des conditions strictes.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                "3.4.1 — Sur réquisitions écrites du procureur de la République (article 78-2-2 du Code de procédure pénale)",
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
                      "L’article 78-2-2 du Code de procédure pénale prévoit, dans des paragraphes distincts, les contrôles d’identité, les visites de véhicules, "
                      "les inspections visuelles et fouilles des bagages, ainsi que la visite des navires. "
                      "Aux fins de recherche et de poursuite de certaines infractions graves (actes de terrorisme, infractions liées aux armes de destruction massive, "
                      "infractions en matière d’armes ou d’explosifs, vols, recel, trafic de stupéfiants, etc.), le procureur de la République peut requérir, par écrit, "
                      "les officiers de police judiciaire, assistés le cas échéant des agents de police judiciaire et des agents de police judiciaire adjoints, "
                      "pour procéder à la visite de véhicules et à l’inspection ou à la fouille de bagages dans des lieux déterminés et pour une durée limitée, "
                      "qui ne peut excéder vingt-quatre heures, renouvelable une fois par décision motivée.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Les véhicules spécialement aménagés à usage d’habitation et effectivement utilisés comme résidence ne peuvent être visités que selon les règles applicables aux perquisitions et visites domiciliaires.",
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.4.1.1 — La visite des véhicules",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Lorsque le véhicule est en circulation, il ne peut être immobilisé que le temps strictement nécessaire au déroulement de la visite, en présence du conducteur ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "lorsque le véhicule est à l’arrêt ou en stationnement, la visite doit avoir lieu en présence du conducteur ou du propriétaire du véhicule. "
                      "À défaut, l’officier ou l’agent de police judiciaire doit requérir une personne ne relevant pas de son autorité administrative ; "
                      "la présence de cette personne extérieure n’est pas requise si la visite comporte des risques graves pour la sécurité des personnes et des biens ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "en cas de découverte d’une infraction, ou si le conducteur ou le propriétaire le demande, ou si la visite a eu lieu hors leur présence, "
                      "un procès-verbal mentionnant le lieu et les dates et heures de début et de fin des opérations doit être établi. "
                      "Un exemplaire est remis à l’intéressé, un autre transmis sans délai au procureur de la République.",
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.4.1.2 — L’inspection des bagages",
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
                      "Dans les mêmes conditions et pour les mêmes infractions, les officiers de police judiciaire, assistés le cas échéant des agents de police judiciaire et des agents de police judiciaire adjoints, "
                      "peuvent procéder à l’inspection visuelle ou à la fouille des bagages en tous lieux accessibles au public. "
                      "Les propriétaires de ces bagages ne peuvent être retenus que le temps strictement nécessaire aux opérations, qui doivent se dérouler en leur présence. "
                      "En cas de découverte d’une infraction ou si le propriétaire le demande, un procès-verbal précisant le lieu, les dates et heures de début et de fin des opérations est établi ; "
                      "un exemplaire est remis à l’intéressé et un autre transmis au procureur de la République.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La loi du vingt-huit avril deux mille vingt-cinq relative au renforcement de la sûreté dans les transports permet aux officiers de police judiciaire et aux agents de police judiciaire "
                      "de la police nationale et de la gendarmerie, territorialement compétents, de prendre eux-mêmes l’initiative de procéder à des inspections visuelles des bagages "
                      "et, avec le consentement du propriétaire, à leur fouille dans les gares et sur les lignes des réseaux ferroviaires et guidés. "
                      "Les mêmes dispositions s’appliquent aux services de transport public routier de personnes, y compris dans les aménagements où ces services déposent ou prennent en charge des passagers.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.4.1.3 — La visite des navires",
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
                      "La visite des navires effectuée sur le fondement de l’article 78-2-2 du Code de procédure pénale ne peut entraîner une immobilisation "
                      "que pour la durée strictement nécessaire aux opérations, sans pouvoir excéder douze heures. "
                      "La visite se déroule en présence du capitaine ou de son représentant et peut porter sur les extérieurs, les cales, les soutes et les locaux, "
                      "à l’exception de ceux aménagés à usage d’habitation, qui relèvent du régime des perquisitions domiciliaires.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              Text(
                "3.4.2 — En cas de crime ou de délit flagrant (article 78-2-3 du Code de procédure pénale)",
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
                      "Lorsqu’il existe, à l’égard du conducteur ou d’un passager d’un véhicule, une ou plusieurs raisons plausibles de soupçonner qu’il a commis, en tant qu’auteur ou complice, "
                      "un crime ou un délit flagrant, les officiers de police judiciaire, assistés le cas échéant des agents de police judiciaire et des agents de police judiciaire adjoints, "
                      "peuvent procéder à la visite des véhicules circulant ou arrêtés sur la voie publique ou dans des lieux accessibles au public. "
                      "Les modalités d’organisation sont similaires à celles prévues à l’article 78-2-2 du Code de procédure pénale, "
                      "mais ces opérations ne nécessitent pas, cette fois, de réquisitions écrites du procureur de la République.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                "3.4.3 — Autres hypothèses de fouille de véhicule",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "3.4.3.1 — La procédure de flagrant délit (articles 53 et suivants du Code de procédure pénale)",
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
                      "Au-delà de la simple constatation du délit flagrant au sens de l’article 78-2-3, l’officier de police judiciaire peut, dans le cadre des investigations de flagrance, "
                      "visiter un véhicule et exiger l’ouverture du coffre afin de rechercher des éléments de preuve, sur le fondement des articles 53 et suivants du Code de procédure pénale. "
                      "Il est fortement recommandé d’utiliser alors le formalisme applicable aux perquisitions (information de la personne, présence de témoins, procès-verbal détaillé).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.4.3.2 — Les actes accomplis en exécution d’une commission rogatoire",
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
                      "Dans le cadre d’une information judiciaire, le juge d’instruction peut, par commission rogatoire, autoriser les officiers de police judiciaire à fouiller des véhicules. "
                      "Ces opérations se déroulent alors selon les mêmes formes que pour une perquisition ordinaire, sous le contrôle du magistrat instructeur.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.4.3.3 — L’enquête préliminaire",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "En enquête préliminaire, la contrainte doit rester exceptionnelle. Ni l’officier de police judiciaire ni l’agent de police judiciaire ne peuvent procéder d’autorité à la fouille d’un véhicule. "
                      "Ils doivent obtenir l’assentiment du propriétaire ou du conducteur, cet accord étant consigné dans un procès-verbal. ",
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La jurisprudence assimile la fouille d’un véhicule à une perquisition dès lors qu’elle permet une intrusion dans l’intimité de la vie privée. "
                      "En l’absence de texte spécial l’autorisant, une telle fouille ne peut être réalisée, en enquête préliminaire, qu’avec le consentement recueilli dans les formes prévues par l’article 76 du Code de procédure pénale. "
                      "La méconnaissance de cette formalité entraîne la nullité de l’acte si la personne intéressée justifie d’un grief.",
                  style: TextStyle(color: referenceColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.4.3.4 — Pour prévenir une atteinte grave à la sécurité des personnes et des biens (article 78-2-4 du Code de procédure pénale)",
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
                      "Pour prévenir une atteinte grave à la sécurité des personnes et des biens, les officiers de police judiciaire, et, sur leur ordre et sous leur responsabilité, "
                      "les agents de police judiciaire et les agents de police judiciaire adjoints, peuvent procéder, dans les conditions fixées par l’article 78-2-4 du Code de procédure pénale, "
                      "non seulement aux contrôles d’identité prévus par l’article 78-2, mais également à la visite des véhicules et à l’inspection visuelle ou à la fouille des bagages. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Ces opérations sont en principe réalisées avec l’accord du conducteur ou du propriétaire du bagage. À défaut, elles peuvent être effectuées sur instructions du procureur de la République, "
                      "communiquées par tous moyens. Le véhicule peut être immobilisé pour une durée qui ne peut excéder trente minutes. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Pour la visite des véhicules : lorsque le véhicule est en circulation, la visite doit avoir lieu en présence du conducteur ; "
                      "lorsque le véhicule est à l’arrêt ou en stationnement, la visite doit se dérouler en présence du conducteur ou du propriétaire. "
                      "À défaut, l’officier ou l’agent de police judiciaire requiert la présence d’une personne ne relevant pas de son autorité administrative, "
                      "sauf si la visite comporte des risques graves pour la sécurité des personnes et des biens ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Pour l’inspection visuelle des bagages ou leur fouille : celles-ci se font en présence du propriétaire, qui ne peut être retenu que le temps strictement nécessaire aux opérations, "
                      "sans pouvoir excéder trente minutes.",
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "En cas de découverte d’une infraction, ou si le conducteur ou le propriétaire du véhicule ou du bagage le demande, ou encore si la visite a eu lieu hors la présence de ces personnes, "
                      "un procès-verbal doit être établi. Il mentionne le lieu, ainsi que les dates et heures de début et de fin des opérations. "
                      "Un exemplaire est remis à l’intéressé et un autre est transmis sans délai au procureur de la République.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                "3.4.3.5 — Pour rechercher les auteurs d’une participation à une manifestation en étant porteur d’une arme (article 78-2-5 du Code de procédure pénale)",
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
                      "Sur réquisitions écrites du procureur de la République, les officiers de police judiciaire, et, sous leur contrôle, les agents de police judiciaire et les agents de police judiciaire adjoints, "
                      "peuvent, sur les lieux d’une manifestation sur la voie publique et à ses abords immédiats, mettre en œuvre un dispositif spécifique afin de rechercher les personnes "
                      "ayant participé à cette manifestation en étant porteuses d’une arme. ",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Ils peuvent procéder à l’inspection visuelle des bagages des personnes et, avec leur consentement, à leur fouille, dans les conditions prévues pour les inspections et fouilles de l’article 78-2-2 ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "Ils peuvent visiter les véhicules circulant, arrêtés ou stationnant sur la voie publique ou dans des lieux accessibles au public, dans les mêmes conditions que celles prévues au même article 78-2-2.",
                ),
              ]),
              const SizedBox(height: 4),
              const _NotaBox(
                title: "Point important",
                bodySpans: [
                  TextSpan(
                    text:
                        "Dans le cadre de l’article 78-2-5 du Code de procédure pénale, les contrôles d’identité sont exclus du dispositif : "
                        "seules sont autorisées l’inspection ou la fouille des bagages et la visite des véhicules, dans les limites strictement définies par les réquisitions du procureur de la République.",
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // =====================================================
          // CONCLUSION GÉNÉRALE
          // =====================================================
          _HypoCard(
            title:
                "Conclusion — Vie privée et travail policier : un équilibre permanent",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le droit au respect de la vie privée irrigue une grande partie de l’activité des forces de l’ordre : contrôles d’identité, visites de véhicules, "
                      "perquisitions, exploitation d’images, interceptions de correspondances, recours à la vidéoprotection ou aux caméras individuelles. "
                      "Chaque acte de police doit pouvoir se rattacher à un texte précis, respecter les formes légales et demeurer strictement nécessaire et proportionné à l’objectif poursuivi. ",
                  style: TextStyle(color: textColor),
                ),
                const TextSpan(
                  text:
                      "En l’absence de base légale claire, la mesure est susceptible de constituer une atteinte illicite au droit au respect de la vie privée.",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Réflexe opérationnel pour l’agent",
                bodySpans: [
                  TextSpan(
                    text:
                        "Avant toute mesure susceptible d’affecter la vie privée (domicile, véhicule, bagages, correspondances, images, données numériques), "
                        "l’agent devrait systématiquement se poser trois questions :\n"
                        "1) Quel texte fonde concrètement mon action ?\n"
                        "2) Ai-je respecté l’ensemble des garanties procédurales (heures légales, autorisation, information, consentement, présence de témoins, procès-verbal) ?\n"
                        "3) La mesure est-elle réellement nécessaire et proportionnée au but poursuivi ?\n\n"
                        "Si l’une de ces réponses est incertaine, il est prudent de réévaluer la décision, d’en référer à la hiérarchie ou de solliciter l’avis du parquet.",
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
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
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
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

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
