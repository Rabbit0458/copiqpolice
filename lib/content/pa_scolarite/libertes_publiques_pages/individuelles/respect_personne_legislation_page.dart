import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaRespectPersonneLegislationPage extends StatelessWidget {
  const PaRespectPersonneLegislationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/individuelles/respect_personne_legislation';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF303F9F)
        : const Color(0xFF283593);
    final Color referenceColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1565C0);
    final Color dangerColor = isDark
        ? const Color(0xFFFF5252)
        : const Color(0xFFD32F2F);

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
          'Respect de la personne (législation)',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.5,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // =====================================================
          // EN-TÊTE / INTRO
          // =====================================================
          Text(
            "Le respect de la personne — Législation anti-discriminatoire",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  "Tout individu a droit au respect de sa personne. Il ne doit pas faire l’objet de discriminations liées à son origine, sa race, sa religion, son ethnie, sa nationalité, "
                  "son sexe, son handicap, son état de santé, sa situation de famille ou ses mœurs. "
                  "Les forces de sécurité doivent connaître l’arsenal législatif existant afin de prévenir, constater et réprimer les comportements discriminatoires.",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  "Toute une série de textes sanctionnent le non-respect de la personne :",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 4),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "le code de déontologie de la police nationale : les articles R. 434-14 et R. 434-16 du Code de la sécurité intérieure, relatifs à la relation avec la population, "
                  "à la protection et au respect des personnes privées de liberté ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi du 28 mai 1971 qui consacre l’adhésion de la France à la Convention internationale sur l’élimination de toutes les formes de discrimination raciale ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "le décret du 15 novembre 1982 qui complète la loi du 28 mai 1971 et permet à toute personne s’estimant victime d’une violation, par la France, d’un droit énoncé par cette convention, "
                  "de saisir le comité international après épuisement des voies de recours internes ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "le code pénal et le code du travail, qui sanctionnent diverses formes de discriminations ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi du 29 juillet 1881 sur la liberté de la presse, complétée par celle du 13 juillet 1990 renforçant la lutte contre le racisme et réprimant notamment le révisionnisme historique ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi du 16 novembre 2001 relative à la lutte contre les discriminations ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi du 3 février 2003 aggravant les peines sanctionnant les infractions à caractère raciste, antisémite ou xénophobe ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi n° 2008-496 du 27 mai 2008 portant diverses dispositions d’adaptation au droit communautaire dans le domaine de la lutte contre les discriminations ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi organique n° 2011-333 et la loi ordinaire n° 2011-334 du 29 mars 2011 portant création du Défenseur des droits ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi n° 2012-954 du 6 août 2012 relative au harcèlement sexuel, qui traite également des discriminations ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi n° 2014-873 du 4 août 2014 pour l’égalité réelle entre les femmes et les hommes ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi n° 2016-832 du 24 juin 2016 visant à lutter contre la discrimination à raison de la précarité sociale ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi n° 2017-86 du 27 janvier 2017 relative à l’égalité et à la citoyenneté ;",
            ),
          ]),
          const _BulletPoint.rich([
            TextSpan(
              text:
                  "la loi n° 2018-703 du 3 août 2018 renforçant la lutte contre les violences sexuelles et sexistes.",
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  "L’ensemble de ces textes constitue un arsenal législatif dense pour lutter contre les discriminations et le racisme. "
                  "Ils doivent guider les pratiques professionnelles des fonctionnaires de police, tant dans la relation au public que dans la gestion interne des services.",
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 10),
          _NotaBox(
            title: "Guides de référence",
            bodySpans: [
              TextSpan(
                text:
                    "En complément de ce cours, il est recommandé de se reporter aux guides dédiés « Lutte contre les discriminations et le harcèlement » et « Harcèlement scolaire », "
                    "qui approfondissent les aspects pratiques de prévention, de signalement et d’accompagnement des victimes.",
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 1 — CODE PENAL
          // =====================================================
          _HypoCard(
            title:
                "Chapitre 1 — Les discriminations sanctionnées par le code pénal",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le code pénal donne une définition précise de la discrimination et érige en délits certains faits discriminatoires, en distinguant selon que ces faits sont commis par un particulier "
                      "ou par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-1 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "constitue une discrimination toute distinction opérée entre les personnes physiques sur le fondement, notamment, de leur origine, de leur sexe, de leur situation de famille, de leur grossesse, "
                      "de leur apparence physique, de leur particulière vulnérabilité résultant de leur situation économique, de leur patronyme, de leur lieu de résidence, de leur état de santé, de leur perte d’autonomie, "
                      "de leur handicap, de leurs caractéristiques génétiques, de leurs mœurs, de leur orientation sexuelle, de leur identité de genre, de leur âge, de leurs opinions politiques, de leurs activités syndicales, "
                      "de leur qualité de lanceur d’alerte, de facilitateur ou de personne en lien avec un lanceur d’alerte, de leur capacité à s’exprimer dans une langue autre que le français, "
                      "ou encore de leur appartenance ou non-appartenance, vraie ou supposée, à une ethnie, une Nation, une prétendue race ou une religion déterminée.",
                ),
              ]),
              const SizedBox(height: 6),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Le même article étend cette définition aux personnes morales, lorsqu’une distinction est opérée en raison des mêmes critères, appréciés à travers leurs membres ou certains de leurs membres. ",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-1-1 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "constitue également une discrimination toute distinction opérée entre les personnes parce qu’elles ont subi ou refusé de subir des faits de harcèlement sexuel, "
                      "tels que définis à l’article 222-33 du Code pénal, ou parce qu’elles ont témoigné de tels faits.",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-1-2 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "constitue enfin une discrimination la distinction opérée entre des personnes parce qu’elles ont subi ou refusé de subir des faits de bizutage définis à l’article 225-16-1, ou témoigné de tels faits.",
                ),
              ]),
              const SizedBox(height: 14),

              // 1.1
              Text(
                "1.1 — Les discriminations commises par un fonctionnaire",
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
                      "La notion de fonctionnaire est entendue largement : elle vise toute personne dépositaire de l’autorité publique ou chargée d’une mission de service public, "
                      "agissant dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 432-7 du Code pénal : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
                const TextSpan(
                  text:
                      "la discrimination, telle que définie aux articles 225-1 et 225-1-1, commise à l’égard d’une personne physique ou morale par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, "
                      "dans l’exercice ou à l’occasion de l’exercice de ses fonctions ou de sa mission, est punie de cinq ans d’emprisonnement et de 75 000 € d’amende lorsqu’elle consiste :",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: "à refuser le bénéfice d’un droit accordé par la loi ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "à entraver l’exercice normal d’une activité économique quelconque.",
                ),
              ]),
              const SizedBox(height: 4),
              const _NotaBox(
                title: "Conséquence pratique",
                bodySpans: [
                  TextSpan(
                    text:
                        "Un refus de prise de plainte, un contrôle d’identité, un refus d’accès à un service public ou une différence de traitement fondés sur un critère prohibé "
                        "peuvent constituer une discrimination pénalement répréhensible lorsqu’ils sont commis par un fonctionnaire.",
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 1.2
              Text(
                "1.2 — Les discriminations commises par un particulier",
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
                      "L’article 225-2 du Code pénal ne vise pas l’ensemble des comportements inspirés par un motif discriminatoire, mais six situations principales. "
                      "La discrimination commise à l’égard d’une personne physique ou morale est notamment réprimée lorsqu’elle consiste :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: "à refuser la fourniture d’un bien ou d’un service ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "à entraver l’exercice normal d’une activité économique quelconque ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "à refuser d’embaucher, à sanctionner ou à licencier une personne ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "à subordonner la fourniture d’un bien ou d’un service à une condition fondée sur un critère prohibé ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "à subordonner une offre d’emploi, une demande de stage ou une période de formation en entreprise à un critère discriminatoire ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "à refuser d’accepter une personne dans un des stages visés par le 2° de l’article L. 412-8 du Code de la sécurité sociale.",
                ),
              ]),
              const SizedBox(height: 6),
              const _NotaBox(
                title: "Pour les policiers",
                bodySpans: [
                  TextSpan(
                    text:
                        "Ces infractions seront souvent révélées par les victimes ou par des associations. "
                        "Le rôle des enquêteurs consiste à caractériser précisément le critère prohibé, le comportement concret de discrimination et le lien de causalité entre les deux.",
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 1.3
              Text(
                "1.3 — Les autres infractions en lien avec la discrimination",
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
                      "D’autres incriminations complètent la lutte pénale contre le racisme, l’antisémitisme, la xénophobie et les discriminations :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "les crimes contre l’humanité (génocide, autres crimes contre l’humanité, participation à un groupement en vue de commettre ces crimes), imprescriptibles ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "le port ou l’exhibition d’uniformes, insignes ou emblèmes rappelant ceux des responsables de crimes contre l’humanité (article R. 645-1 du Code pénal) ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "l’interdiction de mémoriser des données à caractère personnel révélant les origines raciales ou ethniques, les opinions politiques, philosophiques ou religieuses, "
                      "l’appartenance syndicale ou l’orientation sexuelle, en dehors des cas prévus par la loi (article 226-19 du Code pénal).",
                ),
              ]),
              const SizedBox(height: 14),

              // 1.4
              Text(
                "1.4 — Les droits des associations",
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
                      "Les associations dont l’objet statutaire est de lutter contre les discriminations fondées sur le sexe, les mœurs, l’orientation sexuelle ou l’identité de genre, "
                      "l’origine nationale, ethnique, raciale ou religieuse, l’état de santé ou le handicap de la victime, l’exclusion sociale ou la situation de famille, "
                      "ainsi que celles agissant contre le harcèlement sexuel, peuvent se constituer partie civile pour de nombreuses infractions à caractère discriminatoire "
                      "(articles 2-1, 2-6, 2-8, 2-10 du Code de procédure pénale).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les associations de lutte contre le racisme peuvent en outre agir en cas de menaces, de vol ou d’extorsion commis pour des mobiles racistes, "
                      "ou en cas de non-respect des règles d’établissement et de conservation de fichiers sensibles (article 226-19 du Code pénal).",
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — LOI SUR LA PRESSE
          // =====================================================
          _HypoCard(
            title:
                "Chapitre 2 — Les discriminations sanctionnées par la loi sur la presse",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La loi du 29 juillet 1881 sur la liberté de la presse érige en délits certains comportements lorsque ceux-ci sont commis par voie de presse ou par tout moyen de communication au public. "
                      "Elle joue un rôle central dans la répression des propos racistes, antisémites, sexistes ou homophobes.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              Text(
                "2.1 — Les infractions commises par la voie de presse",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              // 2.1.1
              Text(
                "2.1.1 — La diffamation",
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
                      "La diffamation à raison de l’origine, de l’appartenance ou de la non-appartenance à une ethnie, une nation, une race ou une religion déterminée, "
                      "ou à raison du sexe, de l’orientation sexuelle, de l’identité de genre ou du handicap, est prévue à l’article 32 de la loi du 29 juillet 1881. "
                      "Elle est punie d’un an d’emprisonnement et de 45 000 € d’amende, ou de l’une de ces deux peines seulement.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              // 2.1.2
              Text(
                "2.1.2 — L’injure",
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
                      "Lorsque l’injure présente un caractère racial ou antisémite, sexiste ou homophobe, ou qu’elle est fondée sur une identité de genre ou un handicap, "
                      "elle est réprimée par l’article 33 de la loi du 29 juillet 1881. "
                      "La peine encourue est d’un an d’emprisonnement et de 45 000 € d’amende. "
                      "Lorsque les faits sont commis par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, les peines sont portées à trois ans d’emprisonnement et 75 000 € d’amende.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              // 2.1.3
              Text(
                "2.1.3 — Les provocations",
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
                      "Sont visées les provocations à la discrimination, à la haine ou à la violence à caractère racial, antisémite, sexiste ou homophobe. "
                      "Elles sont prévues à l’article 24 de la loi du 29 juillet 1881. Pour que l’infraction soit constituée, les propos doivent viser un groupe de personnes déterminé, "
                      "par exemple en raison de leur origine, de leur appartenance ou non-appartenance à une ethnie, une nation, une race ou une religion, "
                      "ou en raison de leur sexe, de leur orientation sexuelle, de leur identité de genre ou de leur handicap.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Ces provocations sont punies d’un an d’emprisonnement et de 45 000 € d’amende, ou de l’une de ces deux peines seulement. "
                      "Lorsque les faits sont commis par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, les peines sont portées à trois ans d’emprisonnement et 75 000 € d’amende.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              // 2.1.4
              Text(
                "2.1.4 — Les apologies et la négation de crimes",
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
                      "L’article 24, alinéa 5, de la loi du 29 juillet 1881 réprime l’apologie des crimes de guerre, des crimes contre l’humanité, des crimes de réduction en esclavage ou d’exploitation d’une personne réduite en esclavage, "
                      "ainsi que des crimes et délits de collaboration avec l’ennemi. Ce délit est puni de cinq ans d’emprisonnement et de 45 000 € d’amende.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’article 24 bis de la même loi réprime la négation de certains génocides, crimes contre l’humanité ou crimes de guerre, ayant donné lieu à une condamnation par une juridiction française ou internationale. "
                      "Cette infraction est punie d’un an d’emprisonnement et de 45 000 € d’amende, peines portées à trois ans et 75 000 € lorsque les faits sont commis par un dépositaire de l’autorité publique.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Toutes ces infractions prévues par la loi du 29 juillet 1881 doivent être commises par écrit (imprimés, dessins, affiches, tracts, etc.), par voie de discours ou de cris dans un lieu public ou une réunion publique, "
                      "ou par tout moyen de communication au public par voie électronique. "
                      "Le délai de prescription de l’action publique est, en principe, d’un an.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 2.2
              Text(
                "2.2 — Le droit des associations",
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
                      "Peuvent se constituer partie civile les associations dont l’objet est de lutter contre les discriminations, dans les conditions prévues aux articles 2-1, 2-4, 2-5, 2-6, 2-8 et 2-11 du Code de procédure pénale. "
                      "Elles jouent un rôle essentiel dans la mise en mouvement des poursuites et dans l’accompagnement des victimes.",
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — DROIT DU TRAVAIL
          // =====================================================
          _HypoCard(
            title:
                "Chapitre 3 — Les discriminations sanctionnées par le droit du travail",
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "En droit du travail, de nombreux textes interdisent les discriminations liées au sexe, à la race, à la situation de famille, aux opinions politiques ou syndicales, "
                      "aux convictions religieuses, à l’âge, au handicap, à l’orientation sexuelle ou à l’identité de genre, etc. "
                      "Ils protègent à la fois l’accès à l’emploi, le déroulement de carrière et les conditions de travail.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.1
              Text(
                "3.1 — Le non-respect de l’égalité professionnelle",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "3.1.1 — La loi du 7 mai 1982 et la circulaire du 24 janvier 1983",
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
                      "Ces textes posent les principes d’égalité d’accès aux emplois publics, d’égalité entre les hommes et les femmes, de mixité dans la fonction publique et d’égalité de rémunération. "
                      "Ils seront ensuite repris par la loi du 13 juillet 1983 portant « droits et obligations des fonctionnaires ». "
                      "La France a, par ailleurs, été condamnée pour « ségrégation » par la Cour de justice des Communautés européennes pour avoir instauré des quotas de recrutement féminins dans la police nationale.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.2 — La loi du 11 juillet 1983",
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
                      "Cette loi ratifie la Convention internationale sur l’élimination de toutes les formes de discrimination à l’égard des femmes.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.3 — La loi du 13 juillet 1983 dite « loi Roudy »",
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
                      "Elle institue l’égalité professionnelle entre les femmes et les hommes et crée un Conseil supérieur de l’égalité professionnelle. "
                      "Elle permet notamment aux organisations syndicales d’intenter une action en justice sans mandat exprès de la victime, après l’en avoir informée et sauf opposition de sa part. "
                      "En cas de litige, la charge de la preuve en matière de discrimination incombe à l’employeur, qui doit apporter des éléments objectifs étrangers à toute discrimination.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.4 — La loi du 9 mai 2001",
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
                      "La loi n° 2001-397 du 9 mai 2001, relative à l’égalité professionnelle entre les femmes et les hommes, modifie le Code du travail en matière de travail de nuit, "
                      "de négociation collective, d’élections professionnelles et d’aides publiques favorisant l’égalité entre les sexes au travail.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.5 — La loi du 16 novembre 2001",
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
                      "La loi n° 2001-1066 du 16 novembre 2001 renforce la lutte contre les discriminations pour les salariés du privé comme pour les agents publics. Elle :",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "augmente le nombre de critères de discrimination prohibés ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "introduit la notion de discrimination indirecte, lorsque des dispositions apparemment neutres entraînent en pratique un désavantage particulier pour un groupe déterminé ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "étend la protection à l’ensemble de la carrière professionnelle ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: "inverse la charge de la preuve devant le juge civil ;",
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      "renforce le rôle des syndicats et des associations en matière de lutte contre les discriminations.",
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.6 — La loi du 31 mars 2006",
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
                      "La loi n° 2006-396 pour l’égalité des chances vise notamment les discriminations d’accès à l’emploi fondées sur l’âge ou l’origine. "
                      "Elle renforce les pouvoirs de la Haute Autorité de lutte contre les discriminations et pour l’égalité et légalise la pratique des tests de discrimination.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.7 — La loi du 27 mai 2008",
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
                      "La loi n° 2008-496 du 27 mai 2008 transpose plusieurs directives européennes relatives à l’égalité de traitement. "
                      "Elle définit la discrimination directe et indirecte, clarifie les règles de preuve, renforce la protection des victimes et introduit la notion de motifs légitimes "
                      "permettant, dans certains cas strictement encadrés, de justifier une différence de traitement.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.8 — Les lois du 29 mars 2011",
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
                      "Les lois organique n° 2011-333 et ordinaire n° 2011-334 du 29 mars 2011 créent le Défenseur des droits, qui succède notamment à la Haute Autorité de lutte contre les discriminations et pour l’égalité (HALDE).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.1.9 — La loi du 4 août 2014",
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
                      "La loi n° 2014-873 pour l’égalité réelle entre les femmes et les hommes introduit de nombreuses mesures destinées à favoriser l’égalité professionnelle, "
                      "la conciliation vie privée / vie professionnelle et la lutte contre les violences faites aux femmes.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.2
              Text(
                "3.2 — Les comportements discriminatoires interdits",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "3.2.1 — L’article L. 1132-1 du Code du travail",
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
                      "Cet article pose un principe général : aucune personne ne peut être écartée d’une procédure de recrutement, d’une période de formation, ni être sanctionnée, licenciée ou faire l’objet d’une mesure discriminatoire "
                      "en raison d’un critère prohibé (origine, sexe, mœurs, orientation sexuelle, identité de genre, âge, situation de famille, grossesse, handicap, opinions politiques, religion, appartenance syndicale, "
                      "état de santé, lieu de résidence, qualité de lanceur d’alerte, etc.).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.2.2 — L’article L. 1132-2 du Code du travail",
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
                      "Aucun salarié ne peut être sanctionné, licencié ou faire l’objet d’une mesure discriminatoire en raison de l’exercice normal du droit de grève.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.2.3 — L’article L. 1132-3 du Code du travail",
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
                      "Il protège les salariés qui ont témoigné de faits discriminatoires ou les ont relatés : aucune sanction ne peut être fondée sur ce motif.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.2.4 — L’article L. 1132-3-1 du Code du travail",
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
                      "Il interdit toute discrimination à l’encontre d’un salarié qui exerce les fonctions de juré ou de citoyen assesseur.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.2.5 — L’article L. 1132-3-3 du Code du travail",
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
                      "Il consacre une protection générale des lanceurs d’alerte : aucune mesure défavorable ne peut être prise contre une personne qui, de bonne foi, témoigne de faits constitutifs d’une infraction pénale.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.2.6 — L’article L. 1142-1 du Code du travail",
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
                      "Il prohibe les discriminations fondées sur le sexe ou la grossesse, notamment en matière de recrutement, de formation, de rémunération, d’affectation, de promotion ou de rupture du contrat de travail. "
                      "Les différences de traitement ne sont admises que lorsqu’elles répondent à une exigence professionnelle essentielle et déterminante, ou lorsqu’elles sont expressément prévues par la loi. "
                      "L’action civile en réparation du préjudice résultant d’une discrimination se prescrit par cinq ans à compter de sa révélation.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.3
              Text(
                "3.3 — Le harcèlement",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "3.3.1 — Le harcèlement sexuel",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: dangerColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’article 222-33 du Code pénal définit le harcèlement sexuel comme le fait d’imposer à une personne, de façon répétée, des propos ou comportements à connotation sexuelle ou sexiste "
                      "portant atteinte à sa dignité ou créant une situation intimidante, hostile ou offensante. "
                      "Il assimile à ce délit le fait, même non répété, d’user de toute forme de pression grave afin d’obtenir un acte de nature sexuelle.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le Code du travail (article L. 1153-1) transpose cette définition et interdit le harcèlement sexuel au travail. "
                      "Les salariés victimes ou témoins sont protégés contre toute mesure de rétorsion. Les discriminations consécutives à un harcèlement sexuel sont pénalement sanctionnées (article L. 1155-2 du Code du travail).",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.3.2 — Le harcèlement moral",
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: dangerColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "L’article 222-33-2 du Code pénal réprime le fait de harceler autrui par des propos ou comportements répétés ayant pour objet ou pour effet une dégradation des conditions de travail "
                      "susceptible de porter atteinte à ses droits ou à sa dignité, d’altérer sa santé physique ou mentale ou de compromettre son avenir professionnel. "
                      "La peine encourue est de deux ans d’emprisonnement et 30 000 € d’amende.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Le Code du travail organise en parallèle une protection spécifique des salariés contre le harcèlement moral (articles L. 1152-1 et suivants) : "
                      "procédure de médiation, actions des syndicats, nullité des sanctions disciplinaires fondées sur des faits de harcèlement, interdiction de toute mesure de représailles.",
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 8),

              Text(
                "3.3.3 — La législation applicable à la fonction publique",
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
                      "Aucun agent public ne doit subir des faits de harcèlement sexuel ou moral (articles L. 133-1 et L. 133-2 du Code général de la fonction publique). "
                      "Les mêmes définitions que dans le Code du travail s’appliquent, et aucune mesure défavorable ne peut être prise en raison de la dénonciation ou du refus de subir de tels faits. "
                      "Tout agent ayant commis ou ordonné ces agissements s’expose à des sanctions disciplinaires en plus des poursuites pénales éventuelles.",
                  style: TextStyle(color: textColor),
                ),
              ]),
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
  const _ExempleBox({required this.bodySpans});

  final String title = 'NOTA';
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
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

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
