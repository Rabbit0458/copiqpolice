// lib/gpx_scolarite_pages/generalite_pages/infraction_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart';

/// Page : L’infraction — refonte UI (sliders + CTA pill + mémo)
/// Route: /gpx/generalites/infraction
class InfractionPage extends StatefulWidget {
  static const String routeName = '/gpx/generalites/infraction';
  const InfractionPage({super.key});

  @override
  State<InfractionPage> createState() => _InfractionPageState();
}

class _InfractionPageState extends State<InfractionPage>
    with TickerProviderStateMixin {
  final _scroll = ScrollController();

  // ancres (tentative/complicité retirées)
  final _kLegal = GlobalKey();
  final _kMaterial = GlobalKey();
  final _kMoral = GlobalKey();
  final _kAggravations = GlobalKey();
  final _kMemo = GlobalKey();

  // fond animé
  late final AnimationController _bgCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat(reverse: true);

  // lecture
  double _readProgress = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final max = _scroll.position.maxScrollExtent;
      final cur = _scroll.offset.clamp(0.0, max);
      setState(() => _readProgress = max == 0 ? 0 : (cur / max));
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _startQuiz() {
    HapticFeedback.mediumImpact();
    AppNotifier.info(
      context,
      title: 'Quiz « L’infraction »',
      message: 'Entraîne-toi : correction immédiate & explications ✨',
    );
    Navigator.of(context).pushNamed('/gpx/generalites/quiz/infraction');
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlay = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Theme(
        data: Theme.of(context).copyWith(useMaterial3: true),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
              tooltip: 'Retour',
            ),
            title: const Text(
              'L’infraction',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: .2,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // Fond animé (inchangé)
              AnimatedBuilder(
                animation: _bgCtrl,
                builder: (_, __) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF000932),
                                Color.lerp(
                                  const Color(0xFF000932),
                                  Colors.indigo,
                                  .12,
                                )!,
                              ]
                            : [
                                Color.lerp(
                                  const Color(0xFF1147D9),
                                  Colors.indigoAccent,
                                  .18,
                                )!,
                                const Color(0xFF1147D9),
                              ],
                        stops: const [0, 1],
                      ),
                    ),
                  );
                },
              ),

              // Contenu
              CustomScrollView(
                controller: _scroll,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // CTA quiz
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 96, 20, 14),
                      child: _QuizCTA(onTap: _startQuiz),
                    ),
                  ),

                  // Mini nav (tentative/complicité retirées)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _QuickNav(
                        items: const [
                          ('Élément légal', Icons.menu_book_rounded),
                          ('Élément matériel', Icons.architecture_rounded),
                          ('Élément moral', Icons.psychology_alt_rounded),
                          (
                            'Circonstances aggravantes',
                            Icons.local_fire_department_rounded,
                          ),
                          ('Fiche mémo', Icons.view_carousel_rounded),
                        ],
                        onTap: (label) {
                          switch (label) {
                            case 'Élément légal':
                              _goTo(_kLegal);
                              break;
                            case 'Élément matériel':
                              _goTo(_kMaterial);
                              break;
                            case 'Élément moral':
                              _goTo(_kMoral);
                              break;
                            case 'Circonstances aggravantes':
                              _goTo(_kAggravations);
                              break;
                            case 'Fiche mémo':
                              _goTo(_kMemo);
                              break;
                          }
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 6)),

                  // 1) Légal — sliders
                  SliverToBoxAdapter(
                    key: _kLegal,
                    child: _SliderSection(
                      title: '1) Élément légal',
                      pages: const [
                        _CardData('Principe', Icons.rule_rounded, [
                          'Nullum crimen, nulla poena sine lege.',
                          'Un texte incrimine précisément les faits : loi/ordonnance ; règlement pour les contraventions.',
                          'Interprétation stricte : pas d’analogie créatrice.',
                        ]),
                        _CardData('Contenu du texte', Icons.description_rounded, [
                          'Éléments constitutifs : action/omission, objet, circonstances.',
                          'Qualités/états des personnes : mineur, dépositaire de l’autorité…',
                          'Circonstances aggravantes éventuelles prévues par la loi.',
                        ]),
                      ],
                    ),
                  ),

                  // 2) Matériel — sliders
                  SliverToBoxAdapter(
                    key: _kMaterial,
                    child: _SliderSection(
                      title: '2) Élément matériel',
                      pages: const [
                        _CardData(
                          'Acte & résultat',
                          Icons.precision_manufacturing_rounded,
                          [
                            'Commission (acte positif) ou omission si obligation d’agir.',
                            'Résultat exigé (ex. blessures) ou délit formel (ex. conduite alcoolique).',
                            'Lien de causalité requis quand le texte l’implique.',
                          ],
                        ),
                        _CardData(
                          'Commission / Omission',
                          Icons.compare_arrows_rounded,
                          [
                            'Commission : réalisation d’un acte prohibé (ex. violences).',
                            'Omission : abstention fautive (ex. non-assistance).',
                            'Même exigence de texte et de culpabilité.',
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 3) Moral — sliders
                  SliverToBoxAdapter(
                    key: _kMoral,
                    child: _SliderSection(
                      title: '3) Élément moral',
                      pages: const [
                        _CardData('Intention', Icons.bolt_rounded, [
                          'Délits intentionnels : volonté en connaissance de cause.',
                          'Mobile indifférent sauf texte contraire.',
                          'Peut se déduire des circonstances matérielles.',
                        ]),
                        _CardData(
                          'Imprudence/Négligence',
                          Icons.report_gmailerrorred_rounded,
                          [
                            'Infractions non intentionnelles : imprudence, négligence, violation d’une obligation de prudence.',
                            'Faute simple / qualifiée / délibérée selon le texte.',
                          ],
                        ),
                        _CardData(
                          'Matière contraventionnelle',
                          Icons.info_rounded,
                          [
                            'Faute souvent présumée : la violation de la prescription suffit à caractériser l’infraction.',
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 4) Circonstances aggravantes — sliders (renuméroté)
                  SliverToBoxAdapter(
                    key: _kAggravations,
                    child: _SliderSection(
                      title: '4) Circonstances aggravantes',
                      pages: const [
                        _CardData(
                          'Principe général',
                          Icons.local_fire_department_rounded,
                          [
                            'La peine peut être aggravée si l’infraction est commise dans des circonstances prévues par la loi.',
                            'Ne constitue pas un élément constitutif de l’infraction (sauf textes spéciaux).',
                            'Exclues en matière contraventionnelle (principe).',
                          ],
                        ),
                        _CardData(
                          'Exemples légaux (arts. 132-71 à 132-80 C. pén.)',
                          Icons.list_alt_rounded,
                          [
                            'Bande organisée, guet-apens, préméditation, effraction, escalade.',
                            'Port/usage d’une arme.',
                            'Réunion, incapacité totale de travail.',
                            'État d’ivresse de l’auteur ou emprise de stupéfiants.',
                            'Qualité de la victime : dépositaire de l’autorité publique, conjoint/partenaire, etc.',
                          ],
                        ),
                        _CardData(
                          'Motif discriminatoire — principe',
                          Icons.flag_rounded,
                          [
                            'Aggravation lorsque crime/délit est précédé, accompagné ou suivi de propos/actes/objets à motif :',
                            '— Caractère raciste (art. 132-76 C. pén.).',
                            '— Orientation sexuelle ou identité sexuelle de la victime (art. 132-77 C. pén.).',
                          ],
                        ),
                        _CardData(
                          'Motif discriminatoire — exceptions',
                          Icons.rule_folder_rounded,
                          [
                            'Ne s’applique pas aux violences : régimes spécifiques (ex. art. 222-13 C. pén.).',
                            'Harcèlement sexuel (art. 222-33 C. pén.) : texte spécial.',
                            'Provocations, diffamations, injures : loi du 29 juillet 1881.',
                            'Disposition déjà aggravée par ailleurs pour le même motif.',
                            'Cas spécifiques : contrainte au mariage/union, etc.',
                          ],
                        ),
                        _CardData(
                          'Répression aggravée — repères',
                          Icons.balance_rounded,
                          [
                            'Criminel : échelles relevées (ex. 20 ans → 30 ans / perpétuité selon textes).',
                            'Délictuel : peines majorées (ex. 3 → 6 ans ; 5 → 7 ans ; 7 → 10 ans) et/ou amendes.',
                            'Toujours vérifier l’article spécial de l’infraction pour le quantum exact.',
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 5) Fiche mémo
                  SliverToBoxAdapter(
                    key: _kMemo,
                    child: _SliderSection(
                      title: 'Fiche mémo',
                      pages: const [
                        _CardData('Check terrain', Icons.fact_check_rounded, [
                          'Texte d’incrimination OK ?',
                          'Faits ↔ texte (éléments constitutifs) ?',
                          'Auteur (qualité requise/interdite) ?',
                          'Culpabilité : intention / imprudence ?',
                          'Causes d’irresponsabilité (LD, nécessité, ordre de la loi…)?',
                        ]),
                        _CardData(
                          'Exemples rapides',
                          Icons.tips_and_updates_rounded,
                          [
                            'Vol : soustraction + intention d’appropriation + texte.',
                            'Blessures involontaires : résultat + faute + causalité.',
                            'Conduite sous alcool : seuil + conduite (délit formel).',
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 64)),
                ],
              ),

              // Barre lecture
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
      ),
    );
  }
}

/// --------------------------- CTA Quiz (style pill) ---------------------------
class _QuizCTA extends StatefulWidget {
  const _QuizCTA({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_QuizCTA> createState() => _QuizCTAState();
}

class _QuizCTAState extends State<_QuizCTA>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _animate(bool down) {
    if (down) {
      _c.forward();
    } else {
      _c.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pillColor = Colors.black;
    final textColor = Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        borderRadius: BorderRadius.circular(999),
        onTapDown: (_) => _animate(true),
        onTapCancel: () => _animate(false),
        onTapUp: (_) => _animate(false),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .20),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              const SizedBox(width: 2),
              Text(
                'Accès quiz',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .2,
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _c,
                builder: (_, __) {
                  final t = Curves.easeOut.transform(_c.value);
                  final double size = 40 + 6 * t;
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(2 * t, 0),
                      child: Transform.rotate(
                        angle: 0.25 * t,
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --------------------------- Quick Nav (pills) ---------------------------
class _QuickNav extends StatelessWidget {
  const _QuickNav({required this.items, required this.onTap});
  final List<(String, IconData)> items;
  final void Function(String label) onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final it in items)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onTap(it.$1),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: .12),
                    border: Border.all(color: cs.primary.withValues(alpha: .25)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Icon(it.$2, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      const Text(
                        '•',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        it.$1,
                        style: const TextStyle(
                          color: Colors.white,
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

/// --------------------------- Slider Section ------------------------------
class _SliderSection extends StatefulWidget {
  const _SliderSection({required this.title, required this.pages, this.key});
  final String title;
  final List<_CardData> pages;
  @override
  final Key? key;

  @override
  State<_SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<_SliderSection> {
  late final PageController _page = PageController(viewportFraction: .92);
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: .2,
              color: isDark ? Colors.white : const Color(0xFF212529),
            ),
          ),
        ),
        // Carrousel
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _page,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.pages.length,
            onPageChanged: (i) {
              setState(() => _index = i);
              HapticFeedback.selectionClick();
            },
            itemBuilder: (_, i) {
              final data = widget.pages[i];
              return Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 20 : 8,
                  right: i == widget.pages.length - 1 ? 20 : 8,
                ),
                child: _CheatCard(category: data),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dots
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < widget.pages.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == _index ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: i == _index ? .9 : .35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CardData {
  final String title;
  final IconData icon;
  final List<String> bullets;
  const _CardData(this.title, this.icon, this.bullets);
}

/// Carte type “fiche mémo”
class _CheatCard extends StatelessWidget {
  const _CheatCard({required this.category});
  final _CardData category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            border: Border.all(color: Colors.white.withValues(alpha: .24)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withValues(alpha: .20),
                      border: Border.all(color: Colors.white.withValues(alpha: .22)),
                    ),
                    child: Icon(category.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: .2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: category.bullets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Icon(
                          Icons.fiber_manual_record,
                          size: 8,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          category.bullets[i],
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.28,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --------------------------- Barre lecture -------------------------------
class _ReadingBar extends StatelessWidget {
  const _ReadingBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: LinearProgressIndicator(
        value: progress.clamp(0, 1),
        backgroundColor: Colors.white.withValues(alpha: .18),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        minHeight: 3,
      ),
    );
  }
}
