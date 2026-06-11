// lib/features/forum/member_picker_sheet.dart
//
// Bottom sheet réutilisable pour sélectionner un ou plusieurs membres
// (par leur username dans `user_profiles`).
//
// Usage :
//   final ids = await showModalBottomSheet<List<String>>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) => const MemberPickerSheet(
//       initialSelectedIds: [],
//       title: 'Choisir des membres',
//     ),
//   );

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemberPickerResult {
  final List<String> userIds;
  final List<String> usernames;
  const MemberPickerResult({required this.userIds, required this.usernames});
}

class MemberPickerSheet extends StatefulWidget {
  final List<String> initialSelectedIds;
  final String title;
  final bool allowMultiple;

  const MemberPickerSheet({
    super.key,
    this.initialSelectedIds = const [],
    this.title = 'Choisir des membres',
    this.allowMultiple = true,
  });

  @override
  State<MemberPickerSheet> createState() => _MemberPickerSheetState();
}

class _MemberPickerSheetState extends State<MemberPickerSheet> {
  final _sb = Supabase.instance.client;
  final _queryCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  Timer? _debounce;
  bool _loading = false;
  List<_UserRow> _results = [];

  final Set<String> _selected = {};
  final Map<String, String> _selectedUsernames = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.initialSelectedIds);
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _queryCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () => _search(v));
  }

  Future<void> _search(String q) async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final myId = _sb.auth.currentUser?.id;
      // Construction : on commence par le filter builder (qui supporte `.or`)
      // puis on applique `.limit()` (qui retourne un transform builder, lui
      // n'expose pas `.or`). C'est la nouvelle API supabase_flutter.
      final trimmed = q.trim();
      final query = (trimmed.isNotEmpty)
          ? _sb
              .from('user_profiles')
              .select('user_id, username, first_name, last_name')
              .or('username.ilike.%${trimmed}%,first_name.ilike.%${trimmed}%,last_name.ilike.%${trimmed}%')
              .limit(40)
          : _sb
              .from('user_profiles')
              .select('user_id, username, first_name, last_name')
              .limit(40);
      final rows = await query;
      final list = (rows as List)
          .map((e) => _UserRow.fromRow(e as Map<String, dynamic>))
          .where((u) => u.id != myId) // exclut soi-même
          .toList();
      if (!mounted) return;
      setState(() {
        _results = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _toggle(_UserRow u) {
    setState(() {
      if (_selected.contains(u.id)) {
        _selected.remove(u.id);
        _selectedUsernames.remove(u.id);
      } else {
        if (!widget.allowMultiple) {
          _selected.clear();
          _selectedUsernames.clear();
        }
        _selected.add(u.id);
        _selectedUsernames[u.id] = u.displayName;
      }
    });
  }

  void _confirm() {
    Navigator.of(context).pop(
      MemberPickerResult(
        userIds: _selected.toList(),
        usernames: _selected.map((id) => _selectedUsernames[id] ?? id).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF14171A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _selected.isEmpty ? null : _confirm,
                    child: Text('Valider (${_selected.length})'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _queryCtrl,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: 'Rechercher par username ou prénom',
                  filled: true,
                  fillColor: (isDark ? Colors.white : Colors.black).withValues(alpha: .04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun utilisateur trouvé.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: .6),
                              ),
                            ),
                          )
                        : ListView.separated(
                            controller: scrollCtrl,
                            itemCount: _results.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 4),
                            itemBuilder: (_, i) {
                              final u = _results[i];
                              final selected = _selected.contains(u.id);
                              return ListTile(
                                onTap: () => _toggle(u),
                                leading: CircleAvatar(
                                  child: Text(
                                    u.initials,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  u.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: u.username != null
                                    ? Text('@${u.username}')
                                    : null,
                                trailing: Icon(
                                  selected
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  color: selected
                                      ? theme.colorScheme.primary
                                      : null,
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserRow {
  final String id;
  final String? username;
  final String firstName;
  final String lastName;

  _UserRow({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory _UserRow.fromRow(Map<String, dynamic> r) => _UserRow(
        id: (r['user_id'] ?? '').toString(),
        username: r['username']?.toString(),
        firstName: (r['first_name'] ?? '').toString(),
        lastName: (r['last_name'] ?? '').toString(),
      );

  String get displayName {
    final fullName = '$firstName $lastName'.trim();
    if (fullName.isNotEmpty) return fullName;
    return username ?? id.substring(0, 6);
  }

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    final combo = '$f$l'.toUpperCase();
    if (combo.isNotEmpty) return combo;
    return (username ?? id).substring(0, 2).toUpperCase();
  }
}
