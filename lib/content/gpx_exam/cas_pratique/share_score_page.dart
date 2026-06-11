// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Page Partage de Score (Story 1080×1920)       ║
// ║  Tâche      : CODE-069                                                  ║
// ║                                                                         ║
// ║  Génère une image PNG 1080×1920 (format story Instagram/TikTok)        ║
// ║  avec le score, le titre du cas, le badge thème, le logo COP'IQ et     ║
// ║  le gradient palette. Utilise share_plus pour partager.                 ║
// ║                                                                         ║
// ║  Route : `/gpx_exam/concours/cas_pratique/share_score`                  ║
// ║  Arguments attendus (Map) :                                              ║
// ║    caseTitle   : String (titre du cas)                                   ║
// ║    themeSlug   : String (slug du thème pour la couleur)                  ║
// ║    themeLabel  : String (libellé du thème)                               ║
// ║    totalScore  : double (score obtenu)                                   ║
// ║    totalMax    : double (score max)                                      ║
// ║    percent     : double (0..100)                                         ║
// ║    year        : int? (année du cas — optionnel)                         ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/cas_pratique_scaffold.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Modèle de données (passé via route arguments)
// ─────────────────────────────────────────────────────────────────────────────

class ShareScoreArgs {
  final String caseTitle;
  final String themeSlug;
  final String themeLabel;
  final double totalScore;
  final double totalMax;
  final double percent;
  final int? year;

  const ShareScoreArgs({
    required this.caseTitle,
    required this.themeSlug,
    required this.themeLabel,
    required this.totalScore,
    required this.totalMax,
    required this.percent,
    this.year,
  });

