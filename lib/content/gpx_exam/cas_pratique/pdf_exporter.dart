// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Export PDF de la copie corrigée               ║
// ║  Tâche      : CODE-070                                                  ║
// ║                                                                         ║
// ║  Génère un PDF A4 avec :                                                 ║
// ║    • entête COP'IQ (logo + titre + thème + année + difficulté)          ║
// ║    • score total + pourcentage en gros (gradient palette)               ║
// ║    • copie : par question → consigne + réponse utilisateur              ║
// ║    • correction : par point de rubric → label, poids, statut, mots-clés ║
// ║    • watermark "COP'IQ" diagonal en filigrane                            ║
// ║    • pied de page : date + URL + numérotation                            ║
// ║                                                                         ║
// ║  Usage :                                                                 ║
// ║    final bytes = await CasPratiquePdfExporter.build(input: ...);        ║
// ║    await CasPratiquePdfExporter.share(bytes: bytes, fileName: '...');   ║
// ║                                                                         ║
// ║  Dépendances pubspec :                                                   ║
// ║    pdf: ^3.11.1                                                          ║
// ║    printing: ^5.13.4                                                     ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Modèle d'entrée (immutable, sérialisable)
// ─────────────────────────────────────────────────────────────────────────────

/// Une question + la réponse de l'utilisateur + ses rubric points corrigés.
class PdfQuestionBlock {
  final String questionId;
  final int position; // 1, 2, 3...
  final String prompt;
  final String userAnswer;
  final int maxPoints;
  final double awarded;
  final List<PdfRubricPointBlock> points;

  const PdfQuestionBlock({
    required this.questionId,
    required this.position,
    required this.prompt,
    required this.userAnswer,
    required this.maxPoints,
    required this.awarded,
    required this.points,
  });
}

/// Un point de rubric corrigé.
class PdfRubricPointBlock {
  final String label;
  final double weight;
  final double awarded;
  final bool isMatched;
  final List<String> matchedKeywords; // ex: ["force", "proportionnée"]
  final String? explanation; // explanation_md (sera affiché brut, sans MD)

  const PdfRubricPointBlock({
    required this.label,
    required this.weight,
    required this.awarded,
    required this.isMatched,
    this.matchedKeywords = const [],
    this.explanation,
  });
}

/// Input global pour la génération PDF.
class PdfCorrectionInput {
  final String caseTitle;
  final String themeLabel;
  final int? year;
  final String? difficulty; // "facile" | "moyen" | "difficile" | "expert"
  final double totalScore;
  final double totalMax;
  final double percent; // 0..100
  final DateTime submittedAt;
  final List<PdfQuestionBlock> questions;
  final String? userDisplayName; // optionnel

