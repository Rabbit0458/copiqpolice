// lib/home/information_page.dart
// Page Informations — version robuste (envoi bug ok avec RLS/is_elevated)

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:copiqpolice/ui/app_notifier.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage>
    with SingleTickerProviderStateMixin {
  final _sb = Supabase.instance.client;

  // Conservés pour le payload (non affichés en "Build")
  String _appVersion = '—';
  String _device = '—';
  String _os = '—';

  // --- Données dynamiques BDD ---
  String _publicVersion = 'v1.0.0'; // fallback si BDD non dispo
  List<Map<String, dynamic>> _patchNotes = [];
  bool _loadingNotes = true;

  late final AnimationController _ac;
  late final Animation<double> _fadeAll;
  late final Animation<Offset> _slideAll;

  static const String _contactTo = 'contact@copiq.fr';

  @override
  void initState() {
    super.initState();
    _setupAnims();
    _bootstrapMeta();
    _loadPublicVersion();
    _loadPatchNotes();
  }

  void _setupAnims() {
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAll = CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic);
    _slideAll = Tween<Offset>(
      begin: const Offset(0, .06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _ac.forward());
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  Future<void> _bootstrapMeta() async {
    try {
      final p = await PackageInfo.fromPlatform();
      final d = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final a = await d.androidInfo;
        _device = '${a.manufacturer} ${a.model}';
        _os = 'Android ${a.version.release}';
      } else if (Platform.isIOS) {
        final i = await d.iosInfo;
        _device = i.utsname.machine ?? 'iPhone';
        _os = '${i.systemName} ${i.systemVersion}';
      } else {
        _device = Platform.operatingSystem;
        _os = Platform.operatingSystemVersion;
      }

      // Version seulement pour payload (pas d'affichage "Build")
      _appVersion = '${p.version}+${p.buildNumber}';
      if (mounted) setState(() {});
    } catch (_) {}
  }

  // --- Chargements depuis Supabase ---
  Future<void> _loadPublicVersion() async {
    try {
      final r = await _sb
          .from('app_meta')
          .select('value')
          .eq('key', 'app_version')
          .maybeSingle();

      final v = (r?['value'] as String?)?.trim();
      if (v != null && v.isNotEmpty) {
        if (mounted) setState(() => _publicVersion = v);
      }
    } catch (_) {
      // garde le fallback
    }
  }

  Future<void> _loadPatchNotes() async {
    try {
      final rows = await _sb
          .from('patch_notes')
          .select('id,title,body,is_published,created_at')
          .eq('is_published', true)
          .order('created_at', ascending: false)
          .limit(10);

      final list = (rows as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (mounted) {
        setState(() {
          _patchNotes = list;
          _loadingNotes = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingNotes = false);
    }
  }

  String get _email => _sb.auth.currentUser?.email ?? '';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Informations'), centerTitle: true),

      // Footer version (dynamique)
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 36,
          child: Center(
            child: Text(
              _publicVersion, // ex: "v1.0.3"
              style: t.textTheme.bodySmall?.copyWith(
                color: t.hintColor,
                letterSpacing: .3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAll,
          child: SlideTransition(
            position: _slideAll,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                // Header minimal : device + OS
                _MetaHeader(device: _device, os: _os),
                const SizedBox(height: 16),

                // Présentation (résumé) + bouton sheet
                _CardBlock(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Présentation',
                        style: t.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Plateforme IA pour la préparation concours (PA/GPX), la scolarité en école de police, "
                        "et l’aide opérationnelle des actifs. Génération de QCM, oraux simulés, fiches de révision, "
                        "cas pratiques, rédaction de PV, conseils procéduraux et tableau de bord personnalisé.",
                        style: t.textTheme.bodySmall?.copyWith(
                          color: t.hintColor,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _openFullPresentation,
                          child: const Text('Tout voir'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Tuiles actions
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.bug_report_rounded,
                      title: 'Signaler un bug',
                      subtitle: 'Rapport précis, priorisé et synchronisé',
                      onTap: () => _openBugSheet(context),
                    ),
                    _DividerInset(color: t.dividerColor.withOpacity(.35)),
                    _SettingsTile(
                      icon: Icons.mail_outline_rounded,
                      title: 'Contact',
                      subtitle: 'Envoyer un message au support',
                      onTap: () => _openContactSheet(context),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Patch-Notes
                _CardBlock(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patch-Notes',
                        style: t.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_loadingNotes)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: const [
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('Chargement…'),
                            ],
                          ),
                        )
                      else if (_patchNotes.isEmpty)
                        Text(
                          'Aucune mise à jour publiée pour le moment.',
                          style: t.textTheme.bodySmall?.copyWith(
                            color: t.hintColor,
                            height: 1.3,
                          ),
                        )
                      else ...[
                        ..._patchNotes
                            .take(3)
                            .map((n) => _PatchNoteItem(note: n)),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _openAllPatchNotes,
                            child: const Text('Tout l’historique'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------- Actions
  Future<void> _openBugSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _BugSheet(
        email: _email.isEmpty ? null : _email, // -> null si non connecté
        appVersion: _appVersion,
        device: _device,
        os: _os,
      ),
    );
  }

  Future<void> _openContactSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ContactSheet(
        email: _email,
        appVersion: _appVersion,
        device: _device,
        os: _os,
        toEmail: _contactTo,
      ),
    );
  }

  void _openFullPresentation() {
    final t = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _PresentationSheet(),
    );
  }

  void _openAllPatchNotes() {
    final t = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PatchNotesSheet(notes: _patchNotes),
    );
  }
}

// ================== UI blocs (style Profil) ==================

class _CardBlock extends StatelessWidget {
  final Widget child;
  const _CardBlock({required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: child,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(.08)
              : Colors.black.withOpacity(.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        subtitle,
        style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _DividerInset extends StatelessWidget {
  final Color color;
  const _DividerInset({required this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Divider(height: 1, color: color),
    );
  }
}

class _MetaHeader extends StatelessWidget {
  final String device;
  final String os;
  const _MetaHeader({required this.device, required this.os});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return _CardBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$device • $os',
            style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
          ),
        ],
      ),
    );
  }
}

// =============== Patch Notes UI ===============

class _PatchNoteItem extends StatelessWidget {
  final Map<String, dynamic> note;
  const _PatchNoteItem({required this.note});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final created = DateTime.tryParse('${note['created_at']}');
    final dateStr = created != null
        ? '${created.day.toString().padLeft(2, '0')}/${created.month.toString().padLeft(2, '0')}/${created.year}'
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${note['title'] ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '${note['body'] ?? ''}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: t.textTheme.bodySmall?.copyWith(
              color: t.hintColor,
              height: 1.35,
            ),
          ),
          if (dateStr.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                dateStr,
                style: t.textTheme.labelSmall?.copyWith(color: t.hintColor),
              ),
            ),
        ],
      ),
    );
  }
}

