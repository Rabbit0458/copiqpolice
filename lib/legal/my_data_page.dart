// lib/legal/my_data_page.dart
//
// "Mes données personnelles" — vue simple des infos de compte réelles
// (public.user_profiles) + export RGPD complet (Art. 20) via la RPC
// export_user_data() déjà exposée par AccountManagementService.exportData().
//
// N'affiche que des champs utiles à l'utilisateur (pas d'UUID technique, pas
// de token) : l'export JSON brut, lui, reste la voie normale et attendue
// pour la portabilité complète des données (RGPD Art. 20).

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/services/account_management_service.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart';

class MyDataPage extends StatefulWidget {
  const MyDataPage({super.key});

  @override
  State<MyDataPage> createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  final _sb = Supabase.instance.client;
  bool _loading = true;
  bool _exporting = false;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final row = await _sb
          .from('user_profiles')
          .select('email,first_name,last_name,city,created_at')
          .eq('user_id', user.id)
          .maybeSingle();
      if (mounted) setState(() => _profile = row);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final result = await AccountManagementService.I.exportData();
      if (!result.success) {
        throw Exception(result.errorMessage ?? result.errorCode);
      }
      final json = result.data?['json'] as String?;
      if (json == null || json.isEmpty) {
        throw Exception('Export vide');
      }
      final now = DateTime.now().toIso8601String().substring(0, 10);
      await Share.share(json, subject: "Mes données COP'IQ ($now)");
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: 'Export impossible',
        message: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  String _fmtDate(String? iso) {
    final d = DateTime.tryParse(iso ?? '');
    if (d == null) return '—';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes données personnelles')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
              children: [
                Text(
                  'Voici les informations liées à ton compte COP’IQ. Pour '
                  'obtenir l’intégralité de tes données (progression, '
                  'historique, forum…), utilise l’export ci-dessous.',
                  style: t.textTheme.bodySmall?.copyWith(
                    color: t.hintColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _DataRow(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        value:
                            '${_profile?['email'] ?? _sb.auth.currentUser?.email ?? '—'}',
                      ),
                      _DataRow(
                        icon: Icons.badge_outlined,
                        label: 'Nom',
                        value:
                            '${_profile?['first_name'] ?? ''} ${_profile?['last_name'] ?? ''}'
                                .trim()
                                .isEmpty
                            ? '—'
                            : '${_profile?['first_name'] ?? ''} ${_profile?['last_name'] ?? ''}',
                      ),
                      _DataRow(
                        icon: Icons.location_city_outlined,
                        label: 'Ville',
                        value: '${_profile?['city'] ?? '—'}',
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _DataRow(
                    icon: Icons.event_available_outlined,
                    label: 'Membre depuis',
                    value: _fmtDate(_profile?['created_at'] as String?),
                    showDivider: false,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _exporting ? null : _export,
                    icon: _exporting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_rounded),
                    label: Text(
                      _exporting
                          ? 'Préparation…'
                          : 'Exporter toutes mes données (JSON)',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Conformément au RGPD (Art. 20), cet export contient '
                  'l’intégralité des données liées à ton compte.',
                  textAlign: TextAlign.center,
                  style: t.textTheme.labelSmall?.copyWith(color: t.hintColor),
                ),
              ],
            ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: t.colorScheme.primary),
          title: Text(
            label,
            style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
          ),
          subtitle: Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(
              height: 1,
              color: t.dividerColor.withValues(alpha: .3),
            ),
          ),
      ],
    );
  }
}
