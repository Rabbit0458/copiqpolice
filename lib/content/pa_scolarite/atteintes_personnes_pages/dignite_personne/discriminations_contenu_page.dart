import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDiscriminationsPage extends StatelessWidget {
  const PaDiscriminationsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/dignite_personne/discriminations';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

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
          "Dignité de la personne",
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
            "Les discriminations",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (propre, sans répétitions)
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Toute distinction opérée entre les personnes (physiques ou morales) fondée sur un motif "
                "protégé par la loi constitue une discrimination et, dans les cas prévus, une infraction.",
              ),
              SizedBox(height: 10),
              _SubTitle("Motifs protégés (exemples majeurs)"),
              _Paragraph(
                "Origine, sexe, situation de famille, grossesse, apparence physique, vulnérabilité économique "
                "(apparente ou connue), patronyme, lieu de résidence, état de santé, perte d’autonomie, handicap, "
                "caractéristiques génétiques, mœurs, orientation sexuelle, identité de genre, âge, opinions politiques, "
                "activités syndicales, capacité à s’exprimer dans une langue autre que le français, appartenance ou non "
                "appartenance (réelle ou supposée) à une ethnie, une Nation, une prétendue race ou une religion déterminée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigé) — Articles en rouge
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit la discrimination (personnes physiques et personnes morales).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-1-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : vise la discrimination résultant d’un harcèlement sexuel (subi/refusé) ou du témoignage.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-1-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : vise la discrimination résultant de faits de bizutage (subis/refusés) ou du témoignage.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : incrimine certaines situations précises dans lesquelles il est interdit de procéder à une discrimination.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph.rich([
                TextSpan(
                  text: "Article 225-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " ne vise pas tous les comportements discriminatoires : il cible six situations typiques.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle(
                "A) Refuser la fourniture d’un bien ou d’un service",
              ),
              const _Paragraph(
                "Cela recouvre les conventions portant sur un bien ou un service (vente, location, prêt, assurance, etc.), "
                "sans distinction entre particulier/professionnel ni entre gratuit/onéreux.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les termes « bien » et « service » s’entendent largement : toutes choses susceptibles d’être l’objet d’un droit "
                        "et représentant une valeur pécuniaire ou un avantage — ",
                  ),
                  TextSpan(
                    text: "C.A. Paris, 21 novembre 1974",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: "Exemples jurisprudentiels",
                cardColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFFFFFFF),
                accent: accentGreen,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Refus de vendre un appartement à raison du patronyme — ",
                    ),
                    TextSpan(
                      text: "C.A. Besançon, 27 janvier 2005",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Refus d’accepter des personnes handicapées à bord d’avions — ",
                    ),
                    TextSpan(
                      text: "C.A. Paris, 19 septembre 1994",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Entraver l’exercice normal d’une activité économique",
              ),
              const _Paragraph(
                "Il s’agit de rendre plus difficile une activité économique (production, distribution, consommation), "
                "par des formes variées : dénigrement, pressions, « liste noire », etc. L’activité n’a pas besoin d’être totalement empêchée : "
                "il suffit que les agissements aient pu produire des effets.",
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: "Jurisprudences",
                cardColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFFFFFFF),
                accent: accentGreen,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Entrave : refus d’entretien à une femme journaliste + consigne de refuser tout contact — ",
                    ),
                    TextSpan(
                      text: "C.A. Bordeaux, 20 novembre 1991",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Exigence d’une attestation discriminatoire à un exportateur (transit par certains pays) — ",
                    ),
                    TextSpan(
                      text: "Cass. crim., 09 novembre 2004",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Refuser d’embaucher, sanctionner ou licencier",
              ),
              const _Paragraph(
                "Le refus d’embauche s’entend largement : il peut viser le refus d’entretien, ou le congédiement pendant la période d’essai "
                "(l’embauche n’étant définitive qu’à l’issue de cette période).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le congédiement pendant la période d’essai peut constituer un refus d’embauche — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 14 octobre 1986",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: "Repères",
                cardColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFFFFFFF),
                accent: accentGreen,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Refus de renouvellement d’un CDD lié à l’engagement politique d’un membre de la famille — ",
                    ),
                    TextSpan(
                      text: "Cass. crim., 21 juin 2016",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Refus d’embauche en raison de la « race » alléguée (propos explicites de l’employeur) — ",
                    ),
                    TextSpan(
                      text: "C.A. Paris, 7 juin 2004",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Licenciement discriminatoire à raison de l’origine (même si ce n’est pas l’unique motif) — ",
                    ),
                    TextSpan(
                      text: "C.A. Paris, 20 mars 1997",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Sanctionner : vise les mesures disciplinaires (avertissement, blâme, mise à pied, rétrogradation, mutation, refus d’avancement, etc.).",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Discrimination syndicale : mise à pied d’une déléguée du personnel à raison de son appartenance — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 23 novembre 2004",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) Subordonner un bien/service à une condition discriminatoire",
              ),
              const _Paragraph(
                "Au lieu de refuser, l’auteur impose une ou plusieurs conditions discriminatoires pour obtenir le bien ou le service.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Prime municipale de naissance subordonnée à une nationalité — ",
                  ),
                  TextSpan(
                    text: "C.A. Aix-en-Provence, 18 juin 2001",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "E) Subordonner une offre d’emploi / stage / formation à une condition discriminatoire",
              ),
              const _Paragraph(
                "La matérialité peut exister avant même toute relation directe avec le candidat : la condition discriminatoire est posée dès l’offre.",
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: "Jurisprudences",
                cardColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFFFFFFF),
                accent: accentGreen,
                titleColor: textMain,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Offre réservée à des confrères musulmans (exclusion des autres) — ",
                    ),
                    TextSpan(
                      text: "T.C. Paris, 19 décembre 1991",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Complicité : diffuser des offres excluant des candidats d’origine nord-africaine — ",
                    ),
                    TextSpan(
                      text: "Cass. crim., 18 juillet 1985",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          "Refus de valider une inscription (voile islamique) — ",
                    ),
                    TextSpan(
                      text: "C.A. Paris, 8 juin 2010",
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "F) Refuser l’accès à certains stages (sécurité sociale)",
              ),
              const _Paragraph(
                "Sont visés notamment les stages d’élèves/étudiants, la formation professionnelle continue, ou des stages d’initiation/complément "
                "en organisme privé/public, lorsque le refus est fondé sur un motif discriminatoire.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("À connaître : victimes, exceptions, auteur"),
              const _Paragraph(
                "Victimes : toute personne physique ou morale peut être victime (et, pour le harcèlement sexuel/bizutage, "
                "les victimes comme les témoins sont protégés).",
              ),
              const SizedBox(height: 10),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      "Actes commis par un dépositaire de l’autorité publique / mission de service public : ",
                ),
                TextSpan(
                  text: "article 432-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " (référence)."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph.rich([
                TextSpan(
                  text: "Article 225-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " prévoit des exceptions (assurance/risques, inaptitude médicalement constatée, exigence professionnelle essentielle et déterminante, "
                      "certaines différenciations liées au sexe dans l’accès aux biens/services, etc.).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "Conscience de se livrer à des agissements discriminatoires",
              ),
              _Paragraph(
                "Délit intentionnel : il faut établir qu’au moment des faits, l’auteur avait conscience du caractère discriminatoire "
                "de ses agissements. Peu importe l’existence d’une hostilité personnelle.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Un restaurateur ne peut refuser une table à un handicapé en invoquant l’intolérance de sa clientèle — ",
                  ),
                  TextSpan(
                    text: "T.C. Nantes, 01 mars 1990",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-3-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " encadre les « tests de discrimination » : l’infraction peut être constituée même si la demande a été faite pour démontrer le comportement, "
                      "à condition que la preuve soit établie et que les informations fournies ne soient pas fictives/mensongères.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-2 alinéa 8 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Lorsque le refus discriminatoire (1°) est commis dans un lieu accueillant du public ou aux fins d’en interdire l’accès.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Forme simple : "),
                TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 225-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Forme aggravée (lieu accueillant du public / interdiction d’accès) : ",
                ),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 225-2 alinéa 8 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 225-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : amende au quintuple + sanctions/réparations + peines complémentaires (notamment 2°, 3°, 4°, 5°, 8° et 9° de ",
                ),
                TextSpan(
                  text: "l’article 131-39 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (aide/assistance, provocation ou instructions + intention de s’associer).",
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