  const PdfCorrectionInput({
    required this.caseTitle,
    required this.themeLabel,
    this.year,
    this.difficulty,
    required this.totalScore,
    required this.totalMax,
    required this.percent,
    required this.submittedAt,
    required this.questions,
    this.userDisplayName,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tokens couleur (alignés sur CpTokens)
// ─────────────────────────────────────────────────────────────────────────────

class _Pal {
  static const blue       = PdfColor.fromInt(0xFF1147D9);
  static const blueDeep   = PdfColor.fromInt(0xFF000B36);
  static const gold       = PdfColor.fromInt(0xFFFFC700);
  static const green      = PdfColor.fromInt(0xFF22C55E);
  static const red        = PdfColor.fromInt(0xFFEF4444);
  static const greyBg     = PdfColor.fromInt(0xFFF5F7FB);
  static const greyLine   = PdfColor.fromInt(0xFFE3E8F0);
  static const greyText   = PdfColor.fromInt(0xFF5A6478);
  static const greyTextHi = PdfColor.fromInt(0xFF1A2138);
  static const white      = PdfColor.fromInt(0xFFFFFFFF);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Service principal
// ─────────────────────────────────────────────────────────────────────────────

class CasPratiquePdfExporter {
  CasPratiquePdfExporter._();

  /// Génère le PDF et retourne ses bytes. Ne touche pas au filesystem.
  static Future<Uint8List> build({required PdfCorrectionInput input}) async {
    final doc = pw.Document(
      title: 'COP\'IQ — Cas Pratique — ${input.caseTitle}',
      author: 'COP\'IQ',
      creator: 'COP\'IQ App',
      subject: 'Copie corrigée — ${input.caseTitle}',
      keywords: 'cop\'iq, cas pratique, police, gardien de la paix',
    );

    // Charge le logo (si présent dans les assets) — sans planter si absent
    pw.MemoryImage? logo;
    try {
      final logoBytes = await rootBundle.load('assets/images/logo.png');
      logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {
      logo = null;
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 48),
        header: (ctx) => _buildHeader(input, logo, ctx),
        footer: (ctx) => _buildFooter(ctx),
        build: (ctx) => [
          _buildTitleBlock(input),
          pw.SizedBox(height: 14),
          _buildScoreCard(input),
          pw.SizedBox(height: 18),
          ..._buildAllQuestionBlocks(input),
        ],
      ),
    );

    return doc.save();
  }

  /// Partage le PDF via le sélecteur natif (Files / Mail / Drive / etc.).
  static Future<void> share({
    required Uint8List bytes,
    required String fileName,
    String? subject,
  }) async {
    await Printing.sharePdf(
      bytes: bytes,
      filename: fileName,
      subject: subject ?? 'Ma copie corrigée — COP\'IQ',
    );
  }

  /// Aperçu plein écran + bouton partage natif (modal système).
  static Future<void> preview({required PdfCorrectionInput input}) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => build(input: input),
      name: 'COP\'IQ — ${input.caseTitle}',
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  Header (haut de chaque page)
  // ───────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildHeader(
    PdfCorrectionInput input,
    pw.MemoryImage? logo,
    pw.Context ctx,
  ) {
    final isFirst = ctx.pageNumber == 1;
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _Pal.greyLine, width: 0.6)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (logo != null)
            pw.Container(
              width: 28,
              height: 28,
              decoration: pw.BoxDecoration(
                color: _Pal.blue,
                borderRadius: pw.BorderRadius.circular(7),
              ),
              padding: const pw.EdgeInsets.all(3),
              child: pw.Image(logo),
            )
          else
            pw.Container(
              width: 28,
              height: 28,
              decoration: pw.BoxDecoration(
                color: _Pal.blue,
                borderRadius: pw.BorderRadius.circular(7),
              ),
              alignment: pw.Alignment.center,
              child: pw.Text(
                'C',
                style: pw.TextStyle(
                  color: _Pal.white,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          pw.SizedBox(width: 10),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                'COP\'IQ',
                style: pw.TextStyle(
                  color: _Pal.blueDeep,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.6,
                ),
              ),
              pw.Text(
                'Cas Pratique — Copie corrigée',
                style: const pw.TextStyle(
                  color: _Pal.greyText,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          pw.Spacer(),
          if (!isFirst)
            pw.Text(
              input.caseTitle,
              style: pw.TextStyle(
                color: _Pal.greyText,
                fontSize: 9,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  Footer (bas de chaque page)
  // ───────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildFooter(pw.Context ctx) {
    final date = DateTime.now();
    final dateStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _Pal.greyLine, width: 0.4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'cop-iq.fr  •  Édité le $dateStr',
            style: const pw.TextStyle(color: _Pal.greyText, fontSize: 8),
          ),
          pw.Text(
            'Page ${ctx.pageNumber} / ${ctx.pagesCount}',
            style: const pw.TextStyle(color: _Pal.greyText, fontSize: 8),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  Titre + métadonnées (cas, année, thème, difficulté)
  // ───────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildTitleBlock(PdfCorrectionInput input) {
    final chips = <pw.Widget>[];
    chips.add(_chip(input.themeLabel, _Pal.blue, _Pal.white));
    if (input.year != null) {
      chips.add(_chip('Année ${input.year}', _Pal.greyBg, _Pal.blueDeep));
    }
    if (input.difficulty != null && input.difficulty!.isNotEmpty) {
      chips.add(_chip(_capitalize(input.difficulty!), _Pal.gold, _Pal.blueDeep));
    }

    final submittedStr = _formatDateTime(input.submittedAt);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          input.caseTitle,
          style: pw.TextStyle(
            color: _Pal.blueDeep,
            fontWeight: pw.FontWeight.bold,
            fontSize: 22,
            height: 1.15,
          ),
        ),
        pw.SizedBox(height: 6),
        if (input.userDisplayName != null)
          pw.Text(
            'Candidat : ${input.userDisplayName}',
            style: const pw.TextStyle(color: _Pal.greyText, fontSize: 10),
          ),
        pw.Text(
          'Soumis le $submittedStr',
          style: const pw.TextStyle(color: _Pal.greyText, fontSize: 10),
        ),
        pw.SizedBox(height: 10),
        pw.Wrap(spacing: 6, runSpacing: 6, children: chips),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  Carte score (gradient palette)
  // ───────────────────────────────────────────────────────────────────────────

  static pw.Widget _buildScoreCard(PdfCorrectionInput input) {
    final percent = input.percent.clamp(0, 100).toDouble();
    final mention = _mention(percent);
    final accent = _accentForPercent(percent);

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [_Pal.blueDeep, _Pal.blue],
          begin: pw.Alignment.centerLeft,
          end: pw.Alignment.centerRight,
        ),
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                'SCORE',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0x99FFFFFF),
                  fontSize: 9,
                  letterSpacing: 1.4,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: _fmtScore(input.totalScore),
                      style: pw.TextStyle(
                        color: _Pal.white,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    pw.TextSpan(
                      text: ' / ${_fmtScore(input.totalMax)}',
                      style: pw.TextStyle(
                        color: const PdfColor.fromInt(0xB3FFFFFF),
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                mention,
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xE6FFFFFF),
                  fontSize: 11,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          ),
          pw.Spacer(),
          pw.Container(
            width: 88,
            height: 88,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(color: accent, width: 4),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              '${percent.round()}%',
              style: pw.TextStyle(
                color: _Pal.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  Questions + corrections
  // ───────────────────────────────────────────────────────────────────────────

  static List<pw.Widget> _buildAllQuestionBlocks(PdfCorrectionInput input) {
    final widgets = <pw.Widget>[];
    for (final q in input.questions) {
      widgets.add(_buildQuestionBlock(q));
      widgets.add(pw.SizedBox(height: 14));
    }
    return widgets;
  }

  static pw.Widget _buildQuestionBlock(PdfQuestionBlock q) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _Pal.white,
        border: pw.Border.all(color: _Pal.greyLine, width: 0.6),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Bandeau "Question N"
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const pw.BoxDecoration(
              color: _Pal.greyBg,
              borderRadius: pw.BorderRadius.only(
                topLeft: pw.Radius.circular(10),
                topRight: pw.Radius.circular(10),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: _Pal.blue,
                    borderRadius: pw.BorderRadius.circular(20),
                  ),
                  child: pw.Text(
                    'Question ${q.position}',
                    style: pw.TextStyle(
                      color: _Pal.white,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                pw.Spacer(),
                pw.Text(
                  '${_fmtScore(q.awarded)} / ${q.maxPoints} pts',
                  style: pw.TextStyle(
                    color: _Pal.blueDeep,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Consigne
          pw.Container(
            padding: const pw.EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: pw.Text(
              q.prompt,
              style: pw.TextStyle(
                color: _Pal.greyTextHi,
                fontSize: 10.5,
                fontWeight: pw.FontWeight.bold,
                height: 1.35,
              ),
            ),
          ),
          // Réponse de l'utilisateur
          pw.Container(
            margin: const pw.EdgeInsets.fromLTRB(12, 6, 12, 10),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: _Pal.greyBg,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'VOTRE RÉPONSE',
                  style: pw.TextStyle(
                    color: _Pal.greyText,
                    fontSize: 8,
                    letterSpacing: 1.2,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  q.userAnswer.trim().isEmpty
                      ? '(Aucune réponse)'
                      : q.userAnswer.trim(),
                  style: pw.TextStyle(
                    color: _Pal.greyTextHi,
                    fontSize: 10,
                    height: 1.45,
                    fontStyle: q.userAnswer.trim().isEmpty
                        ? pw.FontStyle.italic
                        : pw.FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          // Correction par rubric point
          if (q.points.isNotEmpty)
            pw.Container(
              padding: const pw.EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'CORRECTION',
                    style: pw.TextStyle(
                      color: _Pal.greyText,
                      fontSize: 8,
                      letterSpacing: 1.2,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  ...q.points.map(_buildRubricPoint),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildRubricPoint(PdfRubricPointBlock p) {
    final ok = p.isMatched;
    final color = ok ? _Pal.green : _Pal.red;
    final icon = ok ? '✓' : '✗';
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: pw.BoxDecoration(
        color: ok
            ? const PdfColor.fromInt(0x1A22C55E)
            : const PdfColor.fromInt(0x1AEF4444),
        borderRadius: pw.BorderRadius.circular(7),
        border: pw.Border.all(
          color: ok
              ? const PdfColor.fromInt(0x4022C55E)
              : const PdfColor.fromInt(0x40EF4444),
          width: 0.5,
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 16,
            height: 16,
            margin: const pw.EdgeInsets.only(right: 8, top: 1),
            decoration: pw.BoxDecoration(
              color: color,
              shape: pw.BoxShape.circle,
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              icon,
              style: pw.TextStyle(
                color: _Pal.white,
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        p.label,
                        style: pw.TextStyle(
                          color: _Pal.greyTextHi,
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 6),
                    pw.Text(
                      '${_fmtScore(p.awarded)} / ${_fmtScore(p.weight)}',
                      style: pw.TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (ok && p.matchedKeywords.isNotEmpty) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Mots-clés validés : ${p.matchedKeywords.join(", ")}',
                    style: pw.TextStyle(
                      color: _Pal.greyText,
                      fontSize: 8.5,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ],
                if (p.explanation != null && p.explanation!.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 3),
                  pw.Text(
                    _stripMarkdown(p.explanation!),
                    style: const pw.TextStyle(
                      color: _Pal.greyText,
                      fontSize: 8.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  Helpers UI
  // ───────────────────────────────────────────────────────────────────────────

  static pw.Widget _chip(String text, PdfColor bg, PdfColor fg) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  Helpers logique
  // ───────────────────────────────────────────────────────────────────────────

  static String _mention(double percent) {
    if (percent >= 90) return 'Excellent — niveau concours';
    if (percent >= 75) return 'Très bien — solide';
    if (percent >= 60) return 'Bien — encore quelques points à muscler';
    if (percent >= 40) return 'À retravailler — les bases sont là';
    return 'À approfondir — reprends la fiche correction';
  }

  static PdfColor _accentForPercent(double percent) {
    if (percent >= 75) return _Pal.green;
    if (percent >= 50) return _Pal.gold;
    return _Pal.red;
  }

  static String _fmtScore(double v) {
    if (v == v.truncateToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  static String _formatDateTime(DateTime dt) {
    final d  = dt.day.toString().padLeft(2, '0');
    final m  = dt.month.toString().padLeft(2, '0');
    final h  = dt.hour.toString().padLeft(2, '0');
    final mn = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} à ${h}h$mn';
  }

  /// Retire les marqueurs Markdown les plus courants (gras, italique, listes,
  /// titres) pour un affichage texte propre dans le PDF.
  static String _stripMarkdown(String md) {
    var s = md;
    s = s.replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '');
    s = s.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1');
    s = s.replaceAll(RegExp(r'__(.*?)__'), r'$1');
    s = s.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
    s = s.replaceAll(RegExp(r'_(.*?)_'), r'$1');
    s = s.replaceAll(RegExp(r'^\s*[-*+]\s+', multiLine: true), '• ');
    s = s.replaceAll(RegExp(r'`{1,3}([^`]+)`{1,3}'), r'$1');
    s = s.replaceAll(RegExp(r'\[(.*?)\]\((.*?)\)'),
                r'$2');
    return s;
  }
}
