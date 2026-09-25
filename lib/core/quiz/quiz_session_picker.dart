import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _preferenceKey = 'quiz_session_length_v1';
const _accent = Color(0xFF6C63FF);

@immutable
class QuizSessionChoice {
  const QuizSessionChoice({required this.questionCount, required this.isFull});

  final int questionCount;
  final bool isFull;
}

Future<QuizSessionChoice?> showQuizSessionPicker(
  BuildContext context, {
  required int availableQuestions,
  int maximumCustomQuestions = 100,
  bool allowFullBank = true,
}) async {
  if (availableQuestions <= 0) return null;
  final preferences = await SharedPreferences.getInstance();
  if (!context.mounted) return null;

  return showGeneralDialog<QuizSessionChoice>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Choix du nombre de questions',
    barrierColor: Colors.black.withValues(alpha: .26),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (dialogContext, _, __) => _SessionPickerScreen(
      availableQuestions: availableQuestions,
      maximumCustomQuestions: maximumCustomQuestions,
      allowFullBank: allowFullBank,
      rememberedQuestions: preferences.getInt(_preferenceKey) ?? 20,
      onChoose: (choice) async {
        await preferences.setInt(_preferenceKey, choice.questionCount);
        if (dialogContext.mounted) Navigator.of(dialogContext).pop(choice);
      },
      onBack: () => Navigator.of(dialogContext).pop(),
    ),
    transitionBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(.08, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _SessionPickerScreen extends StatelessWidget {
  const _SessionPickerScreen({
    required this.availableQuestions,
    required this.maximumCustomQuestions,
    required this.allowFullBank,
    required this.rememberedQuestions,
    required this.onChoose,
    required this.onBack,
  });

  final int availableQuestions;
  final int maximumCustomQuestions;
  final bool allowFullBank;
  final int rememberedQuestions;
  final ValueChanged<QuizSessionChoice> onChoose;
  final VoidCallback onBack;

  Future<void> _chooseCustom(BuildContext context) async {
    final minimum = availableQuestions >= 5 ? 5 : 1;
    final maximum = availableQuestions.clamp(minimum, maximumCustomQuestions);
    final initial = rememberedQuestions.clamp(minimum, maximum);
    final controller = TextEditingController(text: '$initial');
    String? error;
    final value = await showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: const Text(
            'Session personnalisée',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Nombre de questions',
              helperText: 'Entre $minimum et $maximum questions',
              errorText: error,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text.trim());
                if (parsed == null || parsed < minimum || parsed > maximum) {
                  setState(
                    () =>
                        error = 'Choisis un nombre entre $minimum et $maximum.',
                  );
                  return;
                }
                Navigator.pop(dialogContext, parsed);
              },
              child: const Text('Continuer'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (value == null) return;
    onChoose(
      QuizSessionChoice(
        questionCount: value,
        isFull: value == availableQuestions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? const Color(0xFF08111D)
        : const Color(0xFFF5F6F7);
    final text = isDark ? const Color(0xFFF6F7FB) : const Color(0xFF212529);
    final muted = isDark ? const Color(0xFFAEB8C8) : const Color(0xFF6C737F);
    final options =
        <
              ({
                int count,
                String title,
                String subtitle,
                IconData icon,
                Color color,
              })
            >[
              (
                count: 10,
                title: 'Session rapide',
                subtitle: 'Environ 5 minutes',
                icon: Icons.bolt_rounded,
                color: const Color(0xFF2F80ED),
              ),
              (
                count: 20,
                title: 'Session standard',
                subtitle: 'Environ 10 minutes',
                icon: Icons.timer_rounded,
                color: _accent,
              ),
              (
                count: 50,
                title: 'Session intensive',
                subtitle: 'Une révision approfondie',
                icon: Icons.school_rounded,
                color: const Color(0xFFF2994A),
              ),
            ]
            .where((option) => option.count <= availableQuestions)
            .toList();
    final minimumCustom = availableQuestions >= 5 ? 5 : 1;
    final maximumCustom = availableQuestions.clamp(
      minimumCustom,
      maximumCustomQuestions,
    );

    return Material(
      color: background,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    tooltip: 'Retour au choix du niveau',
                    icon: Icon(Icons.arrow_back_rounded, color: text),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Durée du quiz',
                      style: TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.format_list_numbered_rounded,
                  color: _accent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Combien de questions ?',
                style: TextStyle(
                  color: text,
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adapte ta session au temps dont tu disposes. '
                '$availableQuestions questions sont disponibles pour ce niveau.',
                style: TextStyle(color: muted, fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 28),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _SessionCard(
                    title: option.title,
                    subtitle: option.subtitle,
                    badge: '${option.count} questions',
                    icon: option.icon,
                    color: option.color,
                    onTap: () => onChoose(
                      QuizSessionChoice(
                        questionCount: option.count,
                        isFull: option.count == availableQuestions,
                      ),
                    ),
                  ),
                ),
              ),
              _SessionCard(
                title: 'Personnalisée',
                subtitle: 'Choisis précisément ta session',
                badge: 'De $minimumCustom à $maximumCustom',
                icon: Icons.tune_rounded,
                color: const Color(0xFF27AE60),
                onTap: () => _chooseCustom(context),
              ),
              if (allowFullBank &&
                  !options.any(
                    (option) => option.count == availableQuestions,
                  )) ...[
                const SizedBox(height: 14),
                _SessionCard(
                  title: 'Toutes les questions',
                  subtitle: 'Parcours toute la banque disponible',
                  badge: '$availableQuestions questions',
                  icon: Icons.all_inclusive_rounded,
                  color: const Color(0xFFEB5757),
                  onTap: () => onChoose(
                    QuizSessionChoice(
                      questionCount: availableQuestions,
                      isFull: true,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: .07),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 19,
                      color: _accent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Semantics(
                        label:
                            'Information importante sur le calcul du résultat',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seules tes réponses comptent',
                              style: TextStyle(
                                color: text,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Si tu arrêtes une session avant la fin, seules '
                              'les questions auxquelles tu as répondu sont '
                              'sauvegardées et utilisées pour calculer ta moyenne. '
                              'Exemple : 24 réponses sur une session de 500 = '
                              'une moyenne calculée sur 24 questions.',
                              style: TextStyle(
                                color: text,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
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

class _SessionCard extends StatefulWidget {
  const _SessionCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? const Color(0xFFF6F7FB) : const Color(0xFF212529);
    final muted = isDark ? const Color(0xFFAEB8C8) : const Color(0xFF6C737F);
    return Semantics(
      button: true,
      label: '${widget.title}, ${widget.badge}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? .98 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            constraints: const BoxConstraints(minHeight: 92),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF101826) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: widget.color.withValues(alpha: .25),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: _pressed ? .12 : .08),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 23),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: text,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: .11),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          widget.badge,
                          style: TextStyle(
                            color: widget.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
