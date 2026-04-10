import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ElementLegalPage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/infraction/element-legal';
  const ElementLegalPage({super.key});

  @override
  State<ElementLegalPage> createState() => _ElementLegalPageState();
}

class _ElementLegalPageState extends State<ElementLegalPage>
    with TickerProviderStateMixin {
  final _scroll = ScrollController();

  // Ancres
  final _kPrincipe = GlobalKey();
  final _kLois = GlobalKey();
  final _kTraites = GlobalKey();
  final _kReglements = GlobalKey();
  final _kCirculaires = GlobalKey();
  final _kJuris = GlobalKey();
  final _kMemo = GlobalKey();

  double _readProgress = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final max = _scroll.position.maxScrollExtent;
      final cur = _scroll.offset.clamp(0.0, max);
      if (!mounted) return;
      setState(() => _readProgress = max == 0 ? 0 : (cur / max));
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
          // Titre volontairement vide (exigence)
          title: const Text(''),
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
                // ===== HEADER HERO =====
                const SliverToBoxAdapter(child: _HeaderHero()),

                // ===== PILLS NAV =====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: _QuickNav(
                      items: const [
                        ('Principe de légalité', Icons.gavel_rounded),
                        ('Lois & assimilés', Icons.menu_book_rounded),
                        ('Traités', Icons.public_rounded),
                        ('Règlements', Icons.rule_rounded),
                        ('Circulaires', Icons.mail_rounded),
                        ('Jurisprudence & doctrine', Icons.balance_rounded),
                        ('Mémo', Icons.fact_check_rounded),
                      ],
                      onTap: (label) {
                        switch (label) {
                          case 'Principe de légalité':
                            _goTo(_kPrincipe);
                            break;
                          case 'Lois & assimilés':
                            _goTo(_kLois);
                            break;
                          case 'Traités':
                            _goTo(_kTraites);
                            break;
                          case 'Règlements':
                            _goTo(_kReglements);
                            break;
                          case 'Circulaires':
                            _goTo(_kCirculaires);
                            break;
                          case 'Jurisprudence & doctrine':
                            _goTo(_kJuris);
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
                SliverToBoxAdapter(
                  key: _kPrincipe,
                  child: const _GlassCard(
                    title: 'Principe de légalité (Article 111-3 du Code pénal)',
                    icon: Icons.gavel_rounded,
                    bullets: [
                      'Nul ne peut être puni pour un crime ou pour un délit dont les éléments ne sont pas définis par la loi ; pour les contraventions, par le règlement.',
                      'Interprétation stricte de la loi pénale : pas d’analogie créatrice.',
                      'Fondement du droit pénal : sans texte, pas d’infraction.',
                    ],
                    note:
                        'Référence : Article 111-3 du Code pénal, ainsi que les Articles 34 et 37 de la Constitution (répartition entre la loi et le règlement).',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kLois,
                  child: const _GlassCard(
                    title: 'Lois proprement dites et textes assimilés',
                    icon: Icons.menu_book_rounded,
                    bullets: [
                      'La loi détermine les crimes et les délits et fixe les peines (Article 111-2 du Code pénal).',
                      'Peuvent tenir lieu de loi : décisions du Président de la République (Article 16 de la Constitution), ordonnances ratifiées, anciens décrets-lois.',
                      'L’Article 34 de la Constitution détermine ce qui relève du domaine de la loi en matière pénale.',
                    ],
                    note:
                        'Toujours vérifier si un texte présenté comme « réglementaire » ne relève pas, en réalité, du domaine de la loi.',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kTraites,
                  child: const _GlassCard(
                    title: 'Traités internationaux et conventions',
                    icon: Icons.public_rounded,
                    bullets: [
                      'Une convention régulièrement ratifiée et publiée a une valeur supérieure à la loi (Article 55 de la Constitution).',
                      'Exemples : Traités de l’Union européenne ; Convention européenne des droits de l’Homme.',
                      'Le juge écarte la loi interne contraire à un traité applicable.',
                    ],
                    note:
                        'Vérifier la publication au Journal officiel et, si nécessaire, l’effet direct du traité pour pouvoir l’invoquer.',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kReglements,
                  child: const _GlassCard(
                    title: 'Règlements administratifs',
                    icon: Icons.rule_rounded,
                    bullets: [
                      'Les règlements définissent notamment les contraventions et leurs peines (Article 111-2, alinéa 2, du Code pénal).',
                      'Sources : décrets (souvent en Conseil d’État) et arrêtés ; hiérarchie à respecter.',
                      'Un règlement ne peut contredire la loi.',
                    ],
                    note:
                        'En matière contraventionnelle, la définition et la répression relèvent principalement du pouvoir réglementaire.',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kCirculaires,
                  child: const _GlassCard(
                    title: 'Circulaires et instructions',
                    icon: Icons.mail_rounded,
                    bullets: [
                      'Instructions de service (ex. Direction des affaires criminelles et des grâces).',
                      'Aucune valeur normative générale : rôle d’orientation de l’application des textes.',
                      'Réputées abrogées si non publiées (Article L.312-2 du Code des relations entre le public et l’administration).',
                    ],
                    note:
                        'Utile pour la pratique, mais ne crée ni incrimination ni peine par elle-même.',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kJuris,
                  child: const _GlassCard(
                    title: 'Jurisprudence et doctrine',
                    icon: Icons.balance_rounded,
                    bullets: [
                      'La jurisprudence regroupe les décisions des juridictions ; rôle interprétatif (Cour de cassation, chambre criminelle ; cours d’assises).',
                      'La doctrine rassemble les analyses des juristes : source d’inspiration, non normative.',
                      'L’interprétation stricte de la loi pénale limite la création prétorienne.',
                    ],
                    note:
                        'Indispensable pour comprendre le sens d’un texte ou l’appréciation d’un élément constitutif discuté.',
                  ),
                ),
                const _Gutter(),

                // ===== MEMO =====
                SliverToBoxAdapter(
                  key: _kMemo,
                  child: const _MemoCard(
                    lines: [
                      'Sans texte d’incrimination, il n’y a pas d’infraction.',
                      'Crimes et délits : domaine de la loi ; contraventions : domaine du règlement.',
                      'Toujours vérifier hiérarchie des normes et publication du texte.',
                      'Interprétation stricte de la loi pénale : pas d’analogie créatrice.',
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
                child: _ReadingBar(progress: _readProgress),
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
              Hero(
                tag: 'hero_legal',
                child: Image.asset(
                  'assets/images/infraction_legal.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
              ),
              // Dégradé lisibilité + léger angle
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
                      'Élément légal',
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
                      'Le texte qui fonde l’infraction.',
                      style: GoogleFonts.fustat(
                        color: Colors.white.withOpacity(.88),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Petite pastille “Cours”
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
                // Header
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

                // Bullets
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
