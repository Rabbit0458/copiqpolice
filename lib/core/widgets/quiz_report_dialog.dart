// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppNotifier;
import 'package:copiqpolice/core/widgets/copiq_report_question_sheet.dart';

// ---------------------------------------------------------------------------
// Callback type for inserting a report
// ---------------------------------------------------------------------------
typedef QuizReportInsertFn = Future<void> Function({
  required String reportType,
  required String message,
});

// ---------------------------------------------------------------------------
// Public entry point used by all hardcoded quiz files.
// Delegates design to CopiqReportQuestionSheet (bottom sheet).
// ---------------------------------------------------------------------------
Future<void> showQuizReportDialog({
  required BuildContext context,
  required bool isDark,
  required QuizReportInsertFn onInsert,
}) async {
  await CopiqReportQuestionSheet.show(
    context,
    onSend: ({required String reportType, required String message}) async {
      try {
        await onInsert(reportType: reportType, message: message);
      } catch (e) {
        if (!context.mounted) return;
        AppNotifier.error(
          context,
          title: 'Erreur',
          message: 'Impossible d\'envoyer le signalement.',
        );
        rethrow;
      }
    },
  );
}
