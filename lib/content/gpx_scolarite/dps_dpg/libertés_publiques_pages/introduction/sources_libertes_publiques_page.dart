import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SourcesLibertesPubliquesPage extends StatelessWidget {
  const SourcesLibertesPubliquesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/libertés_publiques_pages/introduction/sources_libertes_publiques';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardHist = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDecl1789 = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPost = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardCurrent = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardIntl = isDark
        ? const Color(0xFF20272A)
        : const Color(0xFFEFFBFF);
    final Color cardHierarchy = isDark
        ? const Color(0xFF262626)
        : const Color(0xFFF7F7F7);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentCyan = isDark
        ? const Color(0xFF4DD0E1)
        : const Color(0xFF00838F);

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
          "Libertés publiques",
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
            "Les sources des libertés publiques",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ===================== INTRO =====================
          _ConditionCard(
            title: "Repère",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Aujourd’hui, nous bénéficions en France d’un ensemble de droits et libertés acquis tout au long de l’histoire. "
                "Ces libertés proviennent de sources philosophiques, juridiques, constitutionnelles et internationales.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 : HISTOIRE =====================
          _ConditionCard(
            title: "Chapitre 1 — Évolution historique jusqu’en 1958",
            cardColor: cardHist,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _SubTitle("1.1 — Apports antérieurs à 1789"),
              const _Paragraph(
                "Avant la Déclaration de 1789, des courants d’idées et des textes fondamentaux ont posé les premières garanties contre l’arbitraire.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("A) Sources philosophiques"),
              const _Paragraph("1) Pensée chrétienne"),
              const SizedBox(height: 6),
              const _IntroBullet(
                text: "Affirmation de l’égalité de tous les hommes.",
              ),
              const _IntroBullet(
                text: "Valeur et respect de la personne humaine.",
              ),
              const _IntroBullet(
                text:
                    "Limitation du pouvoir de l’État et légitimation de la résistance à l’oppression.",
              ),
              const SizedBox(height: 10),

              const _Paragraph("2) Droit naturel & Contrat social"),
              const SizedBox(height: 6),
              const _IntroBullet(
                text:
                    "Idée antique : droits naturels, universels et intangibles, visant une société idéale.",
              ),
              const _IntroBullet(
                text:
                    "Contrat social (Jean-Jacques Rousseau) : les hommes quittent l’état de nature pour fonder une société civile.",
              ),
              const _IntroBullet(
                text:
                    "Par convention : abandon d’une partie de la liberté initiale contre davantage de sécurité.",
              ),
              const SizedBox(height: 10),

              const _Paragraph("3) Philosophie des Lumières (XVIIIe siècle)"),
              const SizedBox(height: 6),
              const _IntroBullet(text: "Influence des systèmes anglo-saxons."),
              const _IntroBullet(
                text:
                    "Esprit de résistance au pouvoir (notamment dans les Parlements).",
              ),
              const _IntroBullet(
                text:
                    "Physiocrates : respect de l’individu et de ses droits ; propriété comme base de la société.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Sources juridiques"),
              const _Paragraph("1) Pactes anglais"),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Grande Charte (Magna Carta, 1215) : limitation de la toute-puissance royale et garantie minimale de libertés.",
              ),
              const _BulletPoint(
                text:
                    "Pétition des droits (1627) : revendications renforcées ; monarchie constitutionnelle limitée par le droit.",
              ),
              const _BulletPoint(
                text:
                    "Habeas Corpus (1679) : garantie de la sûreté ; intervention du juge contre une détention arbitraire.",
              ),
              const _BulletPoint(
                text:
                    "Bill of Rights (1689) : garantie des libertés publiques du Parlement.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Ces textes proclament des principes de libertés et mettent en place des garanties contre l’arbitraire de l’État.",
              ),
              const SizedBox(height: 12),

              const _Paragraph("2) Déclarations américaines"),
              const SizedBox(height: 6),
              const _Paragraph(
                "Les premières déclarations de droits rédigées sous influence anglaise. "
                "La plus célèbre : déclaration d’indépendance du 4 juillet 1776, souvent décrite comme un « hymne à l’individualisme optimiste ».",
              ),
              const SizedBox(height: 8),
              const _IntroBullet(text: "Notion d’égalité."),
              const _IntroBullet(
                text: "Droits inaliénables : liberté, vie, bonheur, honneur.",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text: "Le texte de référence en France reste la ",
                  ),
                  TextSpan(
                    text:
                        "Déclaration des Droits de l’Homme et du Citoyen de 1789",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== DDHC 1789 =====================
          _ConditionCard(
            title:
                "1.2 — Déclaration des Droits de l’Homme et du Citoyen (1789)",
            cardColor: cardDecl1789,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Déclaration du 26 août 1789",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : élaborée par l’Assemblée nationale constituante, issue de la Révolution.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les constituants posent les bases d’une société fondée sur la liberté et l’égalité. "
                "La Déclaration impose l’existence d’une puissance publique (pour garantir les libertés), la démocratie et la séparation des pouvoirs.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("1.2.1 — Caractéristiques"),
              const _Paragraph("A) Individualisme"),
              const SizedBox(height: 6),
              const _Paragraph(
                "Inspirée par le droit naturel, la Déclaration vise d’abord l’homme en tant qu’individu : "
                "il est titulaire des droits. Elle ne proclame pas de droits collectifs (association, grève, réunion), "
                "qui seront reconnus plus tard.",
              ),
              const SizedBox(height: 10),

              const _Paragraph("B) Aspect métaphysique"),
              const SizedBox(height: 6),
              const _Paragraph(
                "Reconnaissance solennelle de droits naturels, inaliénables et sacrés.",
              ),
              const SizedBox(height: 10),

              const _Paragraph("C) Universalité"),
              const SizedBox(height: 6),
              const _Paragraph(
                "Les droits proclamés sont ceux de l’homme et du citoyen : ils valent pour tout être humain, "
                "et non pour les seuls citoyens français de 1789.",
              ),
              const SizedBox(height: 10),

              const _Paragraph("D) Caractère abstrait"),
              const SizedBox(height: 6),
              const _Paragraph(
                "La Déclaration pose de grands principes (liberté, égalité, sûreté, propriété) mais ne détaille pas "
                "concrètement les moyens d’exercice : l’aménagement viendra par les lois et les régimes politiques.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("1.2.2 — Contenu"),
              const _Paragraph("A) Droits de l’Homme"),
              const SizedBox(height: 8),

              _ConditionCard(
                title: "Les 4 piliers",
                cardColor: isDark
                    ? const Color(0xFF1B1F25)
                    : const Color(0xFFFFFFFF),
                accent: accentBlue,
                titleColor: textMain,
                children: [
                  const _BulletPoint(
                    text:
                        "Égalité : condition première de la liberté ; égalité devant la loi, devant les charges, égal accès aux emplois publics…",
                  ),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        "Liberté : « pouvoir faire tout ce qui ne nuit pas à autrui » ; principe selon lequel « tout ce qui n’est pas défendu par la loi ne peut être empêché ».",
                  ),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        "Propriété : droit inviolable et sacré, mais pouvant être limité/supprimé si nécessité publique + juste et préalable indemnité (ex. expropriation, nationalisations).",
                  ),
                  const SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        "Résistance à l’oppression : droit et devoir lorsque le pouvoir n’est plus conforme au contrat social.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    const TextSpan(text: "Fondement : "),
                    TextSpan(
                      text: "Art. 2 de la DDHC",
                      style: const TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(
                      text:
                          " (la résistance à l’oppression sera précisée dans la Déclaration montagnarde de 1793).",
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 12),

              const _Paragraph("B) Droits du Citoyen"),
              const SizedBox(height: 6),
              const _Paragraph(
                "Droits politiques : concourir personnellement ou par représentants à la formation de la loi, "
                "consentir à l’impôt, égalité devant les charges publiques, respect de la légalité, etc.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== POST 1789 =====================
          _ConditionCard(
            title: "1.3 — Évolution postérieure (1789 → 1958)",
            cardColor: cardPost,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Après 1789, la reconnaissance des libertés publiques se poursuit, mais varie selon les régimes politiques.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Repères chronologiques"),
              const _BulletPoint(
                text:
                    "Constituante (1789–1791) : liberté quasi totale de réunion et d’expression (journaux, clubs).",
              ),
              const _BulletPoint(
                text:
                    "Projet girondin (1793) : nouveaux droits (instruction, secours publics), droits économiques.",
              ),
              const _BulletPoint(
                text:
                    "Constitution montagnarde (1793–1794) : suffrage universel direct, garanties renforcées (application brève).",
              ),
              const _BulletPoint(
                text:
                    "Directoire (1795) : propriété comme fondement ; censure et restrictions pratiques.",
              ),
              const _BulletPoint(
                text:
                    "Consulat & Empire (1799–1815) : période sombre ; commissions « façades », décret de 1810 et prisons d’État.",
              ),
              const _BulletPoint(
                text:
                    "Chartes de 1814 et 1830 : progression sur certaines libertés (presse, culte), mais suffrage censitaire.",
              ),
              const _BulletPoint(
                text:
                    "Constitution de 1848 : suffrage universel, libertés réaffirmées puis lois restrictives (clubs, presse, suffrage).",
              ),
              const _BulletPoint(
                text:
                    "Second Empire : autorisations préalables (presse, réunions), interdictions d’associations ; assouplissement après 1860.",
              ),
              const _BulletPoint(
                text:
                    "IIIe République : grandes lois libérales (réunion, presse, association).",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Lois majeures : "),
                  TextSpan(
                    text: "loi du 30 juin 1881 (liberté de réunion)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "loi du 29 juillet 1881 (liberté de la presse)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "loi du 1er juillet 1901 (liberté d’association)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("Preambule de 1946 (IVe République)"),
              const _Paragraph(
                "Réaffirme les droits hérités de 1789 et garantit de nouveaux droits sociaux : égalité politique homme/femme, droit d’asile, "
                "droits des travailleurs (discussion collective, participation), droit à l’emploi, droit syndical, droit à l’instruction et formation.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Droit de grève : "),
                TextSpan(
                  text:
                      "« s’exerce dans le cadre des lois qui le réglementent »",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 : SOURCES ACTUELLES =====================
          _ConditionCard(
            title: "Chapitre 2 — Sources actuelles des libertés publiques",
            cardColor: cardCurrent,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("2.1 — Préambule de la Constitution de 1958"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Source principale : le préambule de la Constitution du 4 octobre 1958 (Ve République) se réfère explicitement à ",
                ),
                TextSpan(
                  text: "la DDHC de 1789",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", au "),
                TextSpan(
                  text: "préambule de 1946",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et à la "),
                TextSpan(
                  text: "Charte de l’environnement de 2004",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La Constitution de 1958 reprend l’évolution des libertés : droits individuels, droits sociaux et économiques, et leur protection.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Droits modernes complétant le socle"),
              _IntroBullet(
                text:
                    "Droit au respect de la vie privée (loi du 17 juillet 1970).",
              ),
              _IntroBullet(text: "Informatique et libertés (6 janvier 1978)."),
              _IntroBullet(
                text:
                    "Droit d’accès aux documents administratifs (11 juillet 1979).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== TEXTES INTERNATIONAUX =====================
          _ConditionCard(
            title: "2.2 — Textes internationaux",
            cardColor: cardIntl,
            accent: accentCyan,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "L’internationalisation des droits de l’homme est liée aux événements guerriers (Société des Nations après 1918, ONU après 1945). "
                "Progressivement, des textes protecteurs ont été adoptés : on parle de droit des conflits armés et de protection internationale.",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "2.2.1 — Droit international humanitaire (conflits armés)",
              ),
              const _BulletPoint(
                text:
                    "Droit de La Haye (1899–1907) : droits/devoirs des belligérants et limitation des moyens (ex. interdiction de certains gaz).",
              ),
              const _BulletPoint(
                text:
                    "Droit de Genève (12 août 1949) : protection des blessés/malades, prisonniers de guerre, populations civiles.",
              ),
              const _BulletPoint(
                text:
                    "Protocoles additionnels de 1977 : adaptation aux conflits modernes (guérillas, décolonisation, guerres civiles, terrorisme).",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "2.2.2 — Déclaration universelle des droits de l’homme",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Adoptée le "),
                TextSpan(
                  text: "10 décembre 1948 (ONU)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : objectif de respect universel et effectif des droits de l’homme et libertés fondamentales.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Limite : textes souvent non contraignants (recommandations), du fait de la souveraineté des États. "
                "Mais elle proclame de nombreux droits : personnels, politiques, économiques et sociaux.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Textes notables : "),
                  TextSpan(
                    text: "prévention du génocide (9/12/1948)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text:
                        "imprescriptibilité crimes de guerre/crimes contre l’humanité (26/11/1968)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "texte contre la torture (10/12/1984)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "statut des réfugiés (28/07/1951)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "lutte discrimination raciale (1965)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "2.2.3 — Convention européenne des droits de l’homme",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Signée le "),
                TextSpan(
                  text: "4 novembre 1950",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", ratifiée par la France en "),
                TextSpan(
                  text: "1974",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : mécanismes effectifs de protection en cas de violation.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Réforme majeure : "),
                TextSpan(
                  text: "protocole n°11 du 11 mai 1994",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (entrée en vigueur 1er novembre 1998) : suppression de la Commission et création d’une Cour permanente unique (CEDH).",
                ),
              ]),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Exemples de condamnations : "),
                  TextSpan(
                    text: "26 avril 1990, Clerc (lenteur)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "24 avril 1990, Kruslin et Huvig (écoutes)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; "),
                  TextSpan(
                    text: "28 juillet 1999, Selmouni (torture)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "À noter : compétence concurrente de la CJUE sur le respect des droits fondamentaux "
                "(ex. condamnation de la France en 1988 concernant des quotas femmes dans la police ; décret du 03 mars 1992 supprimant ces quotas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 3 : HIÉRARCHIE =====================
          _ConditionCard(
            title:
                "Chapitre 3 — Valeur juridique des sources (hiérarchie des normes)",
            cardColor: cardHierarchy,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La protection d’une liberté dépend du rang du texte qui la proclame dans la hiérarchie des normes : "
                "plus le texte est élevé, plus la liberté est protégée (toute règle doit respecter la norme supérieure).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Hiérarchie (ordre décroissant)"),
              const _BulletPoint(
                text:
                    "Constitution : texte + révisions + préambule (DDHC 1789, Préambule 1946, PFRLR).",
              ),
              const _BulletPoint(text: "Engagements internationaux."),
              const _BulletPoint(text: "Lois et textes de valeur législative."),
              const _BulletPoint(
                text:
                    "Principes généraux du droit (jurisprudence administrative).",
              ),
              const _BulletPoint(text: "Règlements."),
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
