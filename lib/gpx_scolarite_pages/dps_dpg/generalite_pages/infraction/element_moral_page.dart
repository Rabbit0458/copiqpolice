import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ElementMoralPage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/infraction/element-moral';
  const ElementMoralPage({super.key});

  @override
  State<ElementMoralPage> createState() => _ElementMoralPageState();
}

class _ElementMoralPageState extends State<ElementMoralPage>
    with TickerProviderStateMixin {
  final _scroll = ScrollController();

  // Ancres
  final _kDefinition = GlobalKey();
  final _kIntentionnelle = GlobalKey();
  final _kNonIntentionnelle = GlobalKey();
  final _kContraventionnelle = GlobalKey();
  final _kMemo = GlobalKey();

  double _read = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final max = _scroll.position.maxScrollExtent;
      final cur = _scroll.offset.clamp(0.0, max);
      if (!mounted) return;
      setState(() => _read = max == 0 ? 0 : (cur / max));
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _goTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final overlay = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: const Text(''), // on masque le titre (comme demandé)
          leading: IconButton(
            tooltip: 'Retour',
            icon: Icon(
              Icons.arrow_back_rounded,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scroll,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ===== HERO =====
                const SliverToBoxAdapter(child: _HeaderHero()),

                // ===== PILLS NAV =====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: _QuickNav(
                      items: const [
                        ('Définition', Icons.info_rounded),
                        ('Faute intentionnelle', Icons.flag_rounded),
                        (
                          'Faute non intentionnelle',
                          Icons.warning_amber_rounded,
                        ),
                        ('Faute contraventionnelle', Icons.rule_rounded),
                        ('Mémo', Icons.fact_check_rounded),
                      ],
                      onTap: (label) {
                        switch (label) {
                          case 'Définition':
                            _goTo(_kDefinition);
                            break;
                          case 'Faute intentionnelle':
                            _goTo(_kIntentionnelle);
                            break;
                          case 'Faute non intentionnelle':
                            _goTo(_kNonIntentionnelle);
                            break;
                          case 'Faute contraventionnelle':
                            _goTo(_kContraventionnelle);
                            break;
                          case 'Mémo':
                            _goTo(_kMemo);
                            break;
                        }
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 6)),

                // ===== SECTIONS =====
                // Définition
                SliverToBoxAdapter(
                  key: _kDefinition,
                  child: const _GlassCard(
                    title: 'Définition de l’élément moral',
                    icon: Icons.info_rounded,
                    bullets: [
                      'Pas d’infraction sans élément moral : l’acte répréhensible doit provenir de la volonté de l’auteur.',
                      'L’auteur doit agir avec intelligence et volonté ; le mobile personnel importe peu en droit, mais peut influer sur la peine.',
                    ],
                    note:
                        'Référence : “Il n’y a point de crime ou de délit sans intention de le commettre.” (Article 111-3 anciennement évoqué en doctrine pour le principe ; pour la faute non intentionnelle, se reporter à l’Article 121-3 du Code pénal).',
                  ),
                ),
                const _Gutter(),

                // ---- Comprendre "dol"
                SliverToBoxAdapter(
                  child: const _GlassCard(
                    title: 'Comprendre le mot « dol »',
                    icon: Icons.lightbulb_rounded,
                    bullets: [
                      'Origine : du latin « dolus » (ruse, tromperie, intention de nuire).',
                      'Sens en droit pénal : l’intention coupable — volonté consciente d’accomplir un acte interdit.',
                      'Idée clé : agir avec dol = agir volontairement en sachant que l’acte est illégal.',
                    ],
                    note:
                        'En pratique : le dol s’oppose à la faute non intentionnelle (imprudence/négligence, art. 121-3 du Code pénal).',
                  ),
                ),
                const _Gutter(),

                // Faute intentionnelle
                SliverToBoxAdapter(
                  key: _kIntentionnelle,
                  child: const _GlassCard(
                    title: 'Faute intentionnelle (dol)',
                    icon: Icons.flag_rounded,
                    bullets: [
                      'Dol général : volonté d’accomplir l’acte interdit en connaissance de son caractère illicite.',
                      'Dol spécial : intention d’atteindre un résultat particulier exigé par la loi (exemples classiques : intention de tuer, de détruire…).',
                      'Résultat déterminé : lorsque le résultat obtenu correspond exactement à celui visé par l’auteur.',
                      'Préméditation : forme aggravée de l’intention criminelle prévue par certains textes.',
                    ],
                    note:
                        'Lorsque l’élément légal exige un résultat particulier (dol spécial), la caractérisation de ce but spécifique est requise en plus de la volonté d’agir.',
                  ),
                ),
                const _Gutter(),

                // Faute non intentionnelle
                SliverToBoxAdapter(
                  key: _kNonIntentionnelle,
                  child: const _GlassCard(
                    title: 'Faute non intentionnelle',
                    icon: Icons.warning_amber_rounded,
                    bullets: [
                      'Imprudence, négligence, maladresse, inattention, manquement à une obligation de prudence ou de sécurité prévue par la loi ou le règlement.',
                      'Lien de causalité : direct (faute simple) ou indirect (faute qualifiée à établir selon les textes et la jurisprudence).',
                      'Mise en danger délibérée de la personne d’autrui : violation manifestement délibérée d’une obligation particulière de prudence ou de sécurité.',
                    ],
                    note:
                        'Référence pivot : Article 121-3 du Code pénal (al. 3 et 4) — modalités de répression des fautes d’imprudence et de négligence.',
                  ),
                ),
                const _Gutter(),

                // Faute contraventionnelle
                SliverToBoxAdapter(
                  key: _kContraventionnelle,
                  child: const _GlassCard(
                    title: 'Faute contraventionnelle',
                    icon: Icons.rule_rounded,
                    bullets: [
                      'La faute est présumée : la simple violation d’un texte légal ou réglementaire suffit.',
                      'Indépendante de la survenance d’un dommage : l’infraction est constituée dès la méconnaissance de la prescription.',
                    ],
                    note:
                        'Exemple typique : non-respect d’une prescription du code de la route. La responsabilité peut être écartée en cas de force majeure ou de contrainte dûment démontrée.',
                  ),
                ),
                const _Gutter(),

                // Mémo
                SliverToBoxAdapter(
                  key: _kMemo,
                  child: const _MemoCard(
                    lines: [
                      'Élément moral indispensable : l’acte doit émaner de la volonté de l’auteur.',
                      'Dol = volonté d’agir (dol général) + parfois but particulier exigé (dol spécial).',
                      'Faute non intentionnelle = imprudence/négligence + lien de causalité (art. 121-3).',
                      'Contraventionnel : la violation simple du texte suffit.',
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 52)),
              ],
            ),

            // Barre de lecture
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                ignoring: true,
                child: _ReadingBar(progress: _read),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*──────────────────────── HEADER ────────────────────────*/

class _HeaderHero extends StatelessWidget {
  const _HeaderHero();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(18);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            border: Border.all(color: cs.onSurface.withOpacity(.06), width: 1),
            borderRadius: radius,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Hero(tag: 'hero_moral', child: _HeroImage()),
              // Dégradé lisibilité
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.15),
                      Colors.black.withOpacity(.55),
                    ],
                    stops: const [0.2, 1],
                  ),
                ),
              ),
              // Contenu
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chip('Module'),
                    const Spacer(),
                    Text(
                      'Élément moral',
                      style: GoogleFonts.fustat(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        height: 1.0,
                        letterSpacing: .2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'L’intention ou la faute de l’auteur.',
                      style: GoogleFonts.fustat(
                        color: Colors.white.withOpacity(.88),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Pastille
              Positioned(right: 16, bottom: 16, child: _ctaPill()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.16),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.white.withOpacity(.22)),
    ),
    child: Text(
      t,
      style: GoogleFonts.fustat(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: .15,
      ),
    ),
  );

  Widget _ctaPill() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.14),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.white.withOpacity(.22)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.school_rounded, color: Colors.white, size: 18),
        SizedBox(width: 6),
        Text(
          'Cours',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/infraction_moral.jpeg',
      fit: BoxFit.cover,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
    );
  }
}

