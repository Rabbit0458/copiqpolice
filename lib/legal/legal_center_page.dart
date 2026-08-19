// lib/legal/legal_center_page.dart
//
// Centre juridique et confidentialité — accessible depuis la page profil
// (lib/features/home/profil_page.dart). Regroupe l'accès aux documents
// légaux dynamiques (Supabase), aux données personnelles, à la suppression
// de compte et à l'abonnement. Aucun texte légal n'est stocké ici : chaque
// tuile ouvre soit LegalDocumentPage (contenu Supabase), soit un écran
// existant déjà fonctionnel dans l'app (pas de duplication de logique).

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:copiqpolice/features/home/abonnement_page.dart';
import 'package:copiqpolice/features/home/annulation_conditions_page.dart';
import 'package:copiqpolice/features/home/information_page.dart';
import 'package:copiqpolice/features/home/user_page.dart';
import 'package:copiqpolice/legal/legal_document_keys.dart';
import 'package:copiqpolice/legal/legal_document_page.dart';
import 'package:copiqpolice/legal/legal_widgets.dart';
import 'package:copiqpolice/legal/my_data_page.dart';

const String kCopiqContactEmail = 'contact@copiq.fr';

class LegalCenterPage extends StatefulWidget {
  const LegalCenterPage({super.key});

  static const routeName = '/legal-center';

  @override
  State<LegalCenterPage> createState() => _LegalCenterPageState();
}

class _LegalCenterPageState extends State<LegalCenterPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  static const int _staggerCount = 6; // hero + 5 sections
  static const double _staggerOffset = 0.09;
  static const double _staggerSpan = 0.55;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Animation<double> _stagger(int index) {
    final start = (index * _staggerOffset).clamp(0.0, 1.0);
    final end = (start + _staggerSpan).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  void _openDocument(BuildContext context, String documentKey, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            LegalDocumentPage(documentKey: documentKey, fallbackTitle: title),
      ),
    );
  }

  Future<void> _contactMail(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: kCopiqContactEmail);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openRights(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _RightsSheet(onContact: () => _contactMail(ctx)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations légales'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _FadeSlideIn(
            animation: _stagger(0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 22),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    t.colorScheme.primary.withValues(alpha: isDark ? .22 : .12),
                    t.colorScheme.primary.withValues(alpha: isDark ? .06 : .03),
                  ],
                ),
                border: Border.all(
                  color: t.colorScheme.primary.withValues(alpha: .14),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: t.colorScheme.primary.withValues(alpha: .16),
                    ),
                    child: Icon(
                      Icons.verified_user_rounded,
                      color: t.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confidentialité & conditions',
                          style: t.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Retrouve tes informations de confidentialité, les "
                          "conditions d'utilisation de COP'IQ et les outils "
                          "pour gérer tes données.",
                          style: t.textTheme.bodySmall?.copyWith(
                            color: t.hintColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          _FadeSlideIn(
            animation: _stagger(1),
            child: LegalSection(
              title: 'Confidentialité',
              icon: Icons.lock_outline_rounded,
              children: [
                LegalSettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Politique de confidentialité',
                  subtitle: "Comment COP'IQ utilise et protège tes données",
                  showDivider: true,
                  onTap: () => _openDocument(
                    context,
                    LegalDocumentKeys.privacyPolicy,
                    'Politique de confidentialité',
                  ),
                ),
                LegalSettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Mes données personnelles',
                  subtitle: 'Comprendre les données liées à ton compte',
                  showDivider: true,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const MyDataPage())),
                ),
                LegalSettingsTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Supprimer mon compte',
                  subtitle: 'Suppression définitive du compte et des données',
                  isDestructive: true,
                  showDivider: false,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const UserPage())),
                ),
              ],
            ),
          ),

          _FadeSlideIn(
            animation: _stagger(2),
            child: LegalSection(
              title: 'Conditions',
              icon: Icons.description_outlined,
              children: [
                LegalSettingsTile(
                  icon: Icons.description_outlined,
                  title: "Conditions générales d'utilisation",
                  showDivider: true,
                  onTap: () => _openDocument(
                    context,
                    LegalDocumentKeys.termsOfUse,
                    "Conditions générales d'utilisation",
                  ),
                ),
                LegalSettingsTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Conditions générales de vente',
                  showDivider: true,
                  onTap: () => _openDocument(
                    context,
                    LegalDocumentKeys.termsOfSale,
                    'Conditions générales de vente',
                  ),
                ),
                LegalSettingsTile(
                  icon: Icons.groups_outlined,
                  title: 'Règles de la communauté',
                  showDivider: false,
                  onTap: () => _openDocument(
                    context,
                    LegalDocumentKeys.communityGuidelines,
                    'Règles de la communauté',
                  ),
                ),
              ],
            ),
          ),

          _FadeSlideIn(
            animation: _stagger(3),
            child: LegalSection(
              title: 'Informations',
              icon: Icons.info_outline_rounded,
              children: [
                LegalSettingsTile(
                  icon: Icons.gavel_rounded,
                  title: 'Mentions légales',
                  showDivider: true,
                  onTap: () => _openDocument(
                    context,
                    LegalDocumentKeys.legalNotice,
                    'Mentions légales',
                  ),
                ),
                LegalSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: "À propos de COP'IQ",
                  showDivider: false,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const InformationPage()),
                  ),
                ),
              ],
            ),
          ),

          _FadeSlideIn(
            animation: _stagger(4),
            child: LegalSection(
              title: 'Abonnement',
              icon: Icons.workspace_premium_outlined,
              children: [
                LegalSettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Gérer mon abonnement',
                  showDivider: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AbonnementPage()),
                  ),
                ),
                LegalSettingsTile(
                  icon: Icons.rule_folder_outlined,
                  title: "Conditions de l'abonnement",
                  showDivider: false,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AnnulationConditionsPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          _FadeSlideIn(
            animation: _stagger(5),
            child: LegalSection(
              title: 'Assistance',
              icon: Icons.support_agent_rounded,
              children: [
                LegalSettingsTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Exercer mes droits',
                  subtitle: 'Accès, rectification, suppression, opposition',
                  showDivider: true,
                  onTap: () => _openRights(context),
                ),
                LegalSettingsTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Nous contacter',
                  showDivider: false,
                  onTap: () => _contactMail(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fondu + léger glissement vertical à l'entrée — anime uniquement
/// opacity/transform (perf-friendly, pas de relayout).
class _FadeSlideIn extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _FadeSlideIn({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 18),
            child: child,
          ),
        );
      },
    );
  }
}

class _RightsSheet extends StatelessWidget {
  final VoidCallback onContact;
  const _RightsSheet({required this.onContact});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final pad = MediaQuery.of(context).viewPadding.bottom;

    const rights = [
      ["Droit d'accès", 'Obtenir une copie de tes données personnelles'],
      ['Droit de rectification', 'Corriger des données inexactes'],
      ['Droit à l\'effacement', 'Demander la suppression de tes données'],
      ['Droit d\'opposition', "T'opposer à certains traitements"],
      [
        'Droit à la portabilité',
        'Recevoir tes données dans un format exploitable',
      ],
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: pad),
      child: Material(
        color: t.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Row(
              children: [
                Text(
                  'Exercer mes droits',
                  style: t.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...rights.map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: t.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r[0],
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            r[1],
                            style: t.textTheme.bodySmall?.copyWith(
                              color: t.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onContact();
                },
                icon: const Icon(Icons.mail_outline_rounded),
                label: const Text('Contacter COP’IQ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
