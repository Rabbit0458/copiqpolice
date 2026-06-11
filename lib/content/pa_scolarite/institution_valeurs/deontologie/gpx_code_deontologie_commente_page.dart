import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCodeDeontologieCodeCommentePage extends StatelessWidget {
  const PaCodeDeontologieCodeCommentePage({super.key});

  static const String routeName = '/pa/institution/deontologie/code_commente';

  static const Color _lawRed = Color(0xFFE53935);

  // ✅ helper propre (sans copyWith)
  TextSpan _lawSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );
  }

  TextSpan _normalSpan(String text) {
    return TextSpan(text: text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardTitle = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardArticle = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardComment = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

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
          "Déontologie",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            "Code de déontologie de la police nationale et de la gendarmerie nationale",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Présentation — Code commenté",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Dans un contexte d'accroissement des difficultés d'exercice des missions de sécurité intérieure, "
                "du fait d'un environnement qui se complexifie, ce code permet de rassembler dans un document "
                "synthétique les règles déontologiques observées par les membres des forces de l'ordre. "
                "Il réaffirme ainsi les notions essentielles qui président aux actions des militaires de la gendarmerie "
                "et des policiers. Il attache une importance particulière aux relations entre les forces de sécurité "
                "et la population. De la même manière, ce code tient compte des évolutions positives pour la protection "
                "juridique des membres des forces de sécurité intérieure.\n\n"
                "Véritable projet commun tenant compte de la spécificité de chacune des deux forces, ce code de déontologie "
                "s'inscrit en cohérence avec les textes existants. Le respect des valeurs qu'il prône conditionne la légitimité "
                "des actions des policiers et des militaires de la gendarmerie nationale tout en en renforçant l'efficacité.\n\n"
                "Le code de déontologie de la police et de la gendarmerie nationales figure au chapitre 4 du titre 3 du livre 4 "
                "du code de la sécurité intérieure.\n"
                "Mis à jour le 13/03/2025.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: "Lecture pédagogique : texte + commentaire + exemples.",
              ),
              _IntroBullet(
                text:
                    "Les références d’articles (CSI, CPP, CP, etc.) sont mises en rouge.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =========================
          // TITRE PRÉLIMINAIRE
          // =========================
          _ConditionCard(
            title: "TITRE PRÉLIMINAIRE",
            cardColor: cardTitle,
            accent: accentBlue,
            titleColor: textMain,
            children: const [_Paragraph("Articles R. 434-2 à R. 434-3")],
          ),
          const SizedBox(height: 14),

          // R. 434-2
          _ConditionCard(
            title: "Article R. 434-2 — Cadre général de l'action",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-2"),
                _normalSpan(
                  " — Cadre général de l'action de la police nationale et de la gendarmerie nationale\n\n",
                ),
                _normalSpan(
                  "Placées sous l'autorité du ministre de l'intérieur pour l'accomplissement des missions de sécurité intérieure "
                  "et agissant dans le respect des règles du code de procédure pénale en matière judiciaire, la police nationale "
                  "et la gendarmerie nationale ont pour mission d'assurer la défense des institutions et des intérêts nationaux, "
                  "le respect des lois, le maintien de la paix et de l'ordre publics, la protection des personnes et des biens.\n\n"
                  "Au service des institutions républicaines et de la population, policiers et gendarmes exercent leurs fonctions "
                  "avec loyauté, sens de l'honneur et dévouement.\n\n"
                  "Dans l'accomplissement de leurs missions de sécurité intérieure, la police nationale, force à statut civil, "
                  "et la gendarmerie nationale, force armée, sont soumises à des règles déontologiques communes et à des règles "
                  "propres à chacune d'elles. Ces dernières sont précisées au titre III du présent décret.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-2",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les missions de sécurité intérieure, accomplies sous l'autorité du ministère de l'intérieur, relèvent notamment "
                "de la compétence de la police et de la gendarmerie nationales.\n\n"
                "Elles constituent la composante missionnelle principale de la gendarmerie nationale, qui en qualité de force armée, "
                "exerce par ailleurs des missions de défense sur le territoire national ou sur les théâtres d'opérations extérieures "
                "pour lesquelles s'appliquent également des règles déontologiques tirées du code de la défense et du droit des conflits armés.\n\n"
                "Les prérogatives de puissance publique attachées à l'exécution de ces missions de sécurité intérieure emportent des "
                "incidences importantes sur les libertés individuelles. L'équilibre démocratique exige des agents de se conformer "
                "strictement aux règles déontologiques propres à garantir le respect des droits de l'homme.\n\n"
                "Aussi, le principe d'une exigence déontologique, qui s'ajoute à celle de la conformité à la loi, est posé. "
                "L'exercice professionnel est en conséquence non seulement soumis au strict respect des règles de droit mais également "
                "empreint de certaines valeurs éthiques.\n\n"
                "Le dernier alinéa renvoie aux dispositions propres à chacune des forces, respectant ainsi leur identité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-3
          _ConditionCard(
            title: "Article R. 434-3 — Nature du code et champ d'application",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-3"),
                _normalSpan(
                  " — Nature du code de déontologie et champ d'application\n\n",
                ),
                _normalSpan(
                  "I. - Les règles déontologiques énoncées par le présent code procèdent de la Constitution, des traités internationaux, "
                  "notamment de la convention européenne de sauvegarde des droits de l'homme et des libertés fondamentales, "
                  "des principes généraux du droit, et des lois et règlements de la République.\n\n"
                  "Elles définissent les devoirs qui incombent aux policiers et aux gendarmes dans l'exercice de leurs missions de sécurité intérieure "
                  "pendant ou en dehors du service et s'appliquent sans préjudice des règles statutaires et autres obligations auxquelles ils sont respectivement soumis. "
                  "Elles font l'objet d'une formation, initiale et continue, dispensée aux policiers et aux gendarmes pour leur permettre d'exercer leurs fonctions "
                  "de manière irréprochable.\n\n"
                  "II. - Pour l'application du présent code, le terme « policier » désigne tous les personnels actifs de la police nationale, "
                  "ainsi que les personnels exerçant dans un service de la police nationale ou dans un établissement public concourant à ses missions "
                  "et le terme « gendarme » désigne les officiers et sous-officiers de la gendarmerie, ainsi que les gendarmes adjoints volontaires.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-3",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le présent code est une synthèse des règles déontologiques édictées dans l'ensemble du corpus législatif et réglementaire. "
                "Il est également créateur de règles auxquelles sont soumis policiers et gendarmes dans l'accomplissement de leurs missions de sécurité intérieure.\n\n"
                "Si les dispositions de ce texte entraînent des devoirs pour ces derniers et pour leur hiérarchie, elles constituent également une réelle protection "
                "quant à l'exécution et aux conditions d'exécution des missions.\n\n"
                "Le terme « policier » recouvre tous les policiers actifs, indépendamment de leur affectation, et l'ensemble des agents, quel que soit leur statut, "
                "affectés dans un service ou un établissement public (ex: Ecole nationale supérieure de la police, Institut national de la police scientifique). "
                "Aussi le code s'adresse-t-il largement à tous ceux qui concourent aux missions de la police nationale et pour ce qui les concerne. Ainsi par exemple "
                "les dispositions relatives à l'usage de la force ne concernent-elles que les policiers actifs.\n\n"
                "S'agissant du terme « gendarme », il comprend : les officiers, les sous-officiers de la gendarmerie et du corps de soutien (y compris sous contrat ou commissionnés), "
                "les gendarmes adjoints volontaires et les réservistes, à l'occasion de l'accomplissement de leurs périodes au sein de la réserve opérationnelle.",
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================
          // TITRE PREMIER - PRINCIPES GÉNÉRAUX
          // =========================
          _ConditionCard(
            title: "TITRE PREMIER — PRINCIPES GÉNÉRAUX",
            cardColor: cardTitle,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph("CHAPITRE IER — AUTORITÉ ET PROTECTION"),
            ],
          ),
          const SizedBox(height: 14),

          // R. 434-4
          _ConditionCard(
            title: "Article R. 434-4 — Principe hiérarchique",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-4"),
                _normalSpan(" — Principe hiérarchique\n\n"),
                _normalSpan(
                  "I. - L'autorité investie du pouvoir hiérarchique prend des décisions, donne des ordres et les fait appliquer. "
                  "Elle veille à ce que ses instructions soient précises et apporte à ceux qui sont chargés de les exécuter toutes informations pertinentes nécessaires "
                  "à leur compréhension. L'autorité hiérarchique assume la responsabilité des ordres donnés.\n\n"
                  "Ordres et instructions parviennent à leurs destinataires par la voie hiérarchique. Si l'urgence impose une transmission directe, "
                  "la hiérarchie intermédiaire en est informée sans délai.\n\n"
                  "II.- Le policier ou le gendarme porte sans délai à la connaissance de l'autorité hiérarchique tout fait survenu à l'occasion ou en dehors du service, "
                  "ayant entraîné ou susceptible d'entraîner sa convocation par une autorité de police, juridictionnelle, ou de contrôle.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-4",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier et le militaire de la gendarmerie inscrivent leur action au sein de structures hiérarchisées dont le fonctionnement implique des liens de subordination.\n\n"
                "Les chaînes hiérarchiques doivent être parfaitement identifiées afin d'établir les responsabilités de chaque échelon. Cette organisation induit la formulation "
                "d'ordres clairs par les supérieurs hiérarchiques qui donnent à leurs subordonnés toute précision nécessaire pour leur bonne exécution. Les donneurs d'ordres "
                "sont pleinement responsables en vertu de l'autorité dont ils sont investis. Ils doivent contrôler l'application des ordres qu'ils sont amenés à donner.\n\n"
                "Quant à l'obligation de rendre compte, elle pèse sur l'ensemble des agents et renvoie à la structure hiérarchisée et au bon fonctionnement des deux institutions. "
                "Sur un autre plan, le compte rendu, partie intégrante de la mission, constitue une réponse aux explications éventuellement sollicitées par la hiérarchie. "
                "Il convient alors de rappeler que le « droit au silence », prévalant dans le domaine judiciaire, ne peut être opposé dans le cadre d'une relation hiérarchique. "
                "L'invoquer indûment placerait l'agent en situation de faute (refus de rendre compte). L'autorité hiérarchique est également celle qui décide des modalités "
                "d'établissement du compte rendu. A ce titre, elle peut exiger des compléments d'informations (par la rédaction d'un autre compte rendu) si elle estime le premier "
                "compte rendu incomplet ou insuffisant.\n\n"
                "Exemples de comportements proscrits:\n"
                "• défaut de compte-rendu de l'exécution ou de l'inexécution des missions ou d'une instruction; d'un incident survenu à l'occasion de l'exercice des missions.\n"
                "• défaut de compte-rendu d'un événement de la vie privée de nature à exposer l'agent à des poursuites pénales ou disciplinaires;\n"
                "• défaut de compte-rendu d'une condamnation judiciaire (retrait du permis de conduire ...) ou des obligations d'un contrôle judiciaire "
                "(interdiction d'exercer, retrait du port d'arme ...).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-5
          _ConditionCard(
            title: "Article R. 434-5 — Obéissance",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-5"),
                _normalSpan(" — Obéissance\n\n"),
                _normalSpan(
                  "I. - Le policier ou le gendarme exécute loyalement et fidèlement les instructions et obéit de même aux ordres qu'il reçoit de l'autorité investie "
                  "du pouvoir hiérarchique, sauf dans le cas où l'ordre donné est manifestement illégal et de nature à compromettre gravement un intérêt public.\n\n"
                  "S'il pense être confronté à un tel ordre, il fait part de ses objections à l'autorité qui le lui a donné, ou, à défaut, à la première autorité qu'il a "
                  "la possibilité de joindre, en mentionnant expressément le caractère d'illégalité manifeste qu'il lui attribue. Si, malgré ses objections, l'ordre est maintenu, "
                  "il peut en demander la confirmation écrite lorsque les circonstances le permettent. Il a droit à ce qu'il soit pris acte de son opposition. "
                  "Même si le policier ou gendarme reçoit la confirmation écrite demandée et s'il exécute l'ordre, l'ordre écrit ne l'exonère pas de sa responsabilité.\n\n"
                  "L'invocation à tort d'un motif d'illégalité manifeste pour ne pas exécuter un ordre régulièrement donné expose le subordonné à ce que sa responsabilité soit engagée.\n\n"
                  "Dans l'exécution d'un ordre, la responsabilité du subordonné n'exonère pas l'auteur de l'ordre de sa propre responsabilité.\n\n"
                  "II. - Le policier ou le gendarme rend compte à l'autorité investie du pouvoir hiérarchique de l'exécution des ordres reçus ou, le cas échéant, des raisons de leur inexécution. "
                  "Dans les actes qu'il rédige, les faits ou événements sont relatés avec fidélité et précision.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-5",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Condition indispensable au bon fonctionnement des deux institutions, le principe d'obéissance exige discipline et loyauté. En dehors du cas des ordres "
                "manifestement illégaux, les policiers et gendarmes doivent exécuter les missions qui leurs sont confiées avec le professionnalisme que l'on attend d'eux.\n\n"
                "L'obligation de loyauté\n"
                "Le service des institutions républicaines exige que le policier et le militaire fassent preuve de loyauté tant à l'égard de leur hiérarchie et de leur autorité d'emploi, "
                "que vis à vis des usagers. Aussi, le policier/gendarme peut se rendre fautif lorsqu'il ment délibérément et ce, quelle que soit la conséquence de ce mensonge. "
                "C'est également le cas s'il tronque un compte rendu. Mais manque également au devoir de loyauté le policier/gendarme qui ne respecte pas, méconnaît sciemment "
                "ou compromet, par son comportement, les intérêts de l'usager.\n\n"
                "• Le devoir d'obéissance\n"
                "Personnellement responsable de leurs actes, le policier et le gendarme ont le devoir de s'abstenir d'exécuter les ordres manifestement illégaux et de nature "
                "à compromettre gravement un intérêt public en faisant connaître au donneur d'ordre ou à défaut, à l'échelon hiérarchique supérieur, voire à l'autorité supérieure "
                "immédiatement joignable, les raisons de leur refus d'obéissance. En cas de difficulté, ils ont maintenant la possibilité de solliciter un écrit confirmant l'ordre donné. "
                "Cet écrit ne leur permet cependant pas de transgresser la légalité. Par ailleurs, il ne les exonère pas de leur responsabilité, en cas d'exécution d'un ordre manifestement illégal.\n\n"
                "Un ordre est manifestement illégal dès lors que la légalité de l'acte prescrit ne peut être objectivement soutenue. L'illégalité doit donc revêtir un caractère évident. "
                "Par ailleurs, les conséquences de l'exécution de l'ordre doivent être d'une gravité suffisante. A la condition du caractère manifeste de l'illégalité de l'ordre donné "
                "s'ajoute ainsi celle de la gravité des conséquences de l'ordre exécuté (Conseil d'Etat, arrêt Langneur, 10 novembre 1944 et article 28 de la loi du 13 juillet 1983 portant "
                "droits et obligations des fonctionnaires),",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Toutefois, les policiers et les gendarmes ne doivent en aucune circonstance exécuter un ordre manifestement illégal, conformément aux dispositions du code pénal (",
                ),
                _lawSpan("article 122-4"),
                const TextSpan(text: ") et du code de la défense ("),
                _lawSpan("article D. 4122-3"),
                const TextSpan(text: ").\n\n"),
                const TextSpan(
                  text:
                      "Le policier et le gendarme ne peuvent refuser d'exécuter un ordre au prétexte qu'il serait uniquement contraire à leurs convictions personnelles.\n\n",
                ),
                const TextSpan(
                  text:
                      "Le policier et le gendarme doivent rendre compte loyalement et avec rigueur de l'exécution des missions ou des ordres reçus et, a fortiori, à travers la rédaction des procédures judiciaires.\n\n",
                ),
                const TextSpan(text: "Exemples de comportements fautifs :\n"),
                const TextSpan(
                  text:
                      "• mensonge à sa hiérarchie sur l'exécution ou l'inexécution d'une mission;\n",
                ),
                const TextSpan(
                  text:
                      "• compte rendu non fidèle ou volontairement erroné des faits ou événements relatés par procès-verbal ou rapport;\n",
                ),
                const TextSpan(
                  text:
                      "• conservation au service et non restitution des effets ou papiers d'une personne sans raison juridique, même sans se les être appropriés;\n",
                ),
                const TextSpan(
                  text:
                      "• extinction volontaire de la vidéo surveillance dans les lieux de privation de liberté,\n",
                ),
                const TextSpan(
                  text:
                      "• refus d'établir des actes ou des procès-verbaux sollicités par la hiérarchie ;\n",
                ),
                const TextSpan(
                  text:
                      "• refus d'exécution de l'ordre de son chef de service de venir rendre compte de son attitude;\n",
                ),
                const TextSpan(
                  text:
                      "• soustraction, sans raison légitime, à une obligation de formation;\n",
                ),
                const TextSpan(
                  text:
                      "• non-respect des prescriptions particulières tant du code de déontologie que des instructions particulières du ministre de l'intérieur et/ou du DGGN-DGPN.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-6
          _ConditionCard(
            title: "Article R. 434-6 — Obligations de l'autorité hiérarchique",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-6"),
                _normalSpan(
                  " — Obligations incombant à l'autorité hiérarchique\n\n",
                ),
                _normalSpan(
                  "I.- Le supérieur hiérarchique veille en permanence à la préservation de l'intégrité physique de ses subordonnés. "
                  "Il veille aussi à leur santé physique et mentale. Il s'assure de la bonne condition de ses subordonnés.\n\n"
                  "II.- L'autorité investie du pouvoir hiérarchique conçoit et met en œuvre au profit des personnels une formation adaptée, "
                  "en particulier dans les domaines touchant au respect de l'intégrité physique et de la dignité des personnes ainsi qu'aux libertés publiques. "
                  "Cette formation est régulièrement mise à jour pour tenir compte des évolutions affectant l'exercice des missions de police administrative et judiciaire.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-6",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L'autorité hiérarchique a un rôle de protection vis à vis de ses subordonnés. Elle doit ainsi veiller à préserver l'équilibre tant physique que psychologique "
                "de ses personnels et faire de son mieux afin de garantir des conditions matérielles de travail satisfaisantes.\n\n"
                "Compte tenu de la complexité des missions exercées par les policiers et les gendarmes, l'autorité hiérarchique doit mettre en œuvre une formation constamment actualisée, "
                "en visant prioritairement la nécessité de préserver les garanties et le respect des libertés individuelles.\n\n"
                "Pour ce qui est des actes de formation, ils constituent des activités de service à part entière et s'imposent aux personnels qui ont été désignés pour les suivre "
                "(y contrevenir relèverait du refus d'obéissance).\n\n"
                "Enfin, le supérieur hiérarchique veille à ne pas confier des missions incompatibles avec le niveau de formation de ses subordonnés.\n\n"
                "Exemple de comportements qui doivent être proscrits:\n"
                "• défaut de vigilance quant aux difficultés d'ordre professionnel et/ou privé présentées par les policiers/gendarmes",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-7
          _ConditionCard(
            title: "Article R. 434-7 — Protection fonctionnelle",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-7"),
                _normalSpan(" — Protection fonctionnelle\n\n"),
                _normalSpan(
                  "L'État défend le policier ou le gendarme, ainsi que, dans les conditions et limites fixées par la loi, ses proches, "
                  "contre les attaques, menaces, violences, voies de fait, injures, diffamations et outrages dont il peut être victime dans l'exercice ou du fait de ses fonctions.\n\n"
                  "L'État accorde au policier ou au gendarme sa protection juridique en cas de poursuites judiciaires liées à des faits qui n'ont pas le caractère d'une faute personnelle. "
                  "Il l'assiste et l'accompagne dans les démarches relatives à sa défense.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-7",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L'État reconnaît et assume les conséquences des risques quotidiens encourus par les policiers et gendarmes à l'occasion de l'exécution des missions de sécurité intérieure et en leur qualité. "
                "A ce titre, il leur accorde, ainsi qu'à leurs proches, une protection fonctionnelle élargie.\n\n"
                "Exemples de comportements qui doivent être proscrits:\n"
                "• défaut de vigilance quant aux difficultés d'ordre professionnel et/ou privé présentées par les policiers/gendarmes;\n"
                "• refus de transmission d'une demande de protection fonctionnelle.\n\n"
                "Exemples de comportements positifs :\n"
                "• tout nouvel arrivant qui se présente dans son unité doit être reçu par sa hiérarchie. Cette dernière, sans pour autant s'immiscer dans sa vie privée, doit connaître ses éventuelles difficultés personnelles afin de pouvoir les prendre en compte dans l'exercice du commandement.\n\n"
                "Le chef doit non seulement prendre l'ensemble des mesures afin que son subordonné puisse bénéficier de la protection de l'Etat (protection fonctionnelle), "
                "mais également le soutenir par sa présence lorsque les circonstances l'exigent (accompagnement aux audiences quand le policier ou le gendarme est victime d'infractions ou auteur, en l'absence de faute personnelle).",
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================
          // CHAPITRE II — DEVOIRS
          // =========================
          _ConditionCard(
            title: "CHAPITRE II — DEVOIRS DU POLICIER ET DU GENDARME",
            cardColor: cardTitle,
            accent: accentBlue,
            titleColor: textMain,
            children: const [_Paragraph("Articles R. 434-8 à R. 434-13")],
          ),
          const SizedBox(height: 14),

          // R. 434-8
          _ConditionCard(
            title: "Article R. 434-8 — Secret et discrétion professionnels",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-8"),
                _normalSpan(" — Secret et discrétion professionnels\n\n"),
                _normalSpan(
                  "Soumis aux obligations du secret professionnel et au devoir de discrétion, le policier ou le gendarme s'abstient de divulguer à quiconque n'a ni le droit, ni le besoin d'en connaître, "
                  "sous quelque forme que ce soit, les informations dont il a connaissance dans l'exercice ou au titre de ses fonctions.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-8",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le secret est fondé sur le droit et le besoin d'en connaître. Les obligations liées au secret et à la discrétion professionnels sont plus exigeantes que celles résultant de la loi pénale "
                "(secret de l'enquête et de l'instruction, secret professionnel, secret de la défense nationale).\n\n"
                "La divulgation d'information peut porter atteinte au respect de la vie privée et nuire à la bonne marche de l'administration et/ou des enquêtes en cours.\n\n"
                "Il est donc interdit au policier ou au gendarme de communiquer aux personnes non autorisées ou non habilitées, y compris au sein même des institutions, toute information ou renseignement "
                "dont il a connaissance dans le cadre de ses fonctions.\n\n"
                "Selon les fonctions occupées, le champ de cette obligation peut être plus ou moins étendu.\n\n"
                "Exemples de comportements fautifs :\n"
                "• divulgation, même par maladresse, d'une information confidentielle sur une opération de police judiciaire ou administrative à venir;\n"
                "• livraison d'informations couvertes par le secret de l'enquête et de l'instruction à un tiers non autorisé;\n"
                "• divulgation, par voie de presse, par publication d'un écrit ou sur les réseaux sociaux des informations confidentielles/couvertes par le secret de l'enquête et de l'instruction;\n"
                "• ouverture d'une enquête administrative sur le fondement d'actes judiciaires alors que leur communication n'a pas été autorisée par le procureur de la République.\n"
                "• divulgation, ne serait-ce qu'à des proches et ce, y compris à titre anecdotique, d'éléments se rapportant à une personnalité locale recueillis dans le cadre d'une affaire pénale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-9
          _ConditionCard(
            title: "Article R. 434-9 — Probité",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-9"),
                _normalSpan(" — Probité\n\n"),
                _normalSpan(
                  "Le policier ou le gendarme exerce ses fonctions avec probité.\n"
                  "Il ne se prévaut pas de sa qualité pour en tirer un avantage personnel et n'utilise pas à des fins étrangères à sa mission les informations dont il a connaissance dans le cadre de ses fonctions.\n"
                  "Il n'accepte aucun avantage ni aucun présent directement ou indirectement lié à ses fonctions ou qu'il se verrait proposer au motif, réel ou supposé, d'une décision prise ou dans l'espoir d'une décision à prendre.\n"
                  "Il n'accorde aucun avantage pour des raisons d'ordre privé.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-9",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les policiers ou les gendarmes agissent avec désintéressement. Leurs intérêts privés ne doivent pas interférer avec leurs obligations professionnelles. "
                "A cette fin, ils évitent, ou le cas échéant, ils signalent toute situation pouvant les mettre dans une position de conflit d'intérêt.\n\n"
                "La probité s'oppose à toute forme de corruption, de vénalité, de favoritisme et de népotisme.\n\n"
                "Cette obligation est particulièrement étendue et recouvre l'ensemble des comportements fautifs d'un agent qui a tiré ou tenté de tirer un avantage matériel de sa fonction, "
                "à l'occasion de sa fonction ou en lien avec sa fonction (prévarication).\n\n"
                "L'exigence posée par ce principe s'étend bien au-delà des qualifications pénales d'appropriation frauduleuse, de corruption ou de prise illégale d'intérêts.\n\n"
                "Dans cet esprit, il convient ainsi d'orienter l'usager qui souhaite faire un don vers les institutions caritatives de la gendarmerie (Maison de la Gendarmerie) ou de la police.\n\n"
                "Exemples de comportements proscrits:\n"
                "• appropriation irrégulière d'un bien;\n"
                "• détournement d'un scellé, d'un objet ou d'un effet retiré à la suite d'une mesure de sécurité (dans le cadre d'un contrôle d'identité ou préalablement au placement en cellule);\n"
                "• communication/détournement des informations contenues dans un fichier avec contrepartie;\n"
                "• promesse d'un avantage ou d'une indulgence liée à la fonction, avec contrepartie;\n"
                "• abus de sa qualité de policier en s'en prévalant dans des circonstances inappropriées (restaurant, spectacle, démarchage ...)\n\n"
                "Exemples de comportements positifs:\n"
                "• adoption d'un comportement prudent vis-à-vis des personnes qui manifestent des marques d'attachement démesurées, qui offrent des cadeaux ou qui proposent des services présentés comme étant désintéressés;\n"
                "• attention particulière à apporter à ses fréquentations ainsi qu'à celles de son proche entourage (conjoint, enfants), car elles risquent d'engager sa réputation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-10
          _ConditionCard(
            title: "Article R. 434-10 — Discernement",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-10"),
                _normalSpan(" — Discernement\n\n"),
                _normalSpan(
                  "Le policier ou le gendarme fait, dans l'exercice de ses fonctions, preuve de discernement.\n"
                  "Il tient compte en toutes circonstances de la nature des risques et menaces de chaque situation à laquelle il est confronté et des délais qu'il a pour agir, "
                  "pour choisir la meilleure réponse légale à lui apporter.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-10",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Dans l'exercice de ses missions, le policier ou le gendarme doit avant toute action procéder à une analyse de la situation et adapter son comportement en fonction "
                "de l'environnement dans lequel il intervient.\n\n"
                "Au regard des délais qui lui sont impartis, ses réactions doivent être adaptées au contexte et il doit prendre en compte les éléments d'information dont il dispose. "
                "Dès lors que le policier ou le militaire est dans une situation où il ne dispose pas d'alternative légale, ou du temps de réflexion nécessaire, il ne pourra se voir reprocher "
                "d'avoir manqué de discernement.\n\n"
                "Pour autant, il doit faire preuve de bon sens et avoir l'intelligence des situations en graduant son action selon différents paramètres (danger, sécurité de soi-même ou d'autrui, "
                "prise en compte des vulnérabilités ...) et en ne perdant jamais de vue la notion de service public.\n\n"
                "Enfin, le policier et le gendarme doivent appréhender chaque situation de façon différenciée afin d'éviter toute routine qui nuit souvent à la qualité du service rendu, "
                "voire à la sécurité des personnels eux mêmes.\n\n"
                "C'est après avoir étudié les conséquences des différentes solutions retenues que le policier ou le gendarme apportera la réponse la plus adaptée à la situation.\n\n"
                "Les critères de choix et de temps pour agir sont essentiels. Ainsi, moins le policier ou le gendarme disposera de temps pour agir moins l'exigence de discernement pourra être grande "
                "et plus en revanche il disposera de temps pour agir plus elle lui sera opposable.\n\n"
                "Exemples de comportements fautifs:\n"
                "• verbalisation excessive ne tenant pas compte des circonstances, par exemple verbalisation pour stationnement gênant de participants à un enterrement;\n"
                "• déplacement en véhicule sous le signe de l'urgence alors qu'aucun élément ne le justifie objectivement (retour de service, conduite d'une personne interpellée pour des faits mineurs "
                "ou faisant l'objet d'une vérification d'identité,...).\n\n"
                "Exemples de comportements positifs :\n"
                "• prise en compte de l'état d'une personne dont on connaît le handicap, lors d'une convocation au service ou à l'unité (convocation sur une emprise facilement accessible et équipée pour "
                "les personnes à mobilité réduite, voire déplacement au domicile de ladite personne);\n"
                "• décision de ne pas entamer une poursuite automobile lorsque les circonstances de lieu et/ou de circulation ne s'y prêtent pas (par exemple rouler à contre sens sur une BAU d'une autoroute "
                "ou voie rapide).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-11
          _ConditionCard(
            title: "Article R. 434-11 — Impartialité",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-11"),
                _normalSpan(" — Impartialité\n\n"),
                _normalSpan(
                  "Le policier et le gendarme accomplissent leurs missions en toute impartialité.\n"
                  "Ils accordent la même attention et le même respect à toute personne et n'établissent aucune distinction dans leurs actes et leurs propos de nature à constituer l'une des discriminations "
                  "énoncées à l'article 225-1 du code pénal.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-11",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L'impartialité requiert l'absence de discrimination de la part des membres des forces de l'ordre. Afin de cerner au mieux la notion de « discrimination », "
                "il convient de se référer à l'article 225-1 du code pénal¹ qui la précise et qui est susceptible d'évoluer (apparition de nouvelles formes de discrimination qui seront sanctionnées).\n\n"
                "L'impartialité du policier ou du gendarme est une valeur primordiale attendue par la population, en particulier dans la cadre des enquêtes judiciaires qu'il diligente. "
                "Quand il a connaissance d'un litige entre particuliers, il doit agir avec le souci de l'équité et l'aborder sans parti pris en restant neutre. Il traite chacun avec le même professionnalisme, "
                "la même attention et le même souci.\n\n"
                "Exemples de comportements proscrits:\n"
                "• utilisation au seul bénéfice d'un proche, de prérogatives exclusivement attachées à l'exercice de la mission de police (comme s'enquérir auprès de collègues/camarades de l'état d'avancement "
                "d'une procédure pour préparer de futures gardes à vue et d'orienter ainsi une stratégie de défense);",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Texte",
                bodySpans: [
                  TextSpan(text: "Code pénal, "),
                  TextSpan(
                    text: "article 225-1",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : « Constitue une discrimination toute distinction opérée entre les personnes physiques à raison de leur origine, de leur sexe, de leur situation de famille, de leur grossesse, de leur apparence physique, de leur patronyme, de leur état de santé, de leur handicap, de leurs caractéristiques génétiques, de leurs mœurs, de leur orientation ou identité sexuelle, de leur âge, de leurs opinions politiques, de leurs activités syndicales, de leur appartenance ou de leur non-appartenance, vraie ou supposée, à une ethnie, une nation, une race ou une religion déterminée. Constitue également une discrimination toute distinction opérée entre les personnes morales à raison de l'origine, du sexe, de la situation de famille, de l'apparence physique, du patronyme, de l'état de santé, du handicap, des caractéristiques génétiques, des moeurs, de l'orientation ou identité sexuelle, de l'âge, des opinions politiques, des activités syndicales, de l'appartenance ou de la non-appartenance, vraie ou supposée, à une ethnie, une nation, une race ou une religion déterminée des membres ou de certains membres de ces personnes morales. »",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "• ciblage positif ou négatif d'une personne ou d'un groupe de personnes (victime ou mis en cause) en raison de ses opinions religieuses, philosophiques, politiques, de son orientation sexuelle, etc.;\n"
                "• rédaction, affichage, diffusion, sous quelque forme que ce soit, dans les locaux de service, d'écrits à caractère raciste, xénophobe, sexiste, homophobe,... appelant à l'indiscipline collective ou de nature politique, y compris de manière « humoristique ».\n\n"
                "Exemple de comportements positifs :\n"
                "• souci d'écoute vis à vis d'un plaignant « d'habitude » ou d'une personne « défavorablement connue » du service ou de l'unité lorsqu'elle se manifeste en qualité de victime ou de témoin. "
                "La traiter avec le même égard que n'importe quel autre plaignant/témoin, en faisant abstraction de sa propre opinion sur elle et sans remettre systématiquement en question ses déclarations.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-12
          _ConditionCard(
            title: "Article R. 434-12 — Crédit et renom",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-12"),
                _normalSpan(
                  " — Crédit et renom de la police nationale et de la gendarmerie nationale\n\n",
                ),
                _normalSpan(
                  "Le policier ou le gendarme ne se départ de sa dignité en aucune circonstance.\n\n"
                  "En tout temps, dans ou en dehors du service, y compris lorsqu'il s'exprime à travers les réseaux de communication électronique sociaux, "
                  "il s'abstient de tout acte, propos ou comportement de nature à nuire à la considération portée à la police nationale et à la gendarmerie nationale. "
                  "Il veille à ne porter, par la nature de ses relations, aucune atteinte à leur crédit ou à leur réputation.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-12",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le devoir d'exemplarité découle directement du statut et de la qualité du policier ou du gendarme. Susceptible d'être assimilé à l'institution qu'il sert, "
                "il doit en tenir compte dans sa vie professionnelle et personnelle. En ou en dehors du service, le policier ou le gendarme ne saurait adopter un comportement "
                "ou une attitude (tenue, propos, ...) susceptibles d'altérer la crédibilité de son action en service et/ou de porter atteinte à l'image et la réputation de l'institution qu'il représente.\n\n"
                "A la différence de l'atteinte à l'honneur qui suppose une certaine publicité et un impact négatif, le devoir d'exemplarité est violé par le comportement incriminé, "
                "que celui-ci ait eu ou non pour conséquence de flétrir l'image de l'institution. Ce manquement recouvre par ailleurs des actes extrêmement diversifiés dont la gravité varie. "
                "Il peut être aussi constitué par la violation d'une autre obligation.\n\n"
                "L'usage des réseaux sociaux par un policier ou un gendarme peut présenter des risques de dérives : atteinte au devoir de réserve, atteinte à la neutralité, diffamation, injures, "
                "discrimination portant de facto atteinte au renom de l'institution d'appartenance.\n\n"
                "Il s'agit ici d'une extension du devoir de réserve à l'utilisation des médias sociaux. Elle se veut également une garantie indispensable pour la sécurité des policiers/gendarmes et de leur famille.\n\n"
                "Cet article doit être notamment appréhendé au regard des dispositions relatives à la probité énoncées à l'article 8 du présent code.\n\n"
                "Il convient de noter que l'obligation « de ne pas porter atteinte au crédit de l'institution » s'analyse comme une obligation de résultat.\n\n"
                "Aussi, le policier ou le gendarme dont les propos tenus en privés (et notamment sur un réseau social d'opinions) sont de nature à porter atteinte au crédit de l'institution "
                "et qui ont, in fine, été relayés et portés à la connaissance de son administration ou du public, peut se voir reprocher un tel manquement, indépendamment de l'existence ou non d'une faute distincte. "
                "C'est donc, dans ce domaine, à une obligation particulière de prudence à laquelle policiers et gendarmes sont soumis.\n\n"
                "Exemples de comportements portant atteinte au devoir d'exemplarité:\n"
                "• conduite automobile dangereuse;\n"
                "• propos injurieux tenus en public;\n"
                "• usage inapproprié des avertisseurs sonores et signaux lumineux avec un véhicule de service sans nécessité liée à l'exécution d'une mission;\n"
                "• port d'un tatouage ou d'un signe ou un insigne distinctif marquant une appartenance religieuse, politique ou syndicale (ce comportement constitue également un manquement au devoir d'impartialité);\n"
                "• relations personnelles en connaissance de cause avec une personne défavorablement connue des services de police et/ou de justice (ce comportement constitue également une atteinte portée au renom de la police nationale);\n"
                "• publicité donnée aux aléas relevant de la sphère privée (différends conjugaux ayant nécessité l'intervention des services de police/gendarmerie);\n"
                "• faire l'objet de poursuites ou condamnations judiciaires pour des faits commis dans l'exercice ou à l'occasion de l'exercice des fonctions, ou même en dehors du service (corruption, pédopornographie ...);\n"
                "• participation sans autorisation à des jeux ou émissions de divertissement audiovisuelles, en arguant de sa qualité (atteinte à l'image de la police/gendarmerie);\n"
                "• démarchage publicitaire;\n"
                "• divulgation d'informations sur les réseaux sociaux, quel qu'en soit le support (textes, photos, vidéos, commentaires, ...) susceptibles de porter atteinte à l'image de l'institution. "
                "Ainsi, il convient de proscrire la création de blogs où l'appartenance de l'auteur à l'une des deux institutions est aisément décelable.\n\n"
                "Exemples de comportements positifs :\n"
                "• attention portée à son apparence: propreté, coupe de cheveux, sobriété...\n"
                "• observation d'une grande mesure en se gardant notamment de tout jugement excessif, susceptible de publicité, qui pourrait déconsidérer le policier ou le gendarme.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-13
          _ConditionCard(
            title: "Article R. 434-13 — Non cumul d'activité",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-13"),
                _normalSpan(" — Non cumul d'activité\n\n"),
                _normalSpan(
                  "Le policier ou le gendarme se consacre à sa mission.\n"
                  "Il ne peut exercer une activité privée lucrative que dans les cas et les conditions définis pour chacun d'eux par les lois et règlements.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-13",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Responsables de l'exécution des missions de sécurité intérieure, les policiers et les gendarmes doivent se consacrer entièrement à leurs missions et ne peuvent occuper, "
                "sauf conditions particulières, des fonctions annexes à but lucratif.\n\n"
                "Des exceptions au principe de non cumul d'activités sont prévues par la loi et le règlement.\n\n"
                "Cependant, il convient de rappeler qu'aucune activité annexe ne peut être exercée sans avoir été au préalable déclarée et autorisée par l'administration.\n\n"
                "Exemples de comportements fautifs:\n"
                "• mission de sécurité privée effectuée par un policier/gendarme (ce qui constitue également une atteinte portée au crédit de la police/gendarmerie nationales);\n"
                "• exercice d'une activité potentiellement autorisée sans avoir sollicité et obtenu l'autorisation;\n"
                "• absentéisme sans motif légitime pour exercer un cumul non autorisé;\n"
                "• exécution de tâches de nature personnelle ou privée pendant le service.",
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================
          // TITRE II — DISPOSITIONS COMMUNES
          // =========================
          _ConditionCard(
            title: "TITRE II — DISPOSITIONS COMMUNES (Police & Gendarmerie)",
            cardColor: cardTitle,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "CHAPITRE IER — RELATION AVEC LA POPULATION ET RESPECT DES LIBERTÉS",
              ),
            ],
          ),
          const SizedBox(height: 14),

          // R. 434-14
          _ConditionCard(
            title: "Article R. 434-14 — Relation avec la population",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-14"),
                _normalSpan(" — Relation avec la population\n\n"),
                _normalSpan(
                  "Le policier ou le gendarme est au service de la population.\n"
                  "Sa relation avec celle-ci est empreinte de courtoisie et requiert l'usage du vouvoiement.\n"
                  "Respectueux de la dignité des personnes, il veille à se comporter en toute circonstance d'une manière exemplaire, propre à inspirer en retour respect et considération.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-14",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le service à la population constitue l'essence même de l'activité des policiers et des gendarmes. La population juge un service de police ou une unité de gendarmerie "
                "à la façon dont agissent ses personnels. En conséquence, le comportement de chacun d'entre eux influe directement sur la crédibilité des deux institutions. "
                "La correction et la politesse qu'ils observent, leur tenue, leur expression, leur attitude générale sont autant de repères quant à la satisfaction de cette obligation.\n\n"
                "Policiers et gendarmes doivent adopter une attitude et un comportement irréprochables, sans lesquels ils ne peuvent incarner l'autorité et inspirer considération et confiance.\n\n"
                "Exemples de comportements fautifs :\n"
                "• familiarité excessive, incorrection, tutoiement;\n"
                "• comportements ou propos agressifs;\n"
                "• absence de salut des personnes (hors cas particuliers: interpellation,...;\n"
                "• usage abusif du téléphone en tenue et ostensiblement devant le public;\n"
                "• port incomplet, panaché ou non conforme (veste ouverte,...) d'une tenue d'uniforme pendant l'exercice des missions;\n"
                "• tenue civile manifestement inadaptée et peu conforme à la fonction exercée (port du short, ou de chaussures de plage hors de l'espace adapté).\n\n"
                "Exemples de comportements positifs :\n"
                "• réception du plaignant avec attention en prenant le temps de dispenser les conseils utiles même lorsqu'une personne souhaite déposer plainte alors qu'il n'y a assurément pas constitution d'une infraction pénale;\n"
                "• lors d'une patrouille, s'arrêter d'initiative et proposer spontanément son aide aux personnes qui semblent perdues ou isolées.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-15
          _ConditionCard(
            title: "Article R. 434-15 — Port de la tenue",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-15"),
                _normalSpan(" — Port de la tenue\n\n"),
                _normalSpan(
                  "Le policier ou le gendarme exerce ses fonctions en uniforme. Il peut être dérogé à ce principe selon les règles propres à chaque force.\n"
                  "Sauf exception justifiée par le service auquel il appartient ou la nature des missions qui lui sont confiées, il se conforme aux prescriptions relatives à son identification individuelle.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-15",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier ou le gendarme doit pouvoir justifier de son appartenance à son institution. Le port de la tenue répond notamment à cette exigence de visibilité.\n\n"
                "Dans la relation avec l'usager, la tenue constitue un moyen d'identification du service/unité. Son port ne doit souffrir d'aucune approximation car il renvoie directement "
                "à l'image de l'institution. Lorsque les missions sont exercées en tenue civile, celle-ci doit être correcte et conforme à ce que l'administration est en droit d'exiger "
                "d'un agent d'autorité (une dérogation à ce principe existe toutefois pour l'accomplissement de certaines missions administratives et judiciaires).\n\n"
                "L'identification du policier et du gendarme par un numéro porté de manière visible est désormais obligatoire et se fonde sur l'exigence des principes de transparence et de responsabilité individuelle.\n\n"
                "Elément apparent, son support constitue un effet de l'uniforme. Il figure également sur la tenue du policier ou gendarme exerçant ses missions en tenue civile par apposition "
                "de son brassard lorsqu'il est amené à faire état de sa qualité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-16
          _ConditionCard(
            title: "Article R. 434-16 — Contrôles d'identité",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-16"),
                _normalSpan(" — Contrôles d'identité\n\n"),
                _normalSpan(
                  "Lorsque la loi l'autorise à procéder à un contrôle d'identité, le policier ou le gendarme ne se fonde sur aucune caractéristique physique ou aucun signe distinctif "
                  "pour déterminer les personnes à contrôler, sauf s'il dispose d'un signalement précis motivant le contrôle.\n\n"
                  "Le contrôle d'identité se déroule sans qu'il soit porté atteinte à la dignité de la personne qui en fait l'objet.\n\n"
                  "La palpation de sécurité est exclusivement une mesure de sûreté. Elle ne revêt pas un caractère systématique. Elle est réservée aux cas dans lesquels elle apparaît nécessaire "
                  "à la garantie de la sécurité du policier ou du gendarme qui l'accomplit ou de celle d'autrui. Elle a pour finalité de vérifier que la personne contrôlée n'est pas porteuse "
                  "d'un objet dangereux pour elle-même ou pour autrui.\n\n"
                  "Chaque fois que les circonstances le permettent, la palpation de sécurité est pratiquée à l'abri du regard du public.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-16",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le code de procédure pénale autorise, dans certaines conditions, policiers et gendarmes à procéder à des contrôles d'identité, par essence attentatoires aux libertés individuelles.\n\n"
                      "Leur mise en œuvre, qui requiert une parfaite maîtrise du cadre procédural (",
                ),
                _lawSpan("article 78-2 du code de procédure pénale"),
                const TextSpan(
                  text:
                      "), exige donc tact et discernement.\n\n"
                      "La palpation de sécurité est une mesure de protection des policiers, des gendarmes et du public qui se révèle peu intrusive puisqu'elle n'implique pas la fouille ou le retrait de vêtement. "
                      "Elle peut néanmoins être ressentie comme vexatoire par ceux sur lesquels elle est pratiquée et qui ne peuvent s'y soustraire. C'est la raison pour laquelle sa pratique à l'occasion d'un contrôle d'identité, "
                      "qui ne doit pas revêtir un caractère systématique, est guidée par des considérations objectives fondées sur la dangerosité potentielle de la personne.\n\n"
                      "A cet effet, l'observation des éléments suivants est requise :\n"
                      "• analyse des situations de contrôles. Ils sont réalisés en raison du comportement de la personne, sur la base d'une réquisition du parquet ou en présence d'un risque grave pour l'ordre public;\n"
                      "• politesse à l'égard de la personne faisant l'objet d'une palpation;\n"
                      "• aviser la personne concernée de la palpation lorsqu'il est décidé de la pratiquer et de sa finalité, commenter l'opération;\n"
                      "• ne pas réaliser de fouille ou de retrait de vêtements;\n"
                      "• solliciter le concours de la personne concernée.\n\n"
                      "Cet encadrement réglementaire des palpations de sécurité en rappelle la seule finalité : la protection des personnes et non la recherche des éléments constitutifs d'une éventuelle infraction commise par la personne contrôlée.\n\n"
                      "Exemples de comportements à adopter lors des contrôles d'identité :\n"
                      "• justification succincte de la mission qui ne doit jamais prendre l'aspect d'une tracasserie ou d'une mesure vexatoire:\n"
                      "• maîtrise de soi, notamment lorsque la personne contrôlée conteste ou s'offusque de l'intervention. Parler sans brusquerie, sans élever la voix. Rester ferme, sans être cassant ou ironique. "
                      "Le calme, la politesse et la courtoisie, marques de professionnalisme, sont de nature à apaiser les tensions.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-17
          _ConditionCard(
            title: "Article R. 434-17 — Personnes privées de liberté",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-17"),
                _normalSpan(
                  " — Protection et respect des personnes privées de liberté\n\n",
                ),
                _normalSpan(
                  "Toute personne appréhendée est placée sous la protection des policiers ou des gendarmes et préservée de toute forme de violence et de tout traitement inhumain ou dégradant.\n\n"
                  "Nul ne peut être intégralement dévêtu, hors le cas et dans les conditions prévus par l'article 63-7 du code de procédure pénale visant la recherche des preuves d'un crime ou d'un délit.\n\n"
                  "Le policier ou le gendarme ayant la garde d'une personne appréhendée est attentif à son état physique et psychologique et prend toutes les mesures possibles pour préserver la vie, la santé et la dignité de cette personne.\n\n"
                  "L'utilisation du port des menottes ou des entraves n'est justifiée que lorsque la personne appréhendée est considérée soit comme dangereuse pour autrui ou pour elle-même, soit comme susceptible de tenter de s'enfuir.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-17",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La nature particulière des mesures de privation de liberté imposent au policier ou au gendarme de les appliquer en respectant strictement la dignité des personnes retenues. "
                      "Il doit tenir compte de leur vulnérabilité et de leurs besoins personnels afin de prévenir les situations de détresse ou de danger.\n\n"
                      "Il doit évidemment s'abstenir de toute mesure vexatoire ou humiliante. Cette obligation vise en particulier les opérations matérielles auxquelles est soumise la personne placée sous la garde d'un service de police ou de gendarmerie (transport, mesures de contrainte, ...).\n\n"
                      "L'officier de police judiciaire, et sous son contrôle, les agents de police judiciaire et agents de police judiciaire adjoints, sont responsables des conditions matérielles de la garde à vue ou de la retenue et doivent se montrer en permanence vigilants afin de prévenir toute détérioration de la santé mentale et/ou physique des personnes privées de liberté. "
                      "Une attention particulière doit être portée aux mesures de fouilles par nature susceptibles de nuire à la dignité des personnes. Outre le respect de la réglementation en vigueur relative aux modalités d'exécution des fouilles et à l'utilisation des menottes ou des entraves, le policier ou le gendarme doit faire preuve de discernement et adapter ces mesures au comportement de la personne retenue.\n\n"
                      "Exemples de comportements fautifs :\n"
                      "• transport de la personne interpellée dans des conditions contraires à la dignité;\n"
                      "• menottage contraire aux principes posés à ",
                ),
                _lawSpan("l'article 803 du code de procédure pénale"),
                const TextSpan(
                  text:
                      ";\n"
                      "• défaut de restitution de vêtements ou d'accessoires essentiels (soutien-gorge, lunettes, prothèse) pour les auditions ou les transports des personnes précédemment détenues ou retenues;\n"
                      "• usage de la force sans nécessité pour les besoins de l'interpellation ou après celle-ci;\n"
                      "• défaut de soins ou de sollicitation des secours;\n"
                      "• techniques d'emploi de la force non conformes (maintien prolongé au sol en position ventrale, « pliage » dans un véhicule ...);\n"
                      "• exposition inutile à la vue du public d'une personne interpellée et menottée ;\n"
                      "• non respect délibéré des interdits alimentaires;\n"
                      "• refus de fournir à la personne placée sous surveillance les médicaments prescrits par un médecin et nécessaires au traitement de sa pathologie.\n\n"
                      "Exemples de comportements positifs:\n"
                      "• respect des consignes relatives aux rondes visant à contrôler l'état des personnes en garde à vue placées dans les chambres de sûreté;\n"
                      "• respect de la dignité de la personne humaine lors des fouilles de sûreté en s'abstenant de tout geste équivoque ou tout propos déplacé.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-18
          _ConditionCard(
            title: "Article R. 434-18 — Emploi de la force",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-18"),
                _normalSpan(" — Emploi de la force\n\n"),
                _normalSpan(
                  "Le policier ou le gendarme emploie la force dans le cadre fixé par la loi, seulement lorsque c'est nécessaire, et de façon proportionnée au but à atteindre ou à la gravité de la menace, selon le cas.\n"
                  "Il ne fait usage des armes qu'en cas d'absolue nécessité et dans le cadre des dispositions législatives applicables à son propre statut.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-18",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Avant certains recours à la force, le dialogue et la négociation seront privilégiés: évaluation des situations où l'action prime le dialogue/le dialogue prime l'action.\n\n"
                "Concernant l'emploi de la force, le policier ou le gendarme doit parvenir au juste équilibre dans le cadre de son intervention. Cette obligation vise à prévenir un emploi considéré comme inutile de la force ou de la contrainte, "
                "un usage disproportionné d'une arme (arme individuelle, arme de force intermédiaire - lanceurs de balles de défense, pistolet à impulsions électriques, ...). "
                "A ce titre, il appartient à chaque militaire et policier de connaître parfaitement les règles d'emploi des moyens de force intermédiaire et armes mises à sa disposition.\n\n"
                "En tout état de cause, le recours à la force doit être proportionné à l'objectif à atteindre ou à la gravité de la menace et ne pas aller au delà de ce qui est nécessaire.\n\n"
                "Cet article reconnaît dans le cadre de l'usage des armes le principe jurisprudentiel d'absolue nécessité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-19
          _ConditionCard(
            title: "Article R. 434-19 — Assistance aux personnes",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-19"),
                _normalSpan(" — Assistance aux personnes\n\n"),
                _normalSpan(
                  "Lorsque les circonstances le requièrent, le policier ou le gendarme, même lorsqu'il n'est pas en service, intervient de sa propre initiative, avec les moyens dont il dispose, notamment pour porter assistance aux personnes en danger.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-19",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La préservation des personnes étant l'une des missions principales du policier et du gendarme, ceux-ci doivent tout mettre en œuvre pour porter assistance aux personnes en péril. "
                "Leur engagement peut néanmoins être limité en fonction des moyens (physiques, matériels, ...) dont ils disposent (appréciation in concreto).\n\n"
                "Ce devoir d'intervention s'entend au-delà des prescriptions du code pénal.\n\n"
                "Exemples de comportements fautifs :\n"
                "• refus d'intervention obligatoire en service ou en dehors du service;\n"
                "• défaut d'intervention en service (oubli, rejet d'une réquisition);\n"
                "• retard important et non justifiable dans l'intervention.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-20
          _ConditionCard(
            title: "Article R. 434-20 — Aide aux victimes",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-20"),
                _normalSpan(" — Aide aux victimes\n\n"),
                _normalSpan(
                  "Sans se départir de son impartialité, le policier ou le gendarme accorde une attention particulière aux victimes et veille à la qualité de leur prise en charge tout au long de la procédure les concernant. "
                  "Il garantit la confidentialité de leurs propos et déclarations.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-20",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Outre les obligations légales et réglementaires en matière d'assistance aux victimes, le policier ou le gendarme assure, dans les limites de la préservation du secret de l'enquête judiciaire, "
                "une information régulière de l'état d'avancement de la procédure les concernant et apporte tout conseil et assistance pouvant les aider dans leurs démarches.\n\n"
                "Il est rappelé que la première obligation du policier ou du gendarme est de prendre les plaintes en vertu de l'article 15-3 du code de procédure pénale. Dans l'hypothèse où le fait dénoncé "
                "ne constitue pas une infraction pénale, la victime doit être orientée vers d'autres administrations ou structures idoines.\n\n"
                "La politique d'aide aux victimes permet d'assurer l'égalité de tous devant la loi. Garantie du respect des droits de la personne, elle permet également de mieux lutter contre les exclusions "
                "et de réduire le sentiment d'insécurité.\n\n"
                "Aujourd'hui, la prise en considération de la victime/plaignant représente un axe d'effort essentiel dans les relations entre les services de police et de gendarmerie d'une part, et la population d'autre part.\n\n"
                "Exemples de comportements fautifs :\n"
                "• non-respect du guichet unique;\n"
                "• refus de prendre une plainte, alors que les faits constituent bien une infraction pénale notamment au motif que l'usager ne dispose pas de certains documents (factures, devis, certificat médical);\n"
                "• accueil du plaignant non conforme à la charte d'accueil du public (manque d'attention/d'écoute dans le dépôt de plainte, non-respect de la confidentialité, absence d'orientation sur des services de soins ou d'écoute, "
                "absence d'information sur les suites données à la procédure, etc.);\n"
                "• manque de courtoise et de professionnalisme à l'égard des victimes, notamment pour un opérateur CIC/CORG ou chargé d'accueil.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                _lawSpan("article 15-3 du code de procédure pénale"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-21
          _ConditionCard(
            title: "Article R. 434-21 — Données à caractère personnel",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-21"),
                _normalSpan(
                  " — Usage des traitements de données à caractère personnel\n\n",
                ),
                _normalSpan(
                  "Sans préjudice des exigences liées à l'accomplissement de sa mission, le policier ou le gendarme respecte et préserve la vie privée des personnes, notamment lors d'enquêtes administratives ou judiciaires.\n"
                  "A ce titre, il se conforme aux dispositions législatives et réglementaires qui régissent la création et l'utilisation des traitements de données à caractère personnel.\n\n"
                  "Il alimente et consulte les fichiers auxquels il a accès dans le strict respect des finalités et des règles propres à chacun d'entre eux, telles qu'elles sont définies par les textes les régissant, et qu'il est tenu de connaître.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-21",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cet article vise le respect scrupuleux des règles légales et réglementaires relatives à l'utilisation des fichiers de police comportant des données à caractère personnel. "
                "L'utilisation de ces moyens constitue une prérogative aux incidences majeures sur les libertés individuelles.\n\n"
                "Aussi, le recours à un fichier de police doit être strictement motivé par des nécessités de service. La violation de ses principes et règles constitue un manquement qui peut être visé seul "
                "ou être complémentaire à un manquement à la probité. De même, la création de fichiers comportant des données personnelles est strictement interdite en dehors de tout cadre légal et doit donc faire l'objet d'une déclaration.\n\n"
                "La sensibilité de ce domaine nécessite une parfaite connaissance par les policiers et gendarmes des devoirs qui leur incombent en la matière et notamment des interdictions existantes.\n\n"
                "Exemples de comportements fautifs :\n"
                "• partage du code confidentiel d'accès aux applications;\n"
                "• interrogations injustifiées sur les antécédents judiciaires supposés d'une personne (par curiosité - personnalités - par intérêt personnel - conflit privé - ...);\n"
                "• utilisation du mode de consultation judiciaire pour les enquêtes administratives;\n"
                "• transmission d'informations issues des fichiers de police en dehors du cadre autorisé;\n"
                "• effacement de données en dehors de tout cadre réglementaire ou légal;\n"
                "• constitution de bases de données nominatives non déclarées;\n"
                "• détournement de la finalité d'un fichier (ex: utiliser le fichier des personnes vulnérables en cas de canicule à une autre fin ...aussi louable soit-elle).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-22
          _ConditionCard(
            title: "Article R. 434-22 — Sources humaines",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-22"),
                _normalSpan(" — Traitement des sources humaines\n\n"),
                _normalSpan(
                  "A l'occasion de la recherche des renseignements nécessaires à ses missions, le policier ou le gendarme peut avoir recours à des informateurs. "
                  "Dans ce cas, il est tenu d'appliquer les règles d'exécution du service définies en la matière pour chacune des deux forces.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-22",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La recherche d'efficacité ne doit pas s'opérer au détriment de la sécurité, notamment juridique, des policiers et des gendarmes.\n\n"
                "Le recours à des sources humaines doit donc s'exécuter dans le strict respect des règles définies par les deux forces : une obligation de prudence s'impose.\n\n"
                "Cet article ne concerne pas les cas où la personne collabore spontanément et par seul esprit civique avec les services de police ou de gendarmerie.\n\n"
                "Si ces règles trouvent à s'appliquer principalement à l'occasion de l'exercice des missions de police judiciaire, elles concernent également l'ensemble des personnels susceptibles, dans leur pratique professionnelle, "
                "d'entrer en contact régulier avec des interlocuteurs prêts à délivrer du renseignement contre un avantage ou une certaine forme de reconnaissance.\n\n"
                "S'agissant plus spécifiquement du policier, c'est ici que le renvoi à l'existence d'une charte, plus qu'à son contenu, est essentiel. En effet, si le contact avec la personne délivrant des renseignements ne se situe pas "
                "dans le périmètre de la charte (immatriculation ou procédure d'évaluation d'un informateur), l'agent doit avoir conscience que les relations qu'il établit seront analysées comme relevant de la relation privée avec les conséquences "
                "qui s'attachent à des fréquentations qui peuvent se révéler douteuses ou condamnables.\n\n"
                "Cette charte a fait l'objet d'une instruction en 2012.\n\n"
                "Parallèlement, la gendarmerie nationale dispose également depuis 2012 d'un guide des bonnes pratiques en matière de gestion des sources humaines de renseignements qui est diffusé à l'ensemble des unités de police judiciaire concernées. "
                "En complément de la circulaire fixant la doctrine en la matière, le guide précise les règles de sécurité et de prudence à appliquer, en rappelant les obligations fondamentales qui s'attachent à cette pratique.",
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================
          // CHAPITRE II — CONTRÔLE
          // =========================
          _ConditionCard(
            title: "CHAPITRE II — CONTRÔLE DE L'ACTION",
            cardColor: cardTitle,
            accent: accentBlue,
            titleColor: textMain,
            children: const [_Paragraph("Articles R. 434-23 à R. 434-27")],
          ),
          const SizedBox(height: 14),

          // R. 434-23
          _ConditionCard(
            title: "Article R. 434-23 — Principes du contrôle",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-23"),
                _normalSpan(" — Principes du contrôle\n\n"),
                _normalSpan(
                  "La police nationale et la gendarmerie nationale sont soumises au contrôle des autorités désignées par la loi et par les conventions internationales.\n\n"
                  "Dans l'exercice de leurs missions judiciaires, la police nationale et la gendarmerie nationale sont soumises au contrôle de l'autorité judiciaire conformément aux dispositions du code de procédure pénale.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-23",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les policiers et les gendarmes sont soumis à un nombre particulièrement élevé de contrôles qu'ils soient internes ou externes. Aux contrôles cités dans les articles de ce code s'ajoutent ceux opérés par des instances extérieures "
                "à la sphère judiciaire et administrative. Il en est ainsi de la création, en 2007, du contrôleur général des lieux de privation de liberté qui a pour mission de veiller au respect de la dignité des personnes privées de liberté.\n\n"
                "Enfin, au-delà de ces instances nationales, il existe un organe européen de contrôle : le comité européen pour la prévention de la torture et des peines ou traitements inhumains ou dégradants (CPT) qui, à l'issue des différentes visites "
                "au sein des services de police et des unités de gendarmerie, émet des recommandations visant à prévenir les mauvais traitements et à améliorer les conditions de détention des personnes.\n\n"
                "De même, si la cour européenne des droits de l'homme (CEDH) n'est pas un organe de contrôle à proprement parler, ses décisions influent directement sur l'action des forces de sécurité (introduction de la notion d'absolue nécessité concernant "
                "l'usage des armes par les gendarmes par exemple) et sur le droit national (cf. la récente réforme de la garde à vue).\n\n"
                "Le deuxième alinéa de cet article vise explicitement l'autorité judiciaire qui n'est pas une autorité du contrôle interne des policiers et des gendarmes.\n\n"
                "En revanche, elle assure la direction de la police judiciaire et selon les cas, la contrôle et la surveille.\n\n"
                "Ainsi, l'autorité judiciaire délivre, suspend ou retire la qualité d'agent ou d'officier de police judiciaire.\n\n"
                "Le parquet peut également alerter l'administration sur les faits commis par un agent dans le cadre de son droit de communication, afin que l'administration puisse s'en saisir. "
                "Ces faits sont en effet susceptibles d'entraîner des sanctions disciplinaires et d'affecter l'exercice de la profession du policier ou du gendarme.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-24
          _ConditionCard(
            title: "Article R. 434-24 — Le Défenseur des droits",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-24"),
                _normalSpan(" — Le Défenseur des droits\n\n"),
                _normalSpan(
                  "La police nationale et la gendarmerie nationale sont soumises au contrôle du Défenseur des droits conformément au rôle que lui confère l'article 71-1 de la Constitution.\n\n"
                  "L'exercice par le Défenseur des droits de ce contrôle peut le conduire à saisir l'autorité chargée d'engager les poursuites disciplinaires des faits portés à sa connaissance qui lui paraissent de nature à justifier une sanction.\n\n"
                  "Lorsqu'il y est invité par le Défenseur des droits, le policier ou le gendarme lui communique les informations et pièces que celui-ci juge utiles à l'exercice de sa mission. "
                  "Il défère à ses convocations et peut à cette occasion être assisté de la personne de son choix.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-24",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les policiers et les gendarmes, dépositaires du monopole de la violence légitime, doivent pouvoir rendre des comptes aux citoyens.\n\n"
                "C'est ainsi que le défenseur des droits, autorité constitutionnelle indépendante, participe activement au contrôle sociétal de l'action des policiers et des gendarmes. "
                "Cette autorité qui peut être saisie directement par des particuliers dispose de moyens étendus pour enquêter sur les faits dénoncés (les secrets de l'enquête et de l'instruction ne lui sont pas opposables).\n\n"
                "Ses saisines peuvent donner lieu à des demandes de sanctions disciplinaires, si cette autorité établit que des manquements à la déontologie ont été commis, et/ou à des recommandations au ministre de l'intérieur.\n\n"
                "Au delà du contrôle interne existant et de celui exercé par l'autorité judiciaire, ce dispositif de contrôle indépendant constitue une garantie supplémentaire visant à renforcer la confiance de la population envers les institutions "
                "(cf. les dispositifs analogues dans les autres pays européens).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-25
          _ConditionCard(
            title: "Article R. 434-25 — Contrôle hiérarchique et inspections",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-25"),
                _normalSpan(" — Contrôle hiérarchique et des inspections\n\n"),
                _normalSpan(
                  "L'autorité investie du pouvoir hiérarchique contrôle l'action de ses subordonnés.\n"
                  "Le policier ou le gendarme est également soumis au contrôle d'une ou de plusieurs inspections générales compétentes à l'égard du service auquel il appartient.\n\n"
                  "Sans préjudice des règles propres à la procédure disciplinaire et des droits dont le policier ou le gendarme bénéficie en cas de mise en cause personnelle, "
                  "il facilite en toute circonstance le déroulement des opérations de contrôle et d'inspection auxquelles il est soumis.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-25",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le contrôle constitue un des devoirs fondamentaux du chef, tout spécialement dans le domaine de la déontologie qui ne peut souffrir d'aucune déviance.\n\n"
                "Inhérent au bon fonctionnement des institutions, il représente un gage de crédibilité et de légitimité pour l'action de tous les policiers et gendarmes.\n\n"
                "Les services d'inspection sont les principaux organes du contrôle interne des forces de sécurité intérieure. Ils sont en capacité de diligenter soit des enquêtes administratives, "
                "soit des enquêtes judiciaires (les unes n'étant pas exclusives des autres).\n\n"
                "L'IGPN et l'IGGN participent également du contrôle des pairs.\n\n"
                "Exemples de comportements à adopter :\n"
                "• devoir de contrôle dès les premiers temps, par le chef récemment muté à la tête d'une unité, de l'ensemble des domaines considérés comme sensibles : contrôle des dotations financières, état des scellés, contrôle de l'armement ... ;\n"
                "• contrôle, par le supérieur hiérarchique, des procédures judiciaires établies par ses subordonnés avant leur transmission à l'autorité judiciaire: qualité des procédures, respect des délais,...",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-26
          _ConditionCard(
            title: "Article R. 434-26 — Contrôle des pairs",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-26"),
                _normalSpan(" — Contrôle des pairs\n\n"),
                _normalSpan(
                  "Les policiers et gendarmes de tous grades auxquels s'applique le présent code en sont dépositaires. "
                  "Ils veillent à titre individuel et collectif à son respect.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-26",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L'appropriation d'un code de déontologie passe obligatoirement par le contrôle opéré par les pairs qui sont « les premiers gardiens » des règles liées à l'exercice de leur profession.\n\n"
                "Bien souvent, les manquements à la déontologie sont en premier lieu connus des pairs du policier ou du gendarme qui en sont témoins. Or, le silence, qui peut exister face à certains agissements répréhensibles au regard de la déontologie, vaut consentement. "
                "Ainsi, les dérapages les plus graves constatés sont-ils souvent collectifs. Le retentissement est alors d'autant plus important que c'est une unité complète qui faillit.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-27
          _ConditionCard(
            title: "Article R. 434-27 — Sanction des manquements",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-27"),
                _normalSpan(" — Sanction des manquements déontologiques\n\n"),
                _normalSpan(
                  "Tout manquement du policier ou du gendarme aux règles et principes définis par le présent code l'expose à une sanction disciplinaire en application des règles propres à son statut, "
                  "indépendamment des sanctions pénales encourues le cas échéant.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-27",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le code de déontologie constitue la base juridique de sanctions disciplinaires, au même titre que d'autres fondements (code de la défense pour les militaires de la gendarmerie). "
                "Un même comportement est susceptible de contrevenir à plusieurs devoirs et obligations et donc de constituer plusieurs manquements aux dispositions du présent code.\n\n"
                "Ce texte autorise à relever des fautes contre le policier ou le gendarme susceptibles d'entrainer sa responsabilité disciplinaire. Il est à ce titre également protecteur en ce qu'il impose au pouvoir disciplinaire de s'interroger sur les manquements et sur les comportements "
                "et non pas seulement sur le préjudice résultant éventuellement d'une opération de police et sur l'émotion qu'un dommage peut naturellement susciter\n\n"
                "Les poursuites pénales éventuelles qui découleraient de l'inobservation des règles énoncées dans le présent code font déjà l'objet de dispositions prévues dans le code pénal.\n\n"
                "Pour les militaires de la gendarmerie, qui sont déjà soumis aux dispositions du code de défense, cet article rappelle l'existant et ne crée donc pas de nouveaux motifs de sanctions.",
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================
          // TITRE III — DISPOSITIONS PROPRES
          // =========================
          _ConditionCard(
            title: "TITRE III — DISPOSITIONS PROPRES",
            cardColor: cardTitle,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph("Police nationale & Gendarmerie nationale"),
            ],
          ),

          const SizedBox(height: 14),

          // Police Nationale
          _ConditionCard(
            title: "CHAPITRE IER — Dispositions propres à la police nationale",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [_Paragraph("Articles R. 434-28 à R. 434-30")],
          ),
          const SizedBox(height: 14),

          // R. 434-28
          _ConditionCard(
            title:
                "Article R. 434-28 — Considération, respect et devoir de mémoire",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-28"),
                _normalSpan(
                  " — Considération, respect et devoir de mémoire\n\n",
                ),
                _normalSpan(
                  "La fonction de policier comporte des devoirs et implique des risques et des sujétions qui méritent le respect et la considération de tous.\n"
                  "Gardien de la paix, éventuellement au péril de sa vie, le policier honore la mémoire de ceux qui ont péri dans l'exercice de missions de sécurité intérieure, victimes de leur devoir.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-28",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La défense de l'image de l'institution et la préservation de sa cohésion interne incombent à tous les policiers. Aussi, les manifestations visant à entretenir le souvenir des policiers décédés en service, loin de ne constituer qu'un simple rituel, "
                "relèvent de l'obligation professionnelle et appellent, à ce titre, l'association de tous les agents.\n\n"
                "Exemple de comportement fautif:\n"
                "• absence lors de l'observation d'une minute de silence, sans motif valable tel que l'exécution en cours d'une mission ne pouvant être différée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-29
          _ConditionCard(
            title: "Article R. 434-29 — Devoir de réserve",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-29"),
                _normalSpan(" — Devoir de réserve\n\n"),
                _normalSpan(
                  "Le policier est tenu à l'obligation de neutralité.\n"
                  "Il s'abstient, dans l'exercice de ses fonctions, de toute expression ou manifestation de ses convictions religieuses, politiques ou philosophiques.\n"
                  "Lorsqu'il n'est pas en service, il s'exprime librement dans les limites imposées par le devoir de réserve et par la loyauté à l'égard des institutions de la République.\n\n"
                  "Dans les mêmes limites, les représentants du personnel bénéficient, dans le cadre de leur mandat, d'une plus grande liberté d'expression.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-29",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Il s'agit de l'élémentaire et nécessaire respect que doit le policier à l'institution, ainsi qu'au service public de la police et de la justice, au service desquels il est placé.\n\n"
                "Ce devoir peut être rapproché de celui dû à la protection du crédit ou du renom de la police nationale. Il s'en distingue car le fait générateur est directement constitutif du manquement, "
                "alors que l'atteinte à l'honneur est le plus souvent constituée par le biais de la violation d'un autre manquement (probité, ...).\n\n"
                "Exemples de comportements fautifs:\n"
                "• tenue de propos irrévérencieux sur une autorité hiérarchique par voie de presse ou tout autre moyen (réseaux sociaux...);\n"
                "• publication/diffusion, sous quelque forme que ce soit, d'écrits ou de paroles irrespectueux sur la police/les fonctionnaires de police/les institutions (État, Défenseur des droits...);\n"
                "• diffusion de commentaires publics sur des décisions de justice;\n"
                "• affichage sur son lieu de travail de documents ou d'affiches faisant état d'une idéologie, tendance religieuse, politique, etc.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-30
          _ConditionCard(
            title: "Article R. 434-30 — Disponibilité",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-30"),
                _normalSpan(" — Disponibilité\n\n"),
                _normalSpan(
                  "Le policier est disponible à tout moment pour les nécessités du service.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-30",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Obligations permettant à la hiérarchie de rappeler un agent ou de vérifier qu'il se trouve dans une position régulière.\n\n"
                "Cette obligation impose de pouvoir joindre et, partant, de pouvoir rappeler au service un agent. Une indisponibilité reprochée peut résulter d'une simple négligence ou peut être organisée (cumul d'activité,...)\n\n"
                "Exemple de comportements fautifs :\n"
                "• communication d'un numéro de téléphone erroné/absence de signalement d'un changement de numéro de téléphone/éteindre son téléphone afin de ne pouvoir être rappelé au service;\n"
                "• changement de résidence sans information de sa hiérarchie ;\n"
                "• absence, sans raison légitime, au moment d'un contrôle administratif.",
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Gendarmerie Nationale
          _ConditionCard(
            title:
                "CHAPITRE II — Dispositions propres à la gendarmerie nationale",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [_Paragraph("Articles R. 434-31 à R. 434-33")],
          ),
          const SizedBox(height: 14),

          // R. 434-31
          _ConditionCard(
            title:
                "Article R. 434-31 — État de militaire / service de la Nation",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-31"),
                _normalSpan(
                  " — L'état de militaire, le service de la Nation et le devoir de mémoire\n\n",
                ),
                _normalSpan(
                  "Le militaire de la gendarmerie obéit aux règles militaires et adhère aux valeurs inhérentes à son statut. "
                  "L'état militaire exige en toute circonstance esprit de sacrifice, pouvant aller jusqu'au sacrifice suprême, discipline, disponibilité, loyalisme et neutralité.\n\n"
                  "Les devoirs qu'il comporte et les sujétions qu'il implique méritent le respect des citoyens et la considération de la Nation.\n\n"
                  "Les honneurs militaires sont rendus aux militaires de la gendarmerie nationale victimes du devoir ou du seul fait de porter l'uniforme. Leur mémoire est honorée.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-31",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ce premier article spécifique à la gendarmerie nationale vise à rappeler les valeurs attachées au statut militaire et qui le caractérise.\n"
                "L'article reprend ainsi largement les termes employés dans le code de la défense (art L 4111-1).\n\n"
                "Exemples de comportements fautifs :\n"
                "• refus de prendre en compte une personne se présentant à l'unité peu avant la fermeture administrative des locaux de service et/renvoi de celle-ci vers l'unité d'astreinte.;\n"
                "• méconnaissance de la lettre et de l'esprit de la mission confiée;\n"
                "• exécution partielle d'une mission, sans s'assurer de sa fin effective auprès de sa hiérarchie.\n\n"
                "Exemples de comportements positifs :\n"
                "• se manifester immédiatement et d'initiative auprès du commandement lorsqu'une situation particulière requiert sa présence et ce, quel que soit sa position au regard du service (ressource complémentaire ou différée);\n"
                "• faire preuve d'endurance et de rusticité si les circonstances l'imposent;\n"
                "• respecter les usages de la bienséance militaire: salut, présentation, correspondances, ...",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-32
          _ConditionCard(
            title: "Article R. 434-32 — Devoir de réserve (Gendarmerie)",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-32"),
                _normalSpan(" — Devoir de réserve\n\n"),
                _normalSpan(
                  "Les militaires de la gendarmerie ne peuvent exprimer des opinions ou croyances, notamment philosophiques, religieuses ou politiques qu'en dehors du service "
                  "et avec la réserve exigée par l'état militaire, conformément aux dispositions du code de la défense.\n\n"
                  "Dans le cadre du dialogue interne mis en place au sein de l'institution militaire, ils disposent de différentes instances de représentation et de concertation "
                  "dans lesquelles les membres s'expriment librement.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-32",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L'obligation de neutralité des militaires se traduit notamment par l'observation d'un strict devoir de réserve.\n\n"
                "Pour autant, les militaires de la gendarmerie, à l'instar de leurs camarades des autres armées, trouvent à s'exprimer au niveau national à travers des instances de concertation comme CFMG et le CSFM. "
                "Localement, un dialogue interne est animé entre la hiérarchie et les membres des instances de représentation.\n\n"
                "Exemple de comportement fautif :\n"
                "• exprimer ses convictions politiques, religieuses, philosophiques en faisant état de son statut militaire de manière explicite.\n\n"
                "Exemple de comportement positif :\n"
                "• favoriser le dialogue interne au sein de son unité en y apportant une participation constructive.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // R. 434-33
          _ConditionCard(
            title: "Article R. 434-33 — Autres textes afférents",
            cardColor: cardArticle,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("Article R. 434-33"),
                _normalSpan(
                  " — Autres textes afférents à la déontologie des militaires de la gendarmerie nationale\n\n",
                ),
                _normalSpan(
                  "Le gendarme, soldat de la loi, est soumis aux devoirs et sujétions prévus par le statut général des militaires défini par le code de la défense, "
                  "ainsi qu'aux sujétions spécifiques liées aux conditions de l'exercice du métier de militaire de la gendarmerie.",
                ),
              ]),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: "Commentaire — R. 434-33",
            cardColor: cardComment,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La partie spécifique dévolue à la gendarmerie nationale se clôt sur les sujétions spécifiques incombant aux militaires de la gendarmerie. "
                "Parmi celles-ci figure évidemment l'obligation d'occuper le logement concédé par absolue nécessité de service qui permet à la gendarmerie nationale d'assurer "
                "un niveau de disponibilité permanente et de couverture sur l'ensemble du territoire national. Cette obligation statutaire conditionne également la bonne exécution du service "
                "et la conception même de ce dernier.",
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
