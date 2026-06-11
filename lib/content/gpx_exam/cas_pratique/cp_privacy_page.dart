// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Page Vie privée (RGPD)                                        ║
// ║  Tâche : CODE-079                                                        ║
// ║  RGPD Art. 17 (effacement) & Art. 20 (portabilité)                      ║
// ║                                                                          ║
// ║  2 fonctions principales :                                               ║
// ║    1. "Exporter mes données" → JSON téléchargeable                      ║
// ║    2. "Supprimer mon compte" → workflow 2 confirmations + code email    ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/cas_pratique_scaffold.dart';

// ---------------------------------------------------------------------------
// Service RGPD (appels edge functions)
// ---------------------------------------------------------------------------

class _RgpdService {
  _RgpdService._();
  static const _base = 'cas_pratique_';

  static SupabaseClient get _sb => Supabase.instance.client;

  /// Exporte toutes les données CP → JSON brut (String).
  static Future<String> exportUserData() async {
    final response = await _sb.functions.invoke(
      '${_base}export_user_data',
      method: HttpMethod.post,
    );
    if (response.status != 200) {
      final msg = _errorMsg(response.data);
      throw Exception(msg);
    }
    // response.data est déjà le JSON parsé par le SDK
    return const JsonEncoder.withIndent('  ').convert(response.data);
  }

  /// Demande l'envoi du code de suppression par email.
  static Future<void> requestDeletion() async {
    final response = await _sb.functions.invoke(
      '${_base}delete_user_data',
      method: HttpMethod.post,
      body: {'action': 'request'},
    );
    if (response.status != 200) {
      final msg = _errorMsg(response.data);
      throw Exception(msg);
    }
  }

  /// Confirme la suppression avec le code reçu par email.
  static Future<Map<String, dynamic>> confirmDeletion(String code) async {
    final response = await _sb.functions.invoke(
      '${_base}delete_user_data',
      method: HttpMethod.post,
      body: {'action': 'confirm', 'code': code},
    );
    if (response.status != 200) {
      final msg = _errorMsg(response.data);
      throw Exception(msg);
    }
    return Map<String, dynamic>.from(response.data as Map);
  }

  static String _errorMsg(dynamic data) {
    if (data is Map) {
      return (data['message'] as String?) ??
          (data['error'] as String?) ??
          'Erreur inconnue';
    }
    return 'Erreur inconnue';
  }
}

// ---------------------------------------------------------------------------
// Page principale
// ---------------------------------------------------------------------------

class CpPrivacyPage extends StatefulWidget {
  static const routeName = '/gpx_exam/concours/cas_pratique/privacy';

  const CpPrivacyPage({super.key});

  @override
  State<CpPrivacyPage> createState() => _CpPrivacyPageState();
}

class _CpPrivacyPageState extends State<CpPrivacyPage> {
  bool _exportLoading = false;
  bool _deleteLoading  = false;

  // ── Export ───────────────────────────────────────────────────────────────