  factory ShareScoreArgs.fromMap(Map<dynamic, dynamic> map) {
    return ShareScoreArgs(
      caseTitle:  (map['caseTitle']  as String?)  ?? 'Cas Pratique',
      themeSlug:  (map['themeSlug']  as String?)  ?? '',
      themeLabel: (map['themeLabel'] as String?)  ?? 'Gardien de la Paix',
      totalScore: ((map['totalScore'] ?? 0) as num).toDouble(),
      totalMax:   ((map['totalMax']   ?? 1) as num).toDouble(),
      percent:    ((map['percent']    ?? 0) as num).toDouble(),
      year:       map['year'] as int?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Page principale
// ─────────────────────────────────────────────────────────────────────────────

class CasPratiqueShareScorePage extends StatefulWidget {
  const CasPratiqueShareScorePage({super.key, required this.args});

  static const String routeName =
      '/gpx_exam/concours/cas_pratique/share_score';

  final ShareScoreArgs args;

  @override
  State<CasPratiqueShareScorePage> createState() =>
      _CasPratiqueShareScorePageState();
}

class _CasPratiqueShareScorePageState
    extends State<CasPratiqueShareScorePage>
    with SingleTickerProviderStateMixin {
  // RepaintBoundary key — pour capturer le widget en image
  final GlobalKey _cardKey = GlobalKey();

  bool _generating = false;
  bool _done       = false;

  late final AnimationController _animCtrl;
  late final Animation<double>    _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Capture ────────────────────────────────────────────────────────────────

  Future<Uint8List?> _captureCard() async {
    try {
      final boundary = _cardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // pixelRatio = 3 → 1080px pour un widget affiché à ~360px logiques
      final img    = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ── Partage ─────────────────────────────────────────────────────────────────

  Future<void> _share() async {
    if (_generating) return;
    HapticFeedback.mediumImpact();
    setState(() => _generating = true);

    try {
      final bytes = await _captureCard();
      if (bytes == null) {
        _showSnackbar('Impossible de générer l\'image.', isError: true);
        return;
      }

      // Écriture temporaire
      final tmpDir  = await getTemporaryDirectory();
      final tmpFile = File('${tmpDir.path}/copiq_score.png');
      await tmpFile.writeAsBytes(bytes);

      final scoreInt = widget.args.percent.round();
      final text =
          '🎯 Je viens de faire $scoreInt % sur "${widget.args.caseTitle}" !\n'
          'Entraîne-toi avec COP\'IQ pour ton concours Gardien de la Paix 💙';

      await Share.shareXFiles(
        [XFile(tmpFile.path)],
        text: text,
        subject: 'Mon score COP\'IQ',
      );

      if (mounted) setState(() => _done = true);
    } catch (e) {
      _showSnackbar('Erreur de partage : $e', isError: true);
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? CpTokens.danger : CpTokens.success,
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CasPratiqueScaffold(
      title: 'Partager mon score',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CpTokens.s5),
        child: Column(
          children: [
            const SizedBox(height: CpTokens.s5),
            // ── Prévisualisation de la carte ─────────────────────────────────
            _CardPreview(
              cardKey: _cardKey,
              args:    widget.args,
              isDark:  isDark,
              scaleAnim: _scaleAnim,
            ),
            const SizedBox(height: CpTokens.s8),
            // ── Bouton de partage ─────────────────────────────────────────────
            _ShareButton(
              generating: _generating,
              done:       _done,
              onTap:      _share,
              isDark:     isDark,
            ),
            const SizedBox(height: CpTokens.s5),
            // ── Note légère ────────────────────────────────────────────────────
            Text(
              'L\'image sera enregistrée temporairement puis partagée\nvia Instagram, TikTok, WhatsApp ou tout autre app.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 11.5,
                color: CpTokens.onSurfaceMuted(isDark),
              ),
            ),
            const SizedBox(height: CpTokens.s8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Prévisualisation de la carte (= ce qui sera capturé)
// ─────────────────────────────────────────────────────────────────────────────

class _CardPreview extends StatelessWidget {
  const _CardPreview({
    required this.cardKey,
    required this.args,
    required this.isDark,
    required this.scaleAnim,
  });

  final GlobalKey          cardKey;
  final ShareScoreArgs     args;
  final bool               isDark;
  final Animation<double>  scaleAnim;

  @override
  Widget build(BuildContext context) {
    // Ratio story = 9:16 → à 360px logiques de large → hauteur ~640px
    const double cardW = 320.0;
    const double cardH = cardW * 16.0 / 9.0;

    return ScaleTransition(
      scale: scaleAnim,
      child: Center(
        child: SizedBox(
          width:  cardW,
          height: cardH,
          child: RepaintBoundary(
            key: cardKey,
            child: _StoryCard(args: args),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Carte story (1080×1920 — rendue à 320×569 sur l'écran, capturée × 3)
// ─────────────────────────────────────────────────────────────────────────────

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.args});

  final ShareScoreArgs args;

  @override
  Widget build(BuildContext context) {
    final themeColor = CpTokens.themeColorFor(args.themeSlug);
    final scoreColor = _scoreColorDark(args.percent);
    final scoreInt   = args.percent.round();
    final scoreStr   = args.totalScore == args.totalScore.roundToDouble()
        ? args.totalScore.toInt().toString()
        : args.totalScore.toStringAsFixed(1);
    final maxStr = args.totalMax == args.totalMax.roundToDouble()
        ? args.totalMax.toInt().toString()
        : args.totalMax.toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
          colors: [
            CpTokens.darkNavy,
            Color.lerp(CpTokens.darkNavy, themeColor, 0.30)!,
            CpTokens.darkNavyDeep,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // ── Cercle décoratif arrière-plan ────────────────────────────────
          Positioned(
            top: -60,
            right: -60,
            child: _GlowCircle(color: themeColor, radius: 160),
          ),
          const Positioned(
            bottom: -40,
            left: -40,
            child: _GlowCircle(color: CpTokens.blueLight, radius: 120),
          ),
          // ── Contenu principal ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo + titre app
                _LogoBanner(),
                const SizedBox(height: 28),
                // Badge thème
                _ThemeBadge(label: args.themeLabel, color: themeColor),
                const SizedBox(height: 20),
                // Score circle
                _ScoreCircle(
                  percent:    args.percent,
                  scoreStr:   scoreStr,
                  maxStr:     maxStr,
                  scoreColor: scoreColor,
                  themeColor: themeColor,
                ),
                const SizedBox(height: 28),
                // Titre du cas
                Text(
                  args.caseTitle,
                  textAlign: TextAlign.center,
                  maxLines:  3,
                  overflow:  TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize:   15,
                    fontWeight: FontWeight.w700,
                    color:      Colors.white,
                    height:     1.3,
                  ),
                ),
                const SizedBox(height: 10),
                // Sous-titre motivant
                Text(
                  _motivationText(scoreInt),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize:   12.5,
                    fontWeight: FontWeight.w500,
                    color:      Colors.white70,
                  ),
                ),
                if (args.year != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Annales ${args.year}',
                    style: GoogleFonts.montserrat(
                      fontSize:   11,
                      color:      Colors.white38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const Spacer(),
                // Hashtags
                Text(
                  '#GardienDeLaPaix  #ConcoursPolicier  #COPIQ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize:   10,
                    color:      Colors.white38,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                // CTA
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color:        Colors.white12,
                    borderRadius: BorderRadius.circular(CpTokens.rPill),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Text(
                    'Télécharge COP\'IQ — Entraîne-toi toi aussi !',
                    style: GoogleFonts.montserrat(
                      fontSize:   10,
                      color:      Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _scoreColorDark(double percent) {
    if (percent < 30) return CpTokens.dangerDark;
    if (percent < 70) return CpTokens.warningDark;
    return CpTokens.successDark;
  }

  static String _motivationText(int percent) {
    if (percent >= 85)  return '🏆 Excellent résultat — tu maîtrises le sujet !';
    if (percent >= 70)  return '💪 Bon score ! Continue sur ta lancée.';
    if (percent >= 50)  return '📚 Tu progresses — encore un peu de travail !';
    return '🔥 Premier essai ? Rejoue pour t\'améliorer !';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Sous-widgets de la carte
// ─────────────────────────────────────────────────────────────────────────────

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.radius});
  final Color  color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.18), Colors.transparent],
        ),
      ),
    );
  }
}

class _LogoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color:        CpTokens.blueLight,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color:      CpTokens.blueLight.withValues(alpha: 0.6),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Center(
            child: Text('⚖', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'COP\'IQ',
          style: GoogleFonts.montserrat(
            fontSize:   22,
            fontWeight: FontWeight.w900,
            color:      Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ThemeBadge extends StatelessWidget {
  const _ThemeBadge({required this.label, required this.color});
  final String label;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color:        color.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(CpTokens.rPill),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.2),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.montserrat(
          fontSize:      10.5,
          fontWeight:    FontWeight.w700,
          color:         color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({
    required this.percent,
    required this.scoreStr,
    required this.maxStr,
    required this.scoreColor,
    required this.themeColor,
  });

  final double percent;
  final String scoreStr;
  final String maxStr;
  final Color  scoreColor;
  final Color  themeColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140, height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arc de fond
          const SizedBox.expand(
            child: CircularProgressIndicator(
              value:            1.0,
              strokeWidth:      9,
              backgroundColor:  Colors.white12,
              color:            Colors.white12,
              strokeCap:        StrokeCap.round,
            ),
          ),
          // Arc score
          SizedBox.expand(
            child: CircularProgressIndicator(
              value:           (percent / 100).clamp(0.0, 1.0),
              strokeWidth:     9,
              backgroundColor: Colors.transparent,
              valueColor:      AlwaysStoppedAnimation<Color>(scoreColor),
              strokeCap:       StrokeCap.round,
            ),
          ),
          // Texte centre
          Column(
            mainAxisSize:      MainAxisSize.min,
            children: [
              Text(
                '${percent.round()}%',
                style: GoogleFonts.montserrat(
                  fontSize:   28,
                  fontWeight: FontWeight.w900,
                  color:      scoreColor,
                ),
              ),
              Text(
                '$scoreStr / $maxStr pts',
                style: GoogleFonts.montserrat(
                  fontSize:   11,
                  color:      Colors.white60,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bouton de partage
// ─────────────────────────────────────────────────────────────────────────────

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.generating,
    required this.done,
    required this.onTap,
    required this.isDark,
  });

  final bool       generating;
  final bool       done;
  final VoidCallback onTap;
  final bool       isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: generating ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: CpTokens.blueLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CpTokens.r3),
          ),
          elevation: 4,
        ),
        icon: generating
            ? const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Icon(done ? Icons.check_circle_outline : Icons.share_rounded,
                size: 20),
        label: Text(
          generating
              ? 'Génération…'
              : done
                  ? 'Partagé !'
                  : 'Partager ma story',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize:   15,
          ),
        ),
      ),
    );
  }
}
