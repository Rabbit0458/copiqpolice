import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaGPXSchoolEtendueApplicationLoisPage extends StatelessWidget {
  const PaGPXSchoolEtendueApplicationLoisPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/loi_penale/etendue_application_lois';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .72);

    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color accent = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

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
          "Étendue d’application des lois",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          Text(
            "Étendue d’application des lois",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Règles d’application des lois pénales dans le temps et dans l’espace : "
            "à partir de quand une loi s’applique, et sur quel territoire.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 16),

          // ===================== INTRO =====================
          _ConditionCard(
            title: "ÉTENDUE D’APPLICATION DES LOIS",
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Les "),
                _lawRed(context, "articles 112-1 et 113-2 du Code pénal"),
                const TextSpan(
                  text:
                      " fixent les règles relatives à l’application des lois pénales dans le temps et dans l’espace.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il est nécessaire de savoir à partir de quel moment une loi nouvelle va s’appliquer et sur quel territoire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 =====================
          _ConditionCard(
            title: "CHAPITRE 1 — APPLICATION DE LA LOI PÉNALE DANS LE TEMPS",
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _Paragraph(
                "L’élément légal de l’infraction implique nécessairement qu’une loi pénale nouvelle ne peut s’appliquer à des faits commis avant son entrée en vigueur.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Ce principe résulte de "),
                _lawRed(context, "l’article 112-1 du Code pénal"),
                const TextSpan(
                  text:
                      " qui dispose : « Sont seuls punissables les faits constitutifs d’une infraction à la date à laquelle ils ont été commis ».",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La règle est donc la non-rétroactivité de la loi pénale nouvelle. "
                "Mais un problème va se poser pour des actes commis sous l’empire d’une loi déterminée "
                "et non encore jugés au moment de l’entrée en vigueur d’une loi nouvelle pouvant s’y appliquer.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La solution retenue sera différente selon la nature des lois.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("1.1 — LES LOIS PÉNALES DE FOND"),
              const _Paragraph(
                "Elles déterminent les infractions et fixent les conditions dans lesquelles elles peuvent être sanctionnées.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("1.1.1 — Principe"),
              const _Paragraph(
                "C’est celui de la non-rétroactivité de la loi pénale nouvelle. "
                "C’est une garantie de la liberté individuelle en ce sens que « la loi doit avertir avant de frapper ».",
              ),

              const SizedBox(height: 10),
              const _SubTitle("1.1.1.1 — Application du principe"),
              const _Paragraph(
                "Les lois nouvelles plus sévères ne rétroagissent pas. Le principe entraîne deux conséquences :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Un fait n’est punissable que s’il était constitutif d’une infraction au moment de sa commission.",
              ),
              const _BulletPoint(
                text:
                    "Ne peuvent être prononcées que les peines prévues par la loi à cette date (exemple : la loi du 26 juillet 1873 ayant créé le délit de filouterie d’aliments ne peut s’appliquer à des faits commis avant son entrée en vigueur).",
              ),
              const SizedBox(height: 8),
              const _Paragraph("Les lois nouvelles plus sévères sont par exemple :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Une loi qui crée une circonstance aggravante ou une peine complémentaire.",
              ),
              const _BulletPoint(
                text:
                    "Une loi qui aggrave la peine applicable à une infraction existante.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("1.1.1.2 — Atténuation du principe"),
              const _Paragraph(
                "Une loi nouvelle plus sévère peut s’appliquer à des faits commis avant son entrée en vigueur. "
                "C’est le cas pour les lois interprétatives qui précisent le sens d’une loi antérieure : "
                "elles font corps avec la loi interprétée et s’appliquent donc à des faits antérieurs.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("1.1.2 — Exception : rétroactivité in mitius"),
              _Paragraph.rich([
                _lawRed(context, "L’article 112-1 alinéa 3 du Code pénal"),
                const TextSpan(
                  text:
                      " dispose que les lois nouvelles plus douces s’appliquent aux faits commis avant leur entrée en vigueur, et non encore jugés définitivement.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Une infraction est réputée jugée définitivement lorsque toutes les voies de recours sont épuisées.",
              ),
              const SizedBox(height: 10),
              const _Paragraph("Les lois nouvelles plus douces sont par exemple :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Une loi qui supprime une incrimination (exemple : loi du 11/07/1975 supprimant l’adultère).",
              ),
              const _BulletPoint(
                text:
                    "Une loi qui supprime une circonstance aggravante ou qui crée un fait justificatif nouveau.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "La loi nouvelle peut prévoir expressément qu’elle ne rétroagira pas.",
              ),

              const SizedBox(height: 12),
              const _SubTitle(
                "1.1.3 — Cas particulier : dispositions plus douces et plus sévères",
              ),
              const _Paragraph(
                "Exemple : une loi qui élève le maximum d’une peine et en abaisse le minimum. "
                "La loi nouvelle est, dans ce cas, plus sévère, car elle expose le délinquant à une peine plus importante que sous le coup de la loi ancienne.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Comment déterminer le caractère plus doux ou plus sévère d’une telle loi ?",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Exemple : la loi Bérenger du 26 mars 1891 instituant le sursis à exécution de certaines peines et créant la petite récidive correctionnelle. "
                "Elle a été appliquée distributivement : la partie relative au sursis (plus douce) a rétroagi, et la partie concernant la récidive a été appliquée à partir de la promulgation de la loi.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Un problème se pose lorsque les dispositions de la loi ne sont pas divisibles. "
                "La jurisprudence préconise de ne prendre en compte que la disposition principale : si elle est plus douce, la loi rétroagira.",
              ),

              const SizedBox(height: 14),
              const _SubTitle("1.2 — LES LOIS PÉNALES DE FORME"),
              const _Paragraph(
                "Ce sont les lois relatives à la constatation et à la poursuite des infractions, à la compétence et à la procédure.",
              ),

              const SizedBox(height: 10),
              const _SubTitle("1.2.1 — Principe"),
              _Paragraph.rich([
                _lawRed(context, "L’article 112-2 du Code pénal"),
                const TextSpan(
                  text:
                      " énonce que les lois pénales de forme s’appliquent immédiatement, même aux faits commis avant leur entrée en vigueur.",
                ),
              ]),

              const SizedBox(height: 10),
              const _SubTitle("1.2.2 — Exceptions"),
              const _Paragraph(
                "La loi nouvelle de forme ne s’appliquera pas immédiatement s’il existe, au profit du délinquant, un droit acquis.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Ce principe est consacré par "),
                _lawRed(context, "l’article 112-3 du Code pénal"),
                const TextSpan(
                  text:
                      " : les lois nouvelles relatives aux voies de recours s’appliquent aux décisions prononcées après leur entrée en vigueur.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawRed(context, "L’article 112-4 du Code pénal"),
                const TextSpan(
                  text:
                      " prévoit qu’une loi nouvelle ne peut entraîner la nullité d’actes régulièrement accomplis sous l’empire d’une loi antérieure.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les lois qui modifient le régime d’exécution des peines et créent des mesures de sûreté s’appliquent immédiatement, sauf si la loi est plus sévère.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("1.2.3 — Lois relatives à la prescription"),
              _Paragraph.rich([
                _lawRed(context, "L’article 112-2 (4°) du Code pénal"),
                const TextSpan(
                  text:
                      " indique qu’une loi nouvelle relative à la prescription de l’action publique ou de la peine s’applique immédiatement :",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "La prescription ne doit pas être encore acquise.",
              ),
              const _BulletPoint(
                text:
                    "Elle est applicable même si la loi est défavorable à l’intéressé.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 =====================
          _ConditionCard(
            title: "CHAPITRE 2 — APPLICATION DE LA LOI PÉNALE DANS L’ESPACE",
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              const _SubTitle("Principe de territorialité de la loi française"),
              const _Paragraph(
                "Lorsqu’un crime est commis en France par un Français et que la victime est elle-même française, le droit français peut seul s’appliquer.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawRed(context, "L’article 113-2 du Code pénal"),
                const TextSpan(
                  text:
                      " dispose que la loi pénale française est applicable aux infractions commises sur le territoire de la République.",
                ),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("2.1 — La notion de territoire"),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "L’espace terrestre : la Métropole, les D.O.M. et les C.O.M.",
              ),
              const _BulletPoint(
                text:
                    "L’espace aérien : zone située à la perpendiculaire au-dessus des territoires terrestres et de l’espace maritime, jusqu’au ciel.",
              ),
              const _BulletPoint(
                text:
                    "L’espace maritime : mer territoriale (12 milles marins à partir des côtes).",
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les navires et aéronefs : la loi pénale française est applicable aux infractions commises à bord ou à l’encontre des navires battant pavillon français, et des aéronefs immatriculés en France, ou des personnes se trouvant à bord en quelque lieu qu’ils se trouvent. Les juridictions territorialement compétentes sont celles, non seulement de l’atterrissage d’un aéronef, mais également celles du lieu de décollage, de destination ou d’atterrissage (",
                ),
                _lawRed(context, "Article 693 du Code de procédure pénale"),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),
              const _SubTitle("2.2 — Cas des infractions commises en France"),
              const _Paragraph(
                "La loi française s’applique dès lors qu’un des faits constitutifs de l’infraction a été commis en France.",
              ),
              const SizedBox(height: 8),
              const _NotaBox(
                title: "EXEMPLE",
                bodySpans: [
                  TextSpan(
                    text:
                        "Pour l’abus de confiance lorsque la chose est remise en France, et que le détournement a lieu à l’étranger.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Exception : l’immunité pénale existe pour les chefs d’État étrangers séjournant en France et pour les agents diplomatiques accrédités.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawRed(context, "L’article 113-5 du Code pénal"),
                const TextSpan(
                  text:
                      " permet d’appliquer la loi française à quiconque s’est rendu coupable en France, comme complice d’un crime ou d’un délit commis à l’étranger.",
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph("Pour que le complice soit punissable, il faut :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Que le fait accompli soit puni à la fois par la loi française et par la loi étrangère : règle de la double incrimination.",
              ),
              const _BulletPoint(
                text:
                    "Qu’une décision définitive relative au fait principal ait été rendue par une juridiction étrangère.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Elle est également applicable aux actes de complicité prévus au second alinéa de ",
                ),
                _lawRed(context, "l’article 121-7 du Code pénal"),
                const TextSpan(
                  text:
                      " commis sur le territoire de la République et concernant, lorsqu’ils sont commis à l’étranger, les crimes prévus au livre II (génocide, crimes contre l’humanité, crimes contre l’espèce humaine, assassinat, meurtre, empoisonnement, tortures et actes de barbarie, viol…).",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "La provocation doit être accompagnée de don, promesse, menace, ordre, abus d’autorité ou de pouvoir, et suivie d’effets.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il n’est pas nécessaire de s’assurer que des poursuites pénales engagées par les autorités étrangères aient abouti à une condamnation définitive.",
              ),

              const SizedBox(height: 12),
              const _SubTitle("2.3 — Infractions commises hors de France"),
              const _Paragraph(
                "Le principe général est celui de la non-application de la loi française. "
                "Mais les articles 113-6 du Code pénal et suivants apportent de nombreuses exceptions au principe.",
              ),
              const SizedBox(height: 10),
              const _Paragraph("La loi française est donc applicable :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "À tout crime commis par un Français hors de France.",
              ),
              const _BulletPoint(
                text:
                    "À tout délit commis par un Français hors de France, à condition que les faits soient incriminés par le pays où ils ont été commis.",
              ),
              const _BulletPoint(
                text:
                    "À tout crime ainsi qu’à tout délit puni d’emprisonnement commis à l’étranger contre un Français.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Dans ces différents cas, aucune poursuite ne sera engagée si la personne justifie avoir déjà fait l’objet d’un jugement définitif à l’étranger, si elle a déjà subi la peine à l’étranger ou si cette dernière est prescrite.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Pour certains délits, la poursuite ne peut être exercée qu’à la requête du ministère public ; elle doit être précédée d’une plainte de la victime, de ses ayants droit ou d’une dénonciation officielle par l’autorité du pays où le fait a été commis (",
                ),
                _lawRed(context, "Article 113-8 du Code pénal"),
                const TextSpan(text: "). "),
                const TextSpan(
                  text:
                      "La plainte ou la dénonciation n’est pas nécessaire lorsque la poursuite est exercée devant une juridiction pénale ayant une compétence territoriale concurrente et spécialisée s’étendant sur le ressort de plusieurs tribunaux judiciaires ou sur l’ensemble du territoire (",
                ),
                _lawRed(context, "Article 113-8-1 du Code pénal"),
                const TextSpan(text: ")."),
              ]),

              const SizedBox(height: 12),
              const _Paragraph("Autres exceptions listées :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Crime ou délit puni d’au moins cinq ans d’emprisonnement commis hors de France par un étranger dont l’extradition a été refusée à l’État requérant par les autorités françaises, dans les cas prévus.",
              ),
              const _BulletPoint(
                text:
                    "Agression sexuelle sur mineur, corruption de mineur, infractions liées à la pornographie et aux messages violents à l’égard des mineurs, atteinte sexuelle sans violence sur mineur : poursuites possibles sans plainte (Article 222-22 du Code pénal).",
              ),
              const _BulletPoint(
                text:
                    "Délit de proxénétisme à l’égard d’un mineur : poursuites possibles sans plainte (Article 225-11-2 du Code pénal).",
              ),
              const _BulletPoint(
                text:
                    "Crimes et délits de violence ayant entraîné la mort sans intention de la donner, une mutilation, une infirmité permanente ou une incapacité totale de travail de plus de 8 jours sur un mineur : poursuites possibles sans plainte (Article 222-16-2 du Code pénal).",
              ),
              const _BulletPoint(
                text:
                    "Crimes et délits qualifiés d’atteintes aux intérêts fondamentaux de la Nation.",
              ),
              const _BulletPoint(
                text:
                    "Falsification et contrefaçon du sceau de l’État, des pièces de monnaie, billets de banque ou effets publics.",
              ),
              const _BulletPoint(
                text:
                    "Crimes et délits contre les agents ou locaux diplomatiques ou consulaires.",
              ),
              const _BulletPoint(
                text:
                    "Crimes et délits commis à bord ou à l’encontre d’aéronefs non immatriculés en France, sous certaines conditions (auteur ou victime de nationalité française, atterrissage en France, location sans équipage, etc.).",
              ),
              const _BulletPoint(
                text: "Délit terroriste commis par un Français à l’étranger.",
              ),
              const _BulletPoint(
                text:
                    "Crime et délit terroriste commis à l’étranger par une personne résidant habituellement sur le territoire français (Article 113-13 du Code pénal).",
              ),
              const _BulletPoint(
                text:
                    "Infractions financières portant atteinte au budget de l’Union européenne, listées à l’Article 113-14 du Code pénal (escroquerie, abus de confiance, soustraction/détournement/destruction de biens, corruption, contrebande, import/export frauduleux, blanchiment).",
              ),
              const _BulletPoint(
                text:
                    "Meurtre commis contre une personne en raison de son refus de contracter un mariage ou de conclure une union : (Article 221-4 (10°) du Code pénal).",
              ),
              const _BulletPoint(
                text:
                    "Tortures et actes de barbarie commis pour contraindre à contracter un mariage ou conclure une union, ou en raison du refus : (Article 222-3 (6° bis) du Code pénal).",
              ),
              const _BulletPoint(
                text:
                    "Violences liées à la contrainte au mariage / union (mort sans intention, mutilation/infirmité, incapacité totale de travail > 8 jours, incapacité totale de travail ≤ 8 jours ou sans incapacité totale de travail) : (Articles 222-8, 222-10, 222-12 et 222-13 (6° bis) du Code pénal).",
              ),
              const _BulletPoint(
                text:
                    "Traite des êtres humains commise à l’étranger par un Français : (Articles 225-4-1, 225-4-2 et 225-4-8 du Code pénal).",
              ),
            ],
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }

  /// Texte rouge pour références légales (AUCUN diminutif : Code pénal / Code de procédure pénale, etc.)
  TextSpan _lawRed(BuildContext context, String text) {
    return TextSpan(
      text: text,
      style: GoogleFonts.fustat(
        fontWeight: FontWeight.w900,
        color: const Color(0xFFD32F2F), // rouge lisible
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
