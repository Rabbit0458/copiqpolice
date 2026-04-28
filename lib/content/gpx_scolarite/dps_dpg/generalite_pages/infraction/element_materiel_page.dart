import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ElementMaterielPage extends StatefulWidget {
  static const String routeName =
      '/gpx/generalites/infraction/element-materiel';
  const ElementMaterielPage({super.key});

  @override
  State<ElementMaterielPage> createState() => _ElementMaterielPageState();
}

class _ElementMaterielPageState extends State<ElementMaterielPage>
    with TickerProviderStateMixin {
  final _scroll = ScrollController();

  // Ancres
  final _kNotion = GlobalKey();
  final _kTentative = GlobalKey();
  final _kInfructueuse = GlobalKey();
  final _kCommissionOmission = GlobalKey();
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
          // Titre volontairement vide (cohérent avec la page Légal)
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
                // ===== HERO =====
                const SliverToBoxAdapter(child: _HeaderHero()),

                // ===== PILLS NAV =====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: _QuickNav(
                      items: const [
                        ('Notion générale', Icons.topic_rounded),
                        ('Tentative punissable', Icons.flag_rounded),
                        ('Tentative infructueuse', Icons.block_rounded),
                        ('Commission / omission', Icons.swap_horiz_rounded),
                        ('Mémo', Icons.fact_check_rounded),
                      ],
                      onTap: (label) {
                        switch (label) {
                          case 'Notion générale':
                            _goTo(_kNotion);
                            break;
                          case 'Tentative punissable':
                            _goTo(_kTentative);
                            break;
                          case 'Tentative infructueuse':
                            _goTo(_kInfructueuse);
                            break;
                          case 'Commission / omission':
                            _goTo(_kCommissionOmission);
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
                  key: _kNotion,
                  child: const _GlassCard(
                    title: 'Notion générale de l’élément matériel',
                    icon: Icons.topic_rounded,
                    bullets: [
                      'Manifestation extérieure de la volonté délictueuse (acte ou abstention).',
                      'Peut être unique ou multiple, instantané ou continu.',
                      'La seule pensée criminelle n’est pas punissable.',
                      'Actes préparatoires : en principe non réprimés, sauf texte spécial.',
                    ],
                    note:
                        'Deux formes classiques : infraction de commission (agir) et infraction d’omission (ne pas faire ce que la loi ordonne).',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kTentative,
                  child: const _GlassCard(
                    title: 'Tentative punissable (Article 121-5 du Code pénal)',
                    icon: Icons.flag_rounded,
                    bullets: [
                      'Constituée lorsqu’il y a commencement d’exécution et que le résultat a manqué pour des circonstances indépendantes de la volonté de l’auteur.',
                      'Commencement d’exécution : notion jurisprudentielle — acte univoque + intention irrévocable (ex. début d’évasion en creusant le béton).',
                      'Pas de commencement d’exécution : simples préparatifs ou propos d’intention.',
                      'Absence de désistement volontaire : si l’agent renonce spontanément avant le résultat, la tentative n’est pas punissable.',
                      'Régime : crimes — toujours punissable ; délits — si un texte le prévoit ; contraventions — en principe non.',
                    ],
                    note:
                        'Le désistement provoqué par une cause extérieure (ex. intervention policière) n’exonère pas : la tentative demeure punissable.',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kInfructueuse,
                  child: const _GlassCard(
                    title: 'Tentative infructueuse',
                    icon: Icons.block_rounded,
                    bullets: [
                      'Infraction manquée : exécution complète mais le résultat échoue pour des circonstances indépendantes (punie comme la tentative).',
                      'Infraction impossible : moyens inopérants ou objet inexistant (non punissable sauf si la tentative est incriminée : crimes et certains délits).',
                    ],
                    note:
                        'Exemples : tir qui n’atteint pas sa cible (manquée) ; pickpocket dans une poche vide ou arme à blanc (impossible).',
                  ),
                ),
                const _Gutter(),

                SliverToBoxAdapter(
                  key: _kCommissionOmission,
                  child: const _GlassCard(
                    title: 'Commission / Omission — conditions',
                    icon: Icons.swap_horiz_rounded,
                    bullets: [
                      'Commission (agir) : action matérielle interdite par la loi.',
                      'Pour la commission, on recherche : une action, un résultat (quand exigé), un lien de causalité.',
                      'Omission (ne pas faire) : abstention alors que la loi impose d’agir (ex. non-assistance à personne en danger).',
                    ],
                    note:
                        'Schéma récapitulatif : acte positif / acte négatif, commission / omission, lien de causalité — à intégrer en annexe graphique si besoin.',
                  ),
                ),
                const _Gutter(),

                // ===== MEMO =====
                SliverToBoxAdapter(
                  key: _kMemo,
                  child: const _MemoCard(
                    lines: [
                      'Élément matériel = acte ou abstention extériorisés.',
                      'Pensée seule : jamais punissable.',
                      'Tentative : commencement d’exécution + absence de désistement volontaire.',
                      'Crimes : tentative toujours punissable ; délits : seulement si texte ; contraventions : non.',
                      'Commission : action + (éventuel) résultat + causalité ; Omission : abstention malgré une obligation légale.',
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
              const Hero(tag: 'hero_materiel', child: _HeaderImage()),
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
                      'Élément matériel',
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
                      'L’acte ou le fait concret reproché.',
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

class _HeaderImage extends StatelessWidget {
  const _HeaderImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/infraction_materiel.jpeg',
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
