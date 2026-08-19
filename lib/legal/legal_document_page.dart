// lib/legal/legal_document_page.dart
//
// Page générique d'affichage d'un document légal Markdown venant de
// Supabase (public.information_contents). Une seule page pour tous les
// documents (mentions légales, CGU, CGV, confidentialité, cookies, charte
// communauté) — voir LegalDocumentKeys pour les clés disponibles.

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:copiqpolice/legal/legal_document.dart';
import 'package:copiqpolice/legal/legal_repository.dart';

class LegalDocumentPage extends StatefulWidget {
  final String documentKey;
  final String fallbackTitle;

  const LegalDocumentPage({
    super.key,
    required this.documentKey,
    this.fallbackTitle = 'Document',
  });

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

enum _LoadState { loading, loaded, empty, error }

class _LegalDocumentPageState extends State<LegalDocumentPage> {
  _LoadState _state = _LoadState.loading;
  LegalDocument? _doc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted && _doc == null) setState(() => _state = _LoadState.loading);
    try {
      final doc = await LegalRepository.I.getPublishedDocument(
        widget.documentKey,
      );
      if (!mounted) return;
      setState(() {
        _doc = doc;
        _state = doc == null ? _LoadState.empty : _LoadState.loaded;
      });
    } catch (_) {
      if (!mounted) return;
      if (_doc == null) {
        setState(() => _state = _LoadState.error);
      }
    }
  }

  Future<void> _refresh() async {
    try {
      final doc = await LegalRepository.I.refresh(widget.documentKey);
      if (!mounted) return;
      setState(() {
        if (doc != null) {
          _doc = doc;
          _state = _LoadState.loaded;
        } else if (_doc == null) {
          _state = _LoadState.empty;
        }
      });
    } catch (_) {}
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    const mois = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${d.day} ${mois[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_doc?.title ?? widget.fallbackTitle),
        centerTitle: true,
      ),
      body: SafeArea(child: _buildBody(t)),
    );
  }

  Widget _buildBody(ThemeData t) {
    switch (_state) {
      case _LoadState.loading:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Chargement du document…'),
              ],
            ),
          ),
        );

      case _LoadState.error:
        return _StatusMessage(
          icon: Icons.cloud_off_rounded,
          title: 'Impossible de charger ce document',
          message: 'Vérifiez votre connexion puis réessayez.',
          buttonLabel: 'Réessayer',
          onRetry: _load,
        );

      case _LoadState.empty:
        return _StatusMessage(
          icon: Icons.description_outlined,
          title: 'Document indisponible',
          message: "Ce document n'est pas disponible pour le moment.",
          buttonLabel: 'Réessayer',
          onRetry: _load,
        );

      case _LoadState.loaded:
        final doc = _doc!;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              if (doc.version != null || doc.publishedAt != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      if (doc.version != null)
                        _MetaChip(text: 'Version ${doc.version}'),
                      if (doc.publishedAt != null)
                        _MetaChip(
                          text:
                              'En vigueur depuis le ${_fmtDate(doc.publishedAt)}',
                        ),
                    ],
                  ),
                ),
              MarkdownBody(
                data: doc.bodyMd,
                selectable: true,
                onTapLink: (text, href, title) async {
                  if (href == null) return;
                  final uri = Uri.tryParse(href);
                  if (uri == null) return;
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                styleSheet: MarkdownStyleSheet.fromTheme(t).copyWith(
                  h1: t.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                  h2: t.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  h3: t.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  p: t.textTheme.bodyMedium?.copyWith(height: 1.55),
                  listBullet: t.textTheme.bodyMedium?.copyWith(height: 1.55),
                  a: TextStyle(
                    color: t.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Dernière mise à jour : ${_fmtDate(doc.updatedAt)}',
                style: t.textTheme.labelSmall?.copyWith(color: t.hintColor),
              ),
            ],
          ),
        );
    }
  }
}

class _MetaChip extends StatelessWidget {
  final String text;
  const _MetaChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: t.colorScheme.primary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: t.textTheme.labelSmall?.copyWith(
          color: t.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onRetry;

  const _StatusMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: t.hintColor),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: t.textTheme.bodySmall?.copyWith(color: t.hintColor),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