class _PatchNotesSheet extends StatelessWidget {
  final List<Map<String, dynamic>> notes;
  const _PatchNotesSheet({required this.notes});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final pad = MediaQuery.of(context).viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: pad),
      child: Material(
        color: t.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Text(
                  'Historique des mises à jour',
                  style: t.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  splashRadius: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...notes.map((n) {
              final created = DateTime.tryParse('${n['created_at']}');
              final dateStr = created != null
                  ? '${created.day.toString().padLeft(2, '0')}/${created.month.toString().padLeft(2, '0')}/${created.year}'
                  : '';
              return _CardBlock(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${n['title']}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    if (dateStr.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 8),
                        child: Text(
                          dateStr,
                          style: t.textTheme.labelSmall?.copyWith(
                            color: t.hintColor,
                          ),
                        ),
                      ),
                    Text(
                      '${n['body']}',
                      style: t.textTheme.bodySmall?.copyWith(
                        color: t.hintColor,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ================== Presentation Sheet ==================

class _PresentationSheet extends StatelessWidget {
  const _PresentationSheet();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final pad = MediaQuery.of(context).viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: pad),
      child: Material(
        color: t.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: const [
            _SheetHeader(title: 'Fonctions & Connaissances'),
            SizedBox(height: 10),
            _Section(
              title: '1. Module Prépa Concours (PA & GPX)',
              items: [
                "Programmes concours PA & GPX, QCM de culture générale",
                "Expression écrite (méthodo, orthographe, vocabulaire)",
                "Psychotechniques, cas pratiques, QCM de logique",
                "Tests physiques, grilles d’évaluation",
                "Oral : questions types & attentes du jury",
              ],
              capabilities: [
                "Générer des QCM illimités + correction auto",
                "Entraînements adaptatifs par faiblesse",
                "Explications claires des corrections",
                "Oraux simulés avec évaluation vocale",
                "Programme de révisions personnalisé",
                "Fiches de révisions auto (programmes/erreurs)",
              ],
            ),
            SizedBox(height: 12),
            _Section(
              title: '2. Module École de Police (scolarité)',
              items: [
                "Droit pénal, procédure pénale, administratif",
                "TSI (techniques d’intervention), déontologie",
                "Rédaction admin (PV, synthèses), gestion de conflit",
                "Tirs (théorie), secourisme, code de la route",
                "Institutions et organisation",
              ],
              capabilities: [
                "Quizz/tests par matière",
                "Résumés intelligents des cours",
                "Cas pratiques simulés",
                "Mémos visuels & fiches synthétiques",
                "Questions orales type école + évaluation vocale",
                "Exercices corrigés automatiquement",
                "Suivi des progrès, difficulté adaptative",
                "Questions libres à l’IA (par thème/examen/date)",
              ],
            ),
            SizedBox(height: 12),
            _Section(
              title: '3. Module Actifs (policiers en poste)',
              items: [
                "Modèles de PV par infraction",
                "Mises à jour code pénal, routier, procédure",
                "Formulaires/procédures, bases publiques (INSEE…)",
                "Jargon administratif & vocabulaire métier",
              ],
              capabilities: [
                "Générer un PV complet depuis quelques mots-clés",
                "Modèles modulables (dates/heures/lieux/unité…)",
                "Rappels de procédure (GAV, OPJ, alcootest, etc.)",
                "Réponses pratiques terrain",
                "Aide à la rédaction (rapports, mains courantes…)",
                "Traduction des termes administratifs",
              ],
            ),
            SizedBox(height: 12),
            _Section(
              title: '4. Suivi & Personnalisation',
              capabilities: [
                "Suivi des progrès (stats, courbes, jalons)",
                "Profil (PA/GPX/scolarité/affectation)",
                "Habitudes de révision mémorisées",
                "Adaptation exercices selon profil/niveau/objectif",
                "Dashboard perso (rappels, devoirs, examens blancs)",
              ],
            ),
            SizedBox(height: 12),
            _Section(
              title: '5. IA conversationnelle (général)',
              capabilities: [
                "Réponses concours/formation/procédures",
                "Aide dossiers admin (affectation, mutation…)",
                "Orientation vers textes de loi pertinents",
                "Explication de termes/ textes juridiques/ acronymes",
                "Aide gestion du stress, bien-être",
                "News métier (réformes, lois…)",
              ],
            ),
            SizedBox(height: 12),
            _Section(
              title: '6. Pistes futures',
              items: [
                "Calendrier concours / dates",
                "Upload de documents (PDF, notes de service)",
                "Vidéos pédagogiques",
                "Mise en relation élèves / formateurs",
                "Notifications intelligentes",
                "Forum / chat communautaire supervisé",
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  const _SheetHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        Text(
          title,
          style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          splashRadius: 18,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String>? items;
  final List<String>? capabilities;
  const _Section({required this.title, this.items, this.capabilities});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return _CardBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: t.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          if (items != null && items!.isNotEmpty) ...[
            ...items!.map((s) => _Bullet(text: s)),
            const SizedBox(height: 8),
          ],
          if (capabilities != null && capabilities!.isNotEmpty) ...[
            Text(
              'L’IA doit être capable de :',
              style: t.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ...capabilities!.map((s) => _Dash(text: s)),
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: t.textTheme.bodySmall),
          Expanded(
            child: Text(
              text,
              style: t.textTheme.bodySmall?.copyWith(
                color: t.hintColor,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dash extends StatelessWidget {
  final String text;
  const _Dash({required this.text});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('— ', style: t.textTheme.bodySmall),
          Expanded(
            child: Text(
              text,
              style: t.textTheme.bodySmall?.copyWith(
                color: t.hintColor,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== BUG SHEET ==================

class _BugSheet extends StatefulWidget {
  final String? email; // null si non connecté
  final String appVersion;
  final String device;
  final String os;

  const _BugSheet({
    required this.email,
    required this.appVersion,
    required this.device,
    required this.os,
  });

  @override
  State<_BugSheet> createState() => _BugSheetState();
}

class _BugSheetState extends State<_BugSheet> {
  final _title = TextEditingController();
  final _message = TextEditingController();
  String _category = 'Autre';
  String _severity = 'medium';
  bool _sending = false;

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  OutlineInputBorder get _border =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(14));

  String? _nn(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();

  Future<void> _submit() async {
    if (_sending) return;
    setState(() => _sending = true);

    try {
      final sb = Supabase.instance.client;
      final uid = sb.auth.currentUser?.id;

      // Normalisations
      final severity = (_severity.isEmpty ? 'medium' : _severity).toLowerCase();

      final payload = <String, dynamic>{
        'user_id': uid, // uuid | null
        'email': _nn(widget.email), // text | null
        'title': _nn(_title.text),
        'message': _nn(_message.text),
        'category': _nn(_category),
        'severity': severity, // low|medium|high|critical
        'status': 'new', // ✅ IMPORTANT (évite la violation du CHECK)
        'app_version': _nn(widget.appVersion),
        'device': _nn(widget.device),
        'os': _nn(widget.os),
        // attachments: null (non utilisé pour l’instant)
      };

      // Validation côté client
      final title = payload['title'] as String?;
      final message = payload['message'] as String?;
      if (title == null || message == null || message.length < 8) {
        AppNotifier.error(
          context,
          title: 'Champs manquants',
          message:
              'Décris le bug précisément (titre + message ≥ 8 caractères).',
        );
        setState(() => _sending = false);
        return;
      }

      // Insert
      await sb.from('bug_reports').insert(payload);

      // Alerte Edge (best-effort) si sévérité élevée
      if (severity == 'high' || severity == 'critical') {
        try {
          await sb.functions.invoke(
            'notify-bug',
            body: {
              ...payload,
              'email': payload['email'] ?? 'anonymous@copiq.app',
            },
          );
        } catch (_) {}
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      AppNotifier.success(
        context,
        title: 'Merci 🙏',
        message: 'Ton rapport de bug a été envoyé.',
      );
    } catch (e) {
      if (!mounted) return;
      AppNotifier.error(
        context,
        title: 'Envoi impossible',
        message: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final pad = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: pad),
      child: Material(
        color: t.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text(
              'Signaler un bug',
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Email : ${widget.email == null || widget.email!.isEmpty ? '—' : widget.email}',
              style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
            ),
            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: _category,
              items: const [
                'UI',
                'Performance',
                'Crash',
                'Données',
                'Autre',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              decoration: InputDecoration(
                labelText: 'Catégorie',
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
              onChanged: (v) => setState(() => _category = v ?? 'Autre'),
            ),

            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _severity,
              items:
                  const [
                        ['low', 'Mineur'],
                        ['medium', 'Normal'],
                        ['high', 'Important'],
                        ['critical', 'Critique'],
                      ]
                      .map(
                        (p) => DropdownMenuItem(value: p[0], child: Text(p[1])),
                      )
                      .toList(),
              decoration: InputDecoration(
                labelText: 'Sévérité',
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
              onChanged: (v) => setState(() => _severity = v ?? 'medium'),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _title,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Titre',
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _message,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Décris le problème',
                hintText: 'Étapes pour reproduire, résultat attendu…',
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _sending ? null : _submit,
                icon: _sending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: const Text('Envoyer le rapport'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== CONTACT SHEET ==================

class _ContactSheet extends StatefulWidget {
  final String email;
  final String appVersion;
  final String device;
  final String os;
  final String toEmail;

  const _ContactSheet({
    required this.email,
    required this.appVersion,
    required this.device,
    required this.os,
    required this.toEmail,
  });

  @override
  State<_ContactSheet> createState() => _ContactSheetState();
}

class _ContactSheetState extends State<_ContactSheet> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  OutlineInputBorder get _border =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(14));

  Future<void> _openMailtoFallback({
    required String subject,
    required String body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: widget.toEmail,
      queryParameters: {'subject': subject, 'body': body},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _submit() async {
    if (_sending) return;
    setState(() => _sending = true);

    try {
      final sb = Supabase.instance.client;
      final uid = sb.auth.currentUser?.id;
      final email = widget.email;

      final subject = _subject.text.trim();
      final message = _message.text.trim();

      if (subject.isEmpty || message.length < 5) {
        AppNotifier.error(
          context,
          title: 'Champs manquants',
          message: "Complète l'objet et le message.",
        );
        setState(() => _sending = false);
        return;
      }

      // Non connecté -> fallback direct
      if (email.isEmpty) {
        AppNotifier.warning(
          context,
          title: 'Non connecté',
          message: 'Ouverture de ton client mail…',
        );
        await _openMailtoFallback(subject: subject, body: message);
        if (mounted) Navigator.of(context).pop();
        return;
      }

      // Payload DB (sans 'to')
      final payloadDb = <String, dynamic>{
        'user_id': uid,
        'email': email,
        'subject': subject,
        'message': message,
        'app_version': widget.appVersion,
        'device': widget.device,
        'os': widget.os,
      };

      // Payload Edge (avec 'to')
      final payloadFn = <String, dynamic>{...payloadDb, 'to': widget.toEmail};

      // 1) Insert en BDD
      final res = await sb.from('contact_messages').insert(payloadDb);
      if (res is PostgrestException) throw res;

      // 2) Tentative d’envoi via Edge
      bool sent = false;
      try {
        await sb.functions.invoke('send-contact', body: payloadFn);
        sent = true;
      } catch (_) {
        sent = false;
      }

      if (!sent) {
        // 3) Fallback mailto
        AppNotifier.warning(
          context,
          title: 'Envoi alternatif',
          message:
              "Impossible d'envoyer via le serveur. On ouvre ton client mail…",
        );
        final meta =
            '\n\n—\nVersion: ${widget.appVersion}\nDevice: ${widget.device}\nOS: ${widget.os}\nUser: $email';
        await _openMailtoFallback(subject: subject, body: message + meta);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      AppNotifier.success(
        context,
        title: 'Message envoyé',
        message: 'Merci pour ton message.',
      );
    } catch (e) {
      if (!mounted) return;
      final msg = (e is PostgrestException)
          ? (e.message.isNotEmpty ? e.message : e.code ?? 'Erreur serveur')
          : e.toString();
      AppNotifier.error(
        context,
        title: 'Erreur',
        message: 'Envoi impossible : $msg',
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final pad = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: pad),
      child: Material(
        color: t.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text(
              'Contact',
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Email : ${widget.email.isEmpty ? '— (non connecté)' : widget.email}',
              style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _subject,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Objet',
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _message,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Message',
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _sending ? null : _submit,
                icon: _sending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: const Text('Envoyer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
