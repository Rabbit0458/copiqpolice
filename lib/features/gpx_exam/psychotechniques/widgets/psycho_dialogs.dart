// COP'IQ — Dialogues : sortie d'exercice + bottom sheet de signalement.
// Tous les libellés sont en français. Notification de succès via AppNotifier
// pour rester cohérent avec le reste de l'app (style iOS).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppNotifier;

import '../models/psycho_question.dart';
import '../services/psycho_report_service.dart';
import 'psycho_brand.dart';

// ════════════════════════════════════════════════════════════════════════════
// EXIT DIALOG
// ════════════════════════════════════════════════════════════════════════════
Future<bool> showPsychoExitDialog(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: PsychoBrand.surface(ctx),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: PsychoBrand.tinted(
                ctx,
                color: PsychoBrand.bad,
                radius: 16,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: PsychoBrand.bad),
            ),
            const SizedBox(height: 14),
            Text('Quitter l’exercice ?', style: PsychoBrand.h2(ctx)),
            const SizedBox(height: 6),
            Text(
              'Ta progression actuelle ne sera pas enregistrée. '
              'Tu pourras recommencer plus tard.',
              style: PsychoBrand.body(
                ctx,
              ).copyWith(color: PsychoBrand.textMuted(ctx)),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: PsychoBrand.borderColor(ctx)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      foregroundColor: PsychoBrand.text(ctx),
                    ),
                    child: const Text(
                      'Continuer',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: PsychoBrand.bad,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Quitter',
                      style: TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return res ?? false;
}

// ════════════════════════════════════════════════════════════════════════════
// REPORT BOTTOM SHEET — types FR, message ≤ 250 caractères, AppNotifier
// ════════════════════════════════════════════════════════════════════════════

class _ReportType {
  final String value; // valeur stockée en BDD (français)
  final String label; // libellé UI
  final IconData icon;
  const _ReportType(this.value, this.label, this.icon);
}

const List<_ReportType> _reportTypes = [
  _ReportType(
    'reponse_incorrecte',
    'Réponse incorrecte',
    Icons.cancel_outlined,
  ),
  _ReportType(
    'question_mal_formulee',
    'Question mal formulée',
    Icons.edit_note_rounded,
  ),
  _ReportType(
    'probleme_affichage',
    'Problème d’affichage',
    Icons.broken_image_outlined,
  ),
  _ReportType('doublon', 'Doublon', Icons.copy_all_rounded),
  _ReportType('autre', 'Autre', Icons.help_outline_rounded),
];

const int _kMaxReportMessage = 250;

Future<bool> showPsychoReportSheet({
  required BuildContext context,
  required PsychoQuestion question,
  required String pageRouteName,
}) async {
  String selected = _reportTypes.first.value;
  final controller = TextEditingController();

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: .82,
        maxChildSize: .92,
        minChildSize: .5,
        builder: (_, scrollCtrl) => Container(
          decoration: BoxDecoration(
            color: PsychoBrand.surface(ctx),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: StatefulBuilder(
            builder: (ctx, setSheet) {
              return ListView(
                controller: scrollCtrl,
                padding: EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  20 + MediaQuery.of(ctx).viewInsets.bottom,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: psychoOpa(PsychoBrand.text(ctx), .15),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: PsychoBrand.tinted(
                          ctx,
                          color: PsychoBrand.bad,
                          radius: 14,
                        ),
                        child: const Icon(
                          Icons.flag_rounded,
                          color: PsychoBrand.bad,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Signaler la question',
                              style: PsychoBrand.h2(ctx),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ton signalement aide à améliorer le contenu.',
                              style: PsychoBrand.small(
                                ctx,
                              ).copyWith(color: PsychoBrand.textMuted(ctx)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('Type de problème', style: PsychoBrand.h3(ctx)),
                  const SizedBox(height: 10),
                  ..._reportTypes.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => setSheet(() => selected = t.value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected == t.value
                                  ? PsychoBrand.bad
                                  : PsychoBrand.borderColor(ctx),
                              width: 1.4,
                            ),
                            color: selected == t.value
                                ? psychoOpa(PsychoBrand.bad, .08)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                t.icon,
                                color: selected == t.value
                                    ? PsychoBrand.bad
                                    : PsychoBrand.textMuted(ctx),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  t.label,
                                  style: PsychoBrand.body(
                                    ctx,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              if (selected == t.value)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: PsychoBrand.bad,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Message (optionnel)',
                        style: PsychoBrand.h3(ctx),
                      ),
                      const Spacer(),
                      Text(
                        '${controller.text.characters.length}/$_kMaxReportMessage',
                        style: PsychoBrand.small(ctx).copyWith(
                          color: controller.text.characters.length >
                                  _kMaxReportMessage
                              ? PsychoBrand.bad
                              : PsychoBrand.textMuted(ctx),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    maxLength: _kMaxReportMessage,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(_kMaxReportMessage),
                    ],
                    onChanged: (_) => setSheet(() {}),
                    decoration: InputDecoration(
                      hintText:
                          'Décris en quelques mots ce qui ne va pas (250 car. max)…',
                      counterText: '',
                      filled: true,
                      fillColor: psychoOpa(PsychoBrand.text(ctx), .04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: PsychoBrand.borderColor(ctx),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: PsychoBrand.borderColor(ctx),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: PsychoBrand.accent,
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final ok = await PsychoReportService().sendReport(
                          question: question,
                          reportType: selected,
                          message: controller.text.trim().isEmpty
                              ? null
                              : controller.text.trim(),
                          page: pageRouteName,
                        );
                        if (ctx.mounted) Navigator.pop(ctx, ok);
                      },
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Envoyer le signalement'),
                      style: FilledButton.styleFrom(
                        backgroundColor: PsychoBrand.bad,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );

  // Notification iOS-style cohérente avec le reste de l'app
  if (context.mounted) {
    if (result == true) {
      AppNotifier.success(
        context,
        title: 'Signalement envoyé',
        message: 'Merci ! Notre équipe va examiner ta remarque.',
      );
    } else if (result == false) {
      // L'utilisateur a fermé le sheet sans envoyer ou l'envoi a échoué
      // (false réel uniquement quand sendReport renvoie false).
      // On ne notifie pas l'utilisateur s'il a juste fermé le sheet (null).
    }
  }
  return;
  }
}
