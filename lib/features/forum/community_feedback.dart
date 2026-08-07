import 'package:flutter/material.dart';

enum CommunityNoticeType { success, info, warning, error }

void showCommunityNotice(
  BuildContext context,
  String message, {
  CommunityNoticeType type = CommunityNoticeType.info,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final (accent, icon) = switch (type) {
    CommunityNoticeType.success => (
      const Color(0xFF5EE3A1),
      Icons.check_rounded,
    ),
    CommunityNoticeType.warning => (
      const Color(0xFFFFC857),
      Icons.info_outline_rounded,
    ),
    CommunityNoticeType.error => (const Color(0xFFFF6472), Icons.close_rounded),
    CommunityNoticeType.info => (
      const Color(0xFF72A7FF),
      Icons.notifications_none_rounded,
    ),
  };
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 12,
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: const Color(0xFF171C20),
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        padding: const EdgeInsets.fromLTRB(10, 9, 8, 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
          side: BorderSide(color: accent.withValues(alpha: .28)),
        ),
        content: Semantics(
          liveRegion: true,
          label: message,
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(width: 4),
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(foregroundColor: accent),
                  child: Text(
                    actionLabel,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
}