  Future<void> _onExport() async {
    if (_exportLoading) return;
    setState(() => _exportLoading = true);
    try {
      final jsonString = await _RgpdService.exportUserData();

      // Écrire dans un fichier temporaire puis partager
      final dir = await getTemporaryDirectory();
      final now = DateTime.now().toIso8601String().substring(0, 10);
      final file = File('${dir.path}/copiq_mes_donnees_$now.json');
      await file.writeAsString(jsonString, encoding: utf8);

      if (!mounted) return;
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/json')],
        subject: 'Mes données COP\'IQ ($now)',
      );
    } catch (e) {
      if (!mounted) return;
      _showError('Export échoué : ${e.toString()}');
    } finally {
      if (mounted) setState(() => _exportLoading = false);
    }
  }

  // ── Suppression du compte — étape 1 : confirmation initiale ──────────────

  Future<void> _onDeleteRequest() async {
    if (_deleteLoading) return;

    // Dialog 1 : avertissement général
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ConfirmDeleteDialog1(),
    );
    if (ok != true || !mounted) return;

    setState(() => _deleteLoading = true);
    try {
      await _RgpdService.requestDeletion();
      if (!mounted) return;

      // Dialog 2 : saisie du code reçu par email
      final code = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _ConfirmDeleteDialog2(),
      );

      if (code == null || !mounted) {
        setState(() => _deleteLoading = false);
        return;
      }

      final result = await _RgpdService.confirmDeletion(code);
      if (!mounted) return;

      // Déconnexion locale (le compte est supprimé côté serveur)
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _DeletionSuccessDialog(report: result),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _deleteLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.montserrat(color: Colors.white)),
        backgroundColor: CpTokens.danger,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CasPratiqueScaffold(
      title: 'Vie privée',
      subtitle: 'Vos droits RGPD',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Intro ─────────────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              icon: Icons.shield_outlined,
              iconColor: CpTokens.info,
              title: 'Vos droits en tant qu\'utilisateur',
              body:
                  'COP\'IQ respecte le Règlement Général sur la Protection des '
                  'Données (RGPD — UE 2016/679). Vous disposez d\'un droit d\'accès, '
                  'de portabilité et d\'effacement de vos données personnelles.',
            ),

            const SizedBox(height: 20),

            // ── Contact RGPD ───────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              icon: Icons.email_outlined,
              iconColor: CpTokens.blueLight,
              title: 'Contact Délégué à la Protection des Données',
              body: 'privacy@copiq.fr\n'
                  'Délai de réponse : 30 jours maximum (Art. 12 RGPD).',
            ),

            const SizedBox(height: 32),

            // ── Export ────────────────────────────────────────────────────
            _ActionCard(
              isDark: isDark,
              icon: Icons.download_rounded,
              iconColor: CpTokens.success,
              title: 'Exporter mes données',
              subtitle: 'Art. 20 RGPD — Portabilité',
              description:
                  'Téléchargez un fichier JSON contenant l\'ensemble de vos '
                  'données : tentatives, réponses, corrections, appels, badges, XP. '
                  'Aucune donnée n\'est omise.',
              buttonLabel: 'Exporter en JSON',
              buttonIcon: Icons.download_rounded,
              buttonColor: CpTokens.success,
              loading: _exportLoading,
              onTap: _onExport,
            ),

            const SizedBox(height: 20),

            // ── Suppression ────────────────────────────────────────────────
            _ActionCard(
              isDark: isDark,
              icon: Icons.delete_forever_rounded,
              iconColor: CpTokens.danger,
              title: 'Supprimer mon compte',
              subtitle: 'Art. 17 RGPD — Droit à l\'effacement',
              description:
                  'Supprime définitivement votre compte et l\'intégralité de vos '
                  'données. Cette action est irréversible. Un code de confirmation '
                  'sera envoyé à votre adresse email.',
              buttonLabel: 'Demander la suppression',
              buttonIcon: Icons.delete_forever_rounded,
              buttonColor: CpTokens.danger,
              loading: _deleteLoading,
              onTap: _onDeleteRequest,
            ),

            const SizedBox(height: 32),

            // ── Durée de conservation ──────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              icon: Icons.schedule_rounded,
              iconColor: CpTokens.warning,
              title: 'Durée de conservation',
              body:
                  '• Données de compte : durée de la relation contractuelle + 3 ans\n'
                  '• Données pédagogiques : durée de la relation + 1 an\n'
                  '• Logs techniques : 90 jours\n'
                  '• Données anonymisées (statistiques) : durée indéfinie\n\n'
                  'Fondement légal : intérêt légitime (Art. 6.1.f RGPD) + '
                  'exécution du contrat (Art. 6.1.b RGPD).',
            ),

            const SizedBox(height: 20),

            // ── Droits supplémentaires ─────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              icon: Icons.gavel_rounded,
              iconColor: CpTokens.blueLight,
              title: 'Autres droits RGPD',
              body:
                  '• Droit d\'accès (Art. 15) : demandez une copie de vos données\n'
                  '• Droit de rectification (Art. 16) : corrigez vos données\n'
                  '• Droit à la limitation (Art. 18) : suspendez le traitement\n'
                  '• Droit d\'opposition (Art. 21) : opposez-vous au traitement\n'
                  '• Réclamation CNIL : www.cnil.fr\n\n'
                  'Pour exercer ces droits : privacy@copiq.fr',
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets helpers
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final surface = isDark
        ? CpTokens.surfaceContainerDark
        : CpTokens.surfaceContainerLight;
    final outline = isDark ? CpTokens.outlineDark : CpTokens.outlineLight;
    final onSurface = isDark ? CpTokens.onSurfaceDark : CpTokens.onSurfaceLight;
    final muted = isDark ? CpTokens.onSurfaceMutedDark : CpTokens.onSurfaceMutedLight;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outline, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.5,
                    color: muted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.buttonColor,
    required this.loading,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String description;
  final String buttonLabel;
  final IconData buttonIcon;
  final Color buttonColor;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surface = isDark
        ? CpTokens.surfaceContainerDark
        : CpTokens.surfaceContainerLight;
    final outline = isDark ? CpTokens.outlineDark : CpTokens.outlineLight;
    final onSurface = isDark ? CpTokens.onSurfaceDark : CpTokens.onSurfaceLight;
    final muted = isDark ? CpTokens.onSurfaceMutedDark : CpTokens.onSurfaceMutedLight;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: iconColor.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: isDark ? 0.06 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: GoogleFonts.montserrat(
              fontSize: 12.5,
              color: muted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: loading ? null : onTap,
              icon: loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    )
                  : Icon(buttonIcon, size: 18),
              label: Text(
                loading ? 'Veuillez patienter…' : buttonLabel,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: buttonColor.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog 1 : avertissement avant suppression
// ---------------------------------------------------------------------------

class _ConfirmDeleteDialog1 extends StatelessWidget {
  const _ConfirmDeleteDialog1();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.warning_rounded, color: CpTokens.danger, size: 28),
          const SizedBox(width: 10),
          Text(
            'Supprimer le compte ?',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
      content: Text(
        'Cette action est IRRÉVERSIBLE.\n\n'
        '• Toutes vos tentatives, corrections et réponses seront effacées.\n'
        '• Vos badges, XP et streaks seront perdus.\n'
        '• Votre compte ne pourra pas être récupéré.\n\n'
        'Un code de confirmation sera envoyé à votre email pour finaliser.',
        style: GoogleFonts.montserrat(fontSize: 13, height: 1.6),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Annuler',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: CpTokens.blueLight,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: CpTokens.danger,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Oui, envoyer le code',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog 2 : saisie du code reçu par email
// ---------------------------------------------------------------------------

class _ConfirmDeleteDialog2 extends StatefulWidget {
  const _ConfirmDeleteDialog2();

  @override
  State<_ConfirmDeleteDialog2> createState() => _ConfirmDeleteDialog2State();
}

class _ConfirmDeleteDialog2State extends State<_ConfirmDeleteDialog2> {
  final _ctrl = TextEditingController();
  bool _valid = false;
  bool _confirming = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    setState(() => _valid = v.trim().length == 6 && RegExp(r'^\d{6}$').hasMatch(v.trim()));
  }

  void _confirm() {
    if (!_valid || _confirming) return;
    setState(() => _confirming = true);
    Navigator.pop(context, _ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Code de confirmation',
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Un code à 6 chiffres a été envoyé à votre adresse email. '
            'Saisissez-le ci-dessous pour confirmer la suppression définitive.',
            style: GoogleFonts.montserrat(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            onChanged: _onChanged,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 10,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '000000',
              hintStyle: GoogleFonts.montserrat(
                fontSize: 28,
                color: Colors.grey.shade400,
                letterSpacing: 10,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: CpTokens.danger, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Le code expire dans 15 minutes.',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            'Annuler',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: CpTokens.blueLight,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: (_valid && !_confirming) ? _confirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: CpTokens.danger,
            foregroundColor: Colors.white,
            disabledBackgroundColor: CpTokens.danger.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: _confirming
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  'Supprimer définitivement',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog succès suppression
// ---------------------------------------------------------------------------

class _DeletionSuccessDialog extends StatelessWidget {
  const _DeletionSuccessDialog({required this.report});
  final Map<String, dynamic> report;

  @override
  Widget build(BuildContext context) {
    final attempts    = report['attempts_deleted']    ?? 0;
    final answers     = report['answers_deleted']     ?? 0;
    final corrections = report['corrections_deleted'] ?? 0;
    final appeals     = report['appeals_deleted']     ?? 0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: CpTokens.success, size: 28),
          const SizedBox(width: 10),
          Text(
            'Compte supprimé',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ],
      ),
      content: Text(
        'Votre compte et toutes vos données ont été supprimés conformément au RGPD Art. 17.\n\n'
        'Données effacées :\n'
        '• $attempts tentative(s)\n'
        '• $answers réponse(s)\n'
        '• $corrections correction(s)\n'
        '• $appeals appel(s)\n\n'
        'Merci d\'avoir utilisé COP\'IQ.',
        style: GoogleFonts.montserrat(fontSize: 13, height: 1.6),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Naviguer vers la racine (l'utilisateur est déconnecté)
            Navigator.of(context).popUntil((r) => r.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CpTokens.blueLight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Fermer',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );

  }
}