/*──────────────────────── QUICK NAV ─────────────────────*/

class _QuickNav extends StatelessWidget {
  const _QuickNav({required this.items, required this.onTap});

  final List<(String, IconData)> items;
  final void Function(String label) onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pillBg = isDark
        ? Colors.white.withOpacity(.10)
        : cs.primary.withOpacity(.08);
    final pillStroke = isDark
        ? Colors.white.withOpacity(.18)
        : cs.primary.withOpacity(.18);
    final pillText = isDark ? Colors.white : cs.onSurface;
    final pillIcon = isDark ? Colors.white : cs.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final it in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () => onTap(it.$1),
                borderRadius: BorderRadius.circular(999),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: pillBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: pillStroke),
                  ),
                  child: Row(
                    children: [
                      Icon(it.$2, size: 16, color: pillIcon),
                      const SizedBox(width: 6),
                      Text(
                        it.$1,
                        style: GoogleFonts.fustat(
                          color: pillText,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: .15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/*─────────────────────── CARDS CONTENU ───────────────────*/

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.title,
    required this.icon,
    required this.bullets,
    this.note,
  });

  final String title;
  final IconData icon;
  final List<String> bullets;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(16);

    final cardBg = isDark
        ? Colors.white.withOpacity(.08)
        : Colors.black.withOpacity(.035);
    final border = isDark
        ? Colors.white.withOpacity(.16)
        : Colors.black.withOpacity(.06);
    final chipBg = isDark
        ? Colors.white.withOpacity(.16)
        : Colors.black.withOpacity(.06);
    final chipBrd = isDark
        ? Colors.white.withOpacity(.18)
        : Colors.black.withOpacity(.08);
    final textClr = isDark ? Colors.white : cs.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: radius,
              border: Border.all(color: border),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: chipBg,
                        border: Border.all(color: chipBrd),
                      ),
                      child: Icon(icon, color: textClr),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fustat(
                          textStyle: TextStyle(
                            color: textClr,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: .2,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Puces
                for (final line in bullets) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Icon(
                          Icons.fiber_manual_record,
                          size: 8,
                          color: textClr.withOpacity(.95),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          line,
                          style: GoogleFonts.fustat(
                            color: textClr.withOpacity(.95),
                            fontSize: 14,
                            height: 1.32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

                // Note
                if (note != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(.10)
                          : Colors.black.withOpacity(.035),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.tips_and_updates_rounded,
                          size: 18,
                          color: textClr,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note!,
                            style: GoogleFonts.fustat(
                              color: textClr.withOpacity(.95),
                              fontSize: 13.5,
                              height: 1.28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemoCard extends StatelessWidget {
  const _MemoCard({required this.lines});
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final bg = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.035);
    final border = isDark
        ? Colors.white.withOpacity(.16)
        : Colors.black.withOpacity(.06);
    final text = isDark ? Colors.white : cs.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fact_check_rounded, color: text),
                const SizedBox(width: 8),
                Text(
                  'Mémo',
                  style: GoogleFonts.fustat(
                    color: text,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (final l in lines) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded, size: 16, color: text),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l,
                      style: GoogleFonts.fustat(
                        color: text,
                        fontSize: 14,
                        height: 1.32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

/*──────────────────── GUTTER / SPACER ───────────────────*/

class _Gutter extends StatelessWidget {
  const _Gutter();
  @override
  Widget build(BuildContext context) =>
      const SliverToBoxAdapter(child: SizedBox(height: 10));
}

/*─────────────────────── READING BAR ─────────────────────*/

class _ReadingBar extends StatelessWidget {
  const _ReadingBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bar = isDark ? Colors.white : Colors.black;
    return SizedBox(
      height: 3,
      child: LinearProgressIndicator(
        value: progress.clamp(0, 1),
        backgroundColor: bar.withOpacity(.18),
        valueColor: AlwaysStoppedAnimation<Color>(bar),
        minHeight: 3,
      ),
    );
  }
}
