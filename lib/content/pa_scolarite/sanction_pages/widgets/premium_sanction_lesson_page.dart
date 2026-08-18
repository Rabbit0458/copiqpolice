import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class SanctionLessonSection {
  const SanctionLessonSection({
    required this.number,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  final String number;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> points;
}

class SanctionLessonLink {
  const SanctionLessonLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}

class PremiumSanctionLessonPage extends StatelessWidget {
  const PremiumSanctionLessonPage({
    super.key,
    required this.appBarTitle,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.objective,
    required this.keywords,
    required this.sections,
    required this.checklist,
    required this.links,
  });

  final String appBarTitle;
  final String heroTitle;
  final String heroSubtitle;
  final String objective;
  final List<String> keywords;
  final List<SanctionLessonSection> sections;
  final List<String> checklist;
  final List<SanctionLessonLink> links;

  static const _navy = Color(0xFF102A43);
  static const _blue = Color(0xFF2563EB);
  static const _gold = Color(0xFFD99A2B);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? const Color(0xFF0B1016)
        : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart",
            "f00001",
            'Retour',
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Text(
          appBarTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 32),
        children: [
          _Hero(isDark: isDark, title: heroTitle, subtitle: heroSubtitle),
          const SizedBox(height: 22),
          _SectionHeading(
            eyebrow: 'OBJECTIF',
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart",
              "f00002",
              'Ce que tu vas maîtriser',
            ),
          ),
          const SizedBox(height: 10),
          _ObjectiveCard(text: objective),
          const SizedBox(height: 13),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: keywords.map((word) => _Keyword(text: word)).toList(),
          ),
          const SizedBox(height: 25),
          _SectionHeading(
            eyebrow: 'PARCOURS',
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart",
              "f00003",
              'Comprendre étape par étape',
            ),
          ),
          const SizedBox(height: 11),
          for (var index = 0; index < sections.length; index++) ...[
            _LessonCard(section: sections[index]),
            if (index != sections.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 25),
          _SectionHeading(
            eyebrow: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart",
              "f00004",
              'MÉTHODE',
            ),
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart",
              "f00005",
              'Les bons réflexes',
            ),
          ),
          const SizedBox(height: 11),
          _ChecklistCard(items: checklist),
          const SizedBox(height: 25),
          _SectionHeading(
            eyebrow: 'CONTINUER',
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart",
              "f00006",
              'Cours associés',
            ),
          ),
          const SizedBox(height: 11),
          for (var index = 0; index < links.length; index++) ...[
            _RelatedTile(link: links[index]),
            if (index != links.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.isDark,
    required this.title,
    required this.subtitle,
  });
  final bool isDark;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$title. $subtitle',
    child: Container(
      height: 218,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .24 : .12),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/sanction.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const ColoredBox(color: PremiumSanctionLessonPage._navy),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x1A000000), Color(0xEE101B2B)],
                stops: [0, .92],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Badge(),
                const Spacer(),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.fustat(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.03,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  maxLines: 2,
                  style: GoogleFonts.fustat(
                    color: Colors.white.withValues(alpha: .82),
                    fontSize: 14,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart",
        "f00008",
        'LA SANCTION',
      ),
      style: GoogleFonts.fustat(
        color: PremiumSanctionLessonPage._navy,
        fontSize: 11,
        letterSpacing: .6,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});
  final String eyebrow;
  final String title;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: GoogleFonts.fustat(
          color: PremiumSanctionLessonPage._blue,
          fontSize: 11,
          letterSpacing: .8,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        title,
        style: GoogleFonts.fustat(fontSize: 21, fontWeight: FontWeight.w900),
      ),
    ],
  );
}

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => _Surface(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _IconBox(icon: Icons.flag_outlined, gold: true),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.fustat(
              fontSize: 13.5,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Keyword extends StatelessWidget {
  const _Keyword({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: PremiumSanctionLessonPage._blue.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: GoogleFonts.fustat(fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.section});
  final SanctionLessonSection section;
  @override
  Widget build(BuildContext context) => _Surface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconBox(icon: section.icon),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${section.number}  ·  ${section.title}',
                    style: GoogleFonts.fustat(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    section.subtitle,
                    style: GoogleFonts.fustat(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .58),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        for (final point in section.points) _Point(text: point),
      ],
    ),
  );
}

class _Point extends StatelessWidget {
  const _Point({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            color: PremiumSanctionLessonPage._gold,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.fustat(fontSize: 13, height: 1.35),
          ),
        ),
      ],
    ),
  );
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) => _Surface(
    child: Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: PremiumSanctionLessonPage._blue,
                size: 19,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  items[index],
                  style: GoogleFonts.fustat(fontSize: 13, height: 1.35),
                ),
              ),
            ],
          ),
          if (index != items.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),
        ],
      ],
    ),
  );
}

class _RelatedTile extends StatelessWidget {
  const _RelatedTile({required this.link});
  final SanctionLessonLink link;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: link.title,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(link.route),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          child: _Surface(
            child: Row(
              children: [
                _IconBox(icon: link.icon),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        link.title,
                        style: GoogleFonts.fustat(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        link.subtitle,
                        style: GoogleFonts.fustat(
                          fontSize: 12.5,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, this.gold = false});
  final IconData icon;
  final bool gold;
  @override
  Widget build(BuildContext context) {
    final color = gold
        ? PremiumSanctionLessonPage._gold
        : PremiumSanctionLessonPage._blue;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D27) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .07)
              : const Color(0xFFE4E9F0),
        ),
      ),
      child: child,
    );
  }
}
