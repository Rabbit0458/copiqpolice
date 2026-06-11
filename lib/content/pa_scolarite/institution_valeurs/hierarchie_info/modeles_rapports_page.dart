import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaModelesRapportsPage extends StatelessWidget {
  const PaModelesRapportsPage({super.key});

  static const String routeName = '/pa/institution/hierarchie_info/modeles';

  static const List<_ReportModelItem> _items = [
    _ReportModelItem(
      title: "Rapport — Modèle général",
      subtitle: "Structure standard (en-tête, objet, corps, signature).",
      assetPath: "assets/images/modele_rapport.png",
    ),
    _ReportModelItem(
      title: "Rapport — ASA",
      subtitle: "Autorisation spéciale d’absence (exemple).",
      assetPath: "assets/images/modele_rapport_asa.png",
    ),
    _ReportModelItem(
      title: "Rapport — Résidence",
      subtitle: "Modèle orienté résidence / domicile (exemple).",
      assetPath: "assets/images/modele_rapport_residence.png",
    ),
    _ReportModelItem(
      title: "Rapport — Permis",
      subtitle: "Modèle orienté permis (exemple).",
      assetPath: "assets/images/modele_rapport_permis.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color card = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

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
          "Modèles de rapports",
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
            "Choisis un modèle",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Appuie sur une vignette pour l’ouvrir en plein écran (zoom + balayage).",
            style: GoogleFonts.fustat(
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white70
                  : const Color(0xFF1F1F1F).withValues(alpha: .85),
            ),
          ),
          const SizedBox(height: 14),

          // Si tu veux utiliser tes widgets _ConditionCard/_Paragraph : parfait.
          // Sinon, ce Container suffit. (Je reste simple et clean.)
          Container(
            decoration: BoxDecoration(
              color: card,
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
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: GridView.builder(
              itemCount: _items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];

                return _ModelTile(
                  item: item,
                  index: index,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _ReportModelViewerPage(
                          items: _items,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportModelItem {
  const _ReportModelItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  final String title;
  final String subtitle;
  final String assetPath;
}

class _ModelTile extends StatelessWidget {
  const _ModelTile({
    required this.item,
    required this.index,
    required this.onTap,
  });

  final _ReportModelItem item;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color tileBg = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFFFF);
    final Color border = isDark ? Colors.white10 : Colors.black12;
    final Color textMain = isDark ? Colors.white : const Color(0xFF0B0B0B);
    final Color textSub = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .78);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: tileBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .10),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: "report_model_$index",
                        child: Image.asset(item.assetPath, fit: BoxFit.cover),
                      ),
                      // Petite surcouche pour lisibilité
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: .00),
                              Colors.black.withValues(alpha: .10),
                              Colors.black.withValues(alpha: .18),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .55),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white10,
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.zoom_in_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Ouvrir",
                                style: GoogleFonts.fustat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.5,
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

              // Texts
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                        height: 1.15,
                        color: textMain,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.8,
                        height: 1.2,
                        color: textSub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportModelViewerPage extends StatefulWidget {
  const _ReportModelViewerPage({
    required this.items,
    required this.initialIndex,
  });

  final List<_ReportModelItem> items;
  final int initialIndex;

  @override
  State<_ReportModelViewerPage> createState() => _ReportModelViewerPageState();
}

class _ReportModelViewerPageState extends State<_ReportModelViewerPage> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF7F7F7);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final current = widget.items[_index];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.close_rounded, color: textMain),
          tooltip: "Fermer",
        ),
        title: Text(
          current.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.5,
            color: textMain,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (v) => setState(() => _index = v),
              itemCount: widget.items.length,
              itemBuilder: (context, i) {
                final item = widget.items[i];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .18),
                            blurRadius: 20,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4.5,
                        child: Center(
                          child: Hero(
                            tag: "report_model_$i",
                            child: Image.asset(
                              item.assetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Indicateur
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (i) {
                final bool active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? (isDark ? Colors.white : Colors.black87)
                        : (isDark ? Colors.white24 : Colors.black26),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
