import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'active_access_service.dart';

class ActiveDynamicCoursePage extends StatefulWidget {
  const ActiveDynamicCoursePage({super.key, required this.node});

  final ActiveContentNode node;

  @override
  State<ActiveDynamicCoursePage> createState() =>
      _ActiveDynamicCoursePageState();
}

class _ActiveDynamicCoursePageState extends State<ActiveDynamicCoursePage> {
  bool _completed = false;
  @override
  void initState() {
    super.initState();
    ActiveAccessService().record(widget.node.id, 'opened').catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.node.title,
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final block in widget.node.content) ...[
                _CourseBlock(block: block, dark: dark),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _completed
                      ? null
                      : () async {
                          await ActiveAccessService().record(
                            widget.node.id,
                            'completed',
                          );
                          if (mounted) setState(() => _completed = true);
                        },
                  icon: Icon(
                    _completed
                        ? Icons.check_circle_rounded
                        : Icons.task_alt_rounded,
                  ),
                  label: Text(
                    _completed
                        ? 'Cours terminé'
                        : 'Marquer le cours comme terminé',
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

class _CourseBlock extends StatelessWidget {
  const _CourseBlock({required this.block, required this.dark});
  final Map<String, dynamic> block;
  final bool dark;

  Color? _color(String? value) {
    if (value == null || value.isEmpty) return null;
    final normalized = value.replaceFirst('#', '');
    final parsed = int.tryParse(normalized, radix: 16);
    if (parsed == null) return null;
    return Color(normalized.length == 6 ? 0xFF000000 | parsed : parsed);
  }

  @override
  Widget build(BuildContext context) {
    final type = block['type']?.toString() ?? 'paragraph';
    final text = block['text']?.toString() ?? '';
    final color = _color(block['color']?.toString());
    final body = Text(
      text,
      style: GoogleFonts.fustat(
        fontSize: type == 'heading' ? 19 : 15,
        height: 1.55,
        fontWeight: type == 'heading' ? FontWeight.w800 : FontWeight.w500,
        color: color ?? (dark ? Colors.white : const Color(0xFF202124)),
      ),
    );
    if (type == 'card' || type == 'article' || type == 'circular') {
      final accent =
          color ?? (dark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0));
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF111218) : const Color(0xFFFDFDFE),
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: accent, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: body,
      );
    }
    if (type == 'divider') return const Divider(height: 24);
    return body;
  }
}
