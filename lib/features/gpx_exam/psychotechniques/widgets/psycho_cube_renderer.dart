// COP'IQ — Renderer visuel pour les exercices Raisonnement spatial &
// Rotations & symétries (style Selor / Gardien de la Paix).
//
// Format jsonb attendu côté Supabase dans figure_data :
//   {
//     "type": "cube_net",
//     "layout": "cross" | "T" | "L" | "Z" | "line"
//                                      // (cross = patron en croix latine)
//     "faces": {
//        "top":    "★",
//        "bottom": "●",
//        "left":   "◆",
//        "right":  "■",
//        "front":  "▲",
//        "back":   "▼"
//     }
//   }
//
// Et chaque option (jsonb) :
//   {
//     "key":    "A",
//     "label":  "Cube A",
//     "folded": { "top": "★", "front": "▲", "right": "■" }
//   }
//
// Le widget PsychoCubeNet rend le patron complet (les 6 faces étalées).
// Le widget PsychoFoldedCube rend une vue isométrique du cube plié, en
// affichant uniquement les 3 faces visibles (top / front / right).

import 'package:flutter/material.dart';

import 'psycho_brand.dart';

// ════════════════════════════════════════════════════════════════════════════
// PATRON DE CUBE — vue 2D, 6 carrés étalés
// ════════════════════════════════════════════════════════════════════════════

class PsychoCubeNet extends StatelessWidget {
  final Map<String, dynamic> figureData;
  final Color tint;
  final double cellSize;

  const PsychoCubeNet({
    super.key,
    required this.figureData,
    required this.tint,
    this.cellSize = 56,
  });

