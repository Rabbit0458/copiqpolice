import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaRitesCultesFrancePage extends StatelessWidget {
  const PaRitesCultesFrancePage({super.key});

  static const String routeName = '/pa/institution/laicite/rites_cultes';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardCadre = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCath = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardIslam = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardJuda = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardProt = isDark
        ? const Color(0xFF1E2630)
        : const Color(0xFFF3F6FA);
    final Color cardInfos = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentSteel = isDark
        ? const Color(0xFF90A4AE)
        : const Color(0xFF546E7A);

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
          "Laïcité",
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
            "Les principaux rites et pratiques des cultes en France",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (comme demandé)
          _ConditionCard(
            title: "I — Cadre légal de la laïcité",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Principe constitutionnel — "),
                TextSpan(
                  text: "article 1er de la Constitution du 4 octobre 1958",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " : « La France est une République indivisible, laïque, démocratique et sociale… Elle respecte toutes les croyances. »",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Séparation des Églises et de l’État — "),
                TextSpan(
                  text: "loi du 9 décembre 1905",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                "« La République assure la liberté de conscience. Elle garantit le libre exercice des cultes "
                "sous les seules restrictions édictées ci-après dans l’intérêt de l’ordre public. »",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contexte institutionnel + posture du policier
          _ConditionCard(
            title: "Repères institutionnels & posture professionnelle",
            cardColor: cardCadre,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Rattaché au ministère de l’Intérieur, le bureau central des cultes est l’interlocuteur traditionnel "
                "des institutions religieuses dans leurs relations avec l’État. Il prépare les textes et actes administratifs "
                "relatifs aux associations cultuelles et aux congrégations, et assure l’expertise juridique interministérielle "
                "sur les questions relatives aux cultes, à la liberté religieuse et à la laïcité.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le policier accorde la même attention et le même respect à toute personne et n’établit aucune distinction discriminatoire au sens de ",
                  ),
                  TextSpan(
                    text: "l’article 225-1 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " (voir également "),
                  TextSpan(
                    text: "article R. 434-11 du Code de la sécurité intérieure",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I. Rite catholique romain
          _ConditionCard(
            title: "II — Rite catholique romain",
            cardColor: cardCath,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Écrits sacrés"),
              _BulletPoint(
                text:
                    "Conception chrétienne fondée sur l’Ancien et le Nouveau Testament.",
              ),

              SizedBox(height: 10),

              _SubTitle("Pratiques religieuses"),
              _BulletPoint(
                text:
                    "Prière et messe : lecture et méditation de la Parole de Dieu.",
              ),
              _BulletPoint(
                text:
                    "Confession : démarche de réconciliation avec Dieu et avec l’Église.",
              ),
              _BulletPoint(
                text:
                    "Baptême : marque l’entrée dans l’Église chrétienne ; l’eau est versée sur le front de l’enfant en le nommant.",
              ),

              SizedBox(height: 10),

              _SubTitle("Fêtes religieuses"),
              _BulletPoint(
                text: "Noël, Rameaux, Pâques, Ascension, Pentecôte.",
              ),
              _BulletPoint(text: "Autres : Épiphanie, Assomption, Toussaint."),

              SizedBox(height: 10),

              _SubTitle("Nourriture"),
              _BulletPoint(
                text:
                    "Pas de prescriptions générales. Carême (40 jours avant Pâques) : pénitence, prière, partage, parfois jeûne ou abstinence.",
              ),

              SizedBox(height: 10),

              _SubTitle("Signification de la mort"),
              _Paragraph(
                "Entrée dans la plénitude de la vie nouvelle du Royaume de Dieu. Prière et lecture biblique rappellent l’espérance en la grâce de Dieu.",
              ),

              SizedBox(height: 10),

              _SubTitle("Rites de fin de vie"),
              _BulletPoint(
                text:
                    "Onction des malades : sacrement donné lorsque la personne se sent menacée par la maladie.",
              ),
              _BulletPoint(
                text:
                    "Viatique : eucharistie donnée à un mourant, dernière participation sacramentelle avant l’incorporation définitive au Christ.",
              ),

              SizedBox(height: 10),

              _SubTitle("Funérailles"),
              _BulletPoint(
                text:
                    "Lorsque possible : respect d’environ trois jours de veille avant l’inhumation.",
              ),
              _BulletPoint(
                text:
                    "Pendant l’office : fleurs, bougies, prières (dimension spirituelle : illumination et éclosion de l’âme).",
              ),

              SizedBox(height: 10),

              _SubTitle("Autopsie"),
              _BulletPoint(text: "Pas d’obstacle doctrinal."),
            ],
          ),

          const SizedBox(height: 14),

          // II. Rite musulman
          _ConditionCard(
            title: "III — Rite musulman",
            cardColor: cardIslam,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Branches principales"),
              _BulletPoint(text: "Sunnisme (majoritaire) et chiisme."),

              SizedBox(height: 10),

              _SubTitle("Écrits sacrés & organisation"),
              _BulletPoint(text: "Coran : transcription de la pensée divine."),
              _BulletPoint(
                text:
                    "Absence de clergé/hiérarchie : tout musulman peut diriger la prière (imam).",
              ),

              SizedBox(height: 10),

              _SubTitle("Les cinq piliers de l’Islam"),
              _BulletPoint(
                text:
                    "Profession de foi (chahada) : « Il n’y a pas d’autre divinité que Dieu (Allah) ; Mahomet est son prophète. »",
              ),
              _BulletPoint(
                text:
                    "Prière (salat) : cinq fois par jour, tournée vers l’Orient (direction de La Mecque).",
              ),
              _BulletPoint(text: "Aumône (zakat)."),
              _BulletPoint(text: "Jeûne du Ramadan."),
              _BulletPoint(
                text:
                    "Pèlerinage à La Mecque (hajj) : au moins une fois si possible.",
              ),

              SizedBox(height: 10),

              _SubTitle("Fêtes & saisons"),
              _BulletPoint(
                text:
                    "1er Muharram, Achoura, Mouloud (naissance du prophète), Ramadan, Nuit du Destin (Lailat-Al-Qadr), Aïd-El-Fitr, Aïd el-Kébir.",
              ),

              SizedBox(height: 10),

              _SubTitle("Naissance"),
              _BulletPoint(
                text:
                    "Rites et signification ; circoncision rituelle des garçons.",
              ),

              SizedBox(height: 10),

              _SubTitle("Nourriture"),
              _BulletPoint(text: "Interdiction : porc et alcool."),
              _BulletPoint(
                text:
                    "Viande halal : animaux autorisés abattus selon le rite musulman.",
              ),
              _BulletPoint(
                text: "Ramadan : jeûne du lever au coucher du soleil.",
              ),

              SizedBox(height: 10),

              _SubTitle("Signification de la mort"),
              _Paragraph(
                "La vie présente est une épreuve de préparation à l’au-delà : séparation du corps et de l’âme.",
              ),

              SizedBox(height: 10),

              _SubTitle("Funérailles"),
              _BulletPoint(
                text:
                    "Le plus rapidement possible. Rite pouvant inclure le jet de terre sur le cercueil (ou le linceul) avec récitation de prières.",
              ),

              SizedBox(height: 10),

              _SubTitle("Autopsie"),
              _BulletPoint(
                text: "Interprétations variables selon les sources.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III. Rite juif
          _ConditionCard(
            title: "IV — Rite juif",
            cardColor: cardJuda,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Écrits sacrés"),
              _BulletPoint(text: "Torah (Ancien Testament hébreu)."),

              SizedBox(height: 10),

              _SubTitle("Pratiques religieuses"),
              _BulletPoint(
                text:
                    "Lecture quotidienne de la Torah (notamment les psaumes).",
              ),
              _BulletPoint(text: "Kippa : marque de respect envers Dieu."),
              _BulletPoint(
                text:
                    "Chabbat : du vendredi soir au samedi soir (cesser le travail ; certains comportements interdits).",
              ),

              SizedBox(height: 10),

              _SubTitle("Fêtes & saisons"),
              _BulletPoint(
                text:
                    "Pourim, Pésa’h, Chavouot, Roch Hachana, Yom Kippour, Souccot, Chemini Atseret, Sim’hat Tora, Hanoucca.",
              ),

              SizedBox(height: 10),

              _SubTitle("Naissance"),
              _BulletPoint(
                text:
                    "Mariage mixte : la religion de l’enfant est déterminée par la mère.",
              ),
              _BulletPoint(text: "Circoncision rituelle des garçons."),

              SizedBox(height: 10),

              _SubTitle("Nourriture"),
              _BulletPoint(
                text:
                    "Kasher : abattage rituel (shehita) ; interdiction de consommer certains animaux et le sang.",
              ),
              _BulletPoint(text: "Pas de porc, charcuterie ou saindoux."),
              _BulletPoint(
                text:
                    "Séparation laitages/viandes (jamais servis au même repas).",
              ),
              _BulletPoint(text: "Jeûne absolu le jour de Yom Kippour."),

              SizedBox(height: 10),

              _SubTitle("Signification de la mort"),
              _BulletPoint(text: "Séjour des morts : le Chéol."),

              SizedBox(height: 10),

              _SubTitle("Fin de vie & obsèques"),
              _BulletPoint(
                text:
                    "La famille ne doit pas quitter le malade, surtout au moment de l’agonie.",
              ),
              _BulletPoint(
                text:
                    "Interdit de toucher le mourant (image de la bougie vacillante). Le corps doit être soigneusement recouvert.",
              ),
              _BulletPoint(
                text: "Obsèques religieuses : le plus rapidement possible.",
              ),
              _BulletPoint(
                text: "Funérailles simples : sans fleurs ni ornements.",
              ),

              SizedBox(height: 10),

              _SubTitle("Autopsie"),
              _BulletPoint(
                text: "Interdite (l’avis médical est à considérer).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV. Rite protestant
          _ConditionCard(
            title: "V — Rite protestant",
            cardColor: cardProt,
            accent: accentSteel,
            titleColor: textMain,
            children: const [
              _SubTitle("Écrits sacrés"),
              _BulletPoint(text: "Ancien et Nouveau Testament."),

              SizedBox(height: 10),

              _SubTitle("Pratiques religieuses"),
              _BulletPoint(
                text: "Prière, lecture de la Bible, culte dominical.",
              ),
              _BulletPoint(text: "Participation à la Sainte-Cène."),
              _BulletPoint(
                text:
                    "Baptême unique : possible dans l’enfance ou à l’âge adulte.",
              ),

              SizedBox(height: 10),

              _SubTitle("Fêtes & saisons"),
              _BulletPoint(
                text: "Noël, Pâques, Ascension, Pentecôte, fête de la Trinité.",
              ),

              SizedBox(height: 10),

              _SubTitle("Nourriture"),
              _BulletPoint(
                text:
                    "Pas de prescriptions particulières. Le repas partagé peut symboliser la communion ; la nourriture est un don du Créateur.",
              ),

              SizedBox(height: 10),

              _SubTitle("Signification de la mort"),
              _Paragraph(
                "Espérance de la vie éternelle : découverte d’une plénitude nouvelle, passage auprès de Dieu. Prière et lecture biblique renforcent l’espérance.",
              ),

              SizedBox(height: 10),

              _SubTitle("Fin de vie"),
              _BulletPoint(
                text:
                    "Accompagnement par lectures bibliques et prières ; un proche peut faire fonction de pasteur.",
              ),

              SizedBox(height: 10),

              _SubTitle("Funérailles"),
              _BulletPoint(
                text:
                    "Centrées sur la prédication de l’Évangile (promesse de résurrection). Enterrement simple et respectueux (verset biblique + prières).",
              ),

              SizedBox(height: 10),

              _SubTitle("Autopsie & incinération"),
              _BulletPoint(text: "Pas d’obstacle doctrinal."),
            ],
          ),

          const SizedBox(height: 14),

          // Infos / MAJ
          _ConditionCard(
            title: "Infos",
            cardColor: cardInfos,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Mis à jour le "),
                TextSpan(
                  text: "13/03/2025",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
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