  String _face(String key) {
    final faces = figureData['faces'];
    if (faces is Map) {
      final v = faces[key];
      return v == null ? '' : v.toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final layout = (figureData['layout'] ?? 'cross').toString();
    final faces = <String, String>{
      'top':    _face('top'),
      'bottom': _face('bottom'),
      'left':   _face('left'),
      'right':  _face('right'),
      'front':  _face('front'),
      'back':   _face('back'),
    };

    // Détermine la grille (row, col) de chaque face suivant le layout.
    final positions = _positionsFor(layout);

    final maxRow = positions.values.map((p) => p.$1).reduce((a, b) => a > b ? a : b) + 1;
    final maxCol = positions.values.map((p) => p.$2).reduce((a, b) => a > b ? a : b) + 1;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: PsychoBrand.tinted(
        context,
        color: tint,
        radius: 14,
        alpha: .06,
      ),
      child: SizedBox(
        width:  maxCol * cellSize,
        height: maxRow * cellSize,
        child: Stack(
          children: [
            for (final entry in positions.entries)
              Positioned(
                top:  entry.value.$1 * cellSize,
                left: entry.value.$2 * cellSize,
                width:  cellSize,
                height: cellSize,
                child: _Face(
                  label: faces[entry.key] ?? '',
                  tint: tint,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Disposition : (row, col) en cellules unitaires. cross = patron en croix.
  Map<String, (int, int)> _positionsFor(String layout) {
    switch (layout) {
      case 'T':
        // ┌─┐
        // │t│
        // ├─┼─┬─┬─┐
        // │l│f│r│b│
        // └─┴─┴─┴─┘
        //   ┌─┐
        //   │d│
        //   └─┘
        return {
          'top':    (0, 1),
          'left':   (1, 0),
          'front':  (1, 1),
          'right':  (1, 2),
          'back':   (1, 3),
          'bottom': (2, 1),
        };
      case 'L':
        return {
          'top':    (0, 0),
          'front':  (1, 0),
          'right':  (1, 1),
          'back':   (1, 2),
          'bottom': (2, 0),
          'left':   (1, 3),
        };
      case 'Z':
        return {
          'top':    (0, 0),
          'front':  (0, 1),
          'right':  (1, 1),
          'bottom': (1, 2),
          'back':   (2, 2),
          'left':   (2, 3),
        };
      case 'line':
        return {
          'top':    (0, 0),
          'front':  (0, 1),
          'bottom': (0, 2),
          'back':   (0, 3),
          'left':   (0, 4),
          'right':  (0, 5),
        };
      case 'cross':
      default:
        // Patron en croix latine (le plus classique du concours) :
        //     ┌─┐
        //     │t│
        // ┌─┬─┼─┼─┐
        // │l│f│r│b│
        // └─┴─┴─┴─┘
        //     ┌─┐
        //     │d│
        //     └─┘
        return {
          'top':    (0, 2),
          'left':   (1, 1),
          'front':  (1, 2),
          'right':  (1, 3),
          'back':   (1, 4),
          'bottom': (2, 2),
        };
    }
  }
}

class _Face extends StatelessWidget {
  final String label;
  final Color tint;
  const _Face({required this.label, required this.tint});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: PsychoBrand.surface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: psychoOpa(tint, .55), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: psychoOpa(tint, .15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'InstrumentSans',
          fontWeight: FontWeight.w800,
          fontSize: 24,
          color: PsychoBrand.text(context),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CUBE PLIÉ ISOMÉTRIQUE — 3 faces visibles
// ════════════════════════════════════════════════════════════════════════════

class PsychoFoldedCube extends StatelessWidget {
  final Map<String, dynamic> foldedData;
  final Color tint;
  final double size;

  const PsychoFoldedCube({
    super.key,
    required this.foldedData,
    required this.tint,
    this.size = 100,
  });

  String _face(String key) {
    final v = foldedData[key];
    return v == null ? '' : v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IsoCubePainter(
          topLabel:   _face('top'),
          frontLabel: _face('front'),
          rightLabel: _face('right'),
          tint: tint,
          surface: PsychoBrand.surface(context),
          textColor: PsychoBrand.text(context),
        ),
      ),
    );
  }
}

class _IsoCubePainter extends CustomPainter {
  final String topLabel;
  final String frontLabel;
  final String rightLabel;
  final Color tint;
  final Color surface;
  final Color textColor;

  _IsoCubePainter({
    required this.topLabel,
    required this.frontLabel,
    required this.rightLabel,
    required this.tint,
    required this.surface,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Géométrie isométrique : on dessine 3 parallélogrammes.
    // L'angle iso est ~30°.
    final double w = size.width;
    final double h = size.height;
    final double s = w * 0.42; // côté du cube en pixels apparents
    final double dx = s * 0.5;  // décalage horizontal pour iso (cos 60°)
    final double dy = s * 0.28; // décalage vertical pour iso (sin 30°)

    final cx = w / 2;
    final cy = h / 2;

    // Sommets de référence
    final Offset center = Offset(cx, cy);
    // FRONT (face avant)
    final pFTL = center + Offset(-s, -s * 0.55);
    final pFTR = pFTL + Offset(s, 0);
    final pFBR = pFTR + Offset(0, s);
    final pFBL = pFTL + Offset(0, s);
    // RIGHT (face droite)
    final pRTL = pFTR;
    final pRTR = pRTL + Offset(dx, -dy);
    final pRBR = pRTR + Offset(0, s);
    final pRBL = pFBR;
    // TOP (face dessus)
    final pTBL = pFTL;
    final pTBR = pFTR;
    final pTTR = pRTR;
    final pTTL = pTBL + Offset(dx, -dy);

    Paint fill(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.fill;
    Paint stroke = Paint()
      ..color = psychoOpa(tint, .9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;

    // Front face (la plus claire)
    final frontPath = Path()
      ..moveTo(pFTL.dx, pFTL.dy)
      ..lineTo(pFTR.dx, pFTR.dy)
      ..lineTo(pFBR.dx, pFBR.dy)
      ..lineTo(pFBL.dx, pFBL.dy)
      ..close();
    canvas.drawPath(frontPath, fill(surface));
    canvas.drawPath(frontPath, stroke);

    // Right face (légèrement teintée)
    final rightPath = Path()
      ..moveTo(pRTL.dx, pRTL.dy)
      ..lineTo(pRTR.dx, pRTR.dy)
      ..lineTo(pRBR.dx, pRBR.dy)
      ..lineTo(pRBL.dx, pRBL.dy)
      ..close();
    canvas.drawPath(rightPath, fill(psychoOpa(tint, .15)));
    canvas.drawPath(rightPath, stroke);

    // Top face (plus teintée encore)
    final topPath = Path()
      ..moveTo(pTBL.dx, pTBL.dy)
      ..lineTo(pTBR.dx, pTBR.dy)
      ..lineTo(pTTR.dx, pTTR.dy)
      ..lineTo(pTTL.dx, pTTL.dy)
      ..close();
    canvas.drawPath(topPath, fill(psychoOpa(tint, .22)));
    canvas.drawPath(topPath, stroke);

    // Étiquettes au centre de chaque face
    void drawLabel(String label, Offset c, {double fs = 18}) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w800,
            fontSize: fs,
            color: textColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }

    final frontCenter = Offset(
      (pFTL.dx + pFBR.dx) / 2,
      (pFTL.dy + pFBR.dy) / 2,
    );
    final rightCenter = Offset(
      (pRTL.dx + pRBR.dx) / 2,
      (pRTL.dy + pRBR.dy) / 2,
    );
    final topCenter = Offset(
      (pTBL.dx + pTTR.dx) / 2,
      (pTBL.dy + pTTR.dy) / 2,
    );

    drawLabel(frontLabel, frontCenter);
    drawLabel(rightLabel, rightCenter);
    drawLabel(topLabel,   topCenter);
  }

  @override
  bool shouldRepaint(_IsoCubePainter old) =>
      old.topLabel != topLabel ||
      old.frontLabel != frontLabel ||
      old.rightLabel != rightLabel ||
      old.tint != tint;
}
