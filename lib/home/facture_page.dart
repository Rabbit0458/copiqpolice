// lib/home/facture_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copiqpolice/ui/app_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum BillingStatus { paid, due, failed, refunded }

BillingStatus _statusFromDb(String s) {
  switch (s.toLowerCase()) {
    case 'paid':
      return BillingStatus.paid;
    case 'due':
      return BillingStatus.due;
    case 'failed':
      return BillingStatus.failed;
    case 'refunded':
      return BillingStatus.refunded;
    default:
      return BillingStatus.due;
  }
}

String _statusToDb(BillingStatus s) {
  switch (s) {
    case BillingStatus.paid:
      return 'paid';
    case BillingStatus.due:
      return 'due';
    case BillingStatus.failed:
      return 'failed';
    case BillingStatus.refunded:
      return 'refunded';
  }
}

class Invoice {
  final String id; // uuid (db) OR invoice_number (display)
  final String invoiceNumber;
  final DateTime createdAt;
  final int cents;
  final String currency;
  final BillingStatus status;
  final String? pdfUrl;
  final String? notes;

  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.createdAt,
    required this.cents,
    required this.currency,
    required this.status,
    this.pdfUrl,
    this.notes,
  });
}

class PaymentMethodPreview {
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;

  const PaymentMethodPreview({
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });
}

class BillingProfile {
  final String? billingName;
  final String? billingEmail;
  final String? billingAddress;
  final String? vatNumber;
  final bool autoInvoicesByMail;
  final bool notifyPaymentEvents;

  const BillingProfile({
    required this.billingName,
    required this.billingEmail,
    required this.billingAddress,
    required this.vatNumber,
    required this.autoInvoicesByMail,
    required this.notifyPaymentEvents,
  });

  BillingProfile copyWith({
    String? billingName,
    String? billingEmail,
    String? billingAddress,
    String? vatNumber,
    bool? autoInvoicesByMail,
    bool? notifyPaymentEvents,
  }) {
    return BillingProfile(
      billingName: billingName ?? this.billingName,
      billingEmail: billingEmail ?? this.billingEmail,
      billingAddress: billingAddress ?? this.billingAddress,
      vatNumber: vatNumber ?? this.vatNumber,
      autoInvoicesByMail: autoInvoicesByMail ?? this.autoInvoicesByMail,
      notifyPaymentEvents: notifyPaymentEvents ?? this.notifyPaymentEvents,
    );
  }
}

class SubscriptionInfo {
  final String plan;
  final String status; // active/canceled/past_due

  const SubscriptionInfo({required this.plan, required this.status});
}

/// ===========================================================================
/// Repository Supabase (tu peux remplacer par ton backend Stripe plus tard)
/// ===========================================================================

class BillingRepo {
  BillingRepo(this.sb);
  final SupabaseClient sb;

  Future<BillingProfile> loadProfileOrCreate() async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) throw Exception("Not authenticated");

    final row = await sb
        .from('billing_profiles')
        .select()
        .eq('user_id', uid)
        .maybeSingle();

    if (row == null) {
      await sb.from('billing_profiles').insert({
        'user_id': uid,
        'auto_invoices_by_mail': true,
        'notify_payment_events': true,
      });

      await sb.from('billing_events').insert({
        'user_id': uid,
        'event_type': 'profile.created',
        'payload': {},
      });

      return const BillingProfile(
        billingName: null,
        billingEmail: null,
        billingAddress: null,
        vatNumber: null,
        autoInvoicesByMail: true,
        notifyPaymentEvents: true,
      );
    }

    return BillingProfile(
      billingName: row['billing_name'] as String?,
      billingEmail: row['billing_email'] as String?,
      billingAddress: row['billing_address'] as String?,
      vatNumber: row['vat_number'] as String?,
      autoInvoicesByMail: (row['auto_invoices_by_mail'] as bool?) ?? true,
      notifyPaymentEvents: (row['notify_payment_events'] as bool?) ?? true,
    );
  }

  Future<void> updateProfile(BillingProfile p) async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) throw Exception("Not authenticated");

    await sb
        .from('billing_profiles')
        .update({
          'billing_name': p.billingName,
          'billing_email': p.billingEmail,
          'billing_address': p.billingAddress,
          'vat_number': p.vatNumber,
          'auto_invoices_by_mail': p.autoInvoicesByMail,
          'notify_payment_events': p.notifyPaymentEvents,
        })
        .eq('user_id', uid);

    await sb.from('billing_events').insert({
      'user_id': uid,
      'event_type': 'profile.updated',
      'payload': {
        'billing_name': p.billingName,
        'billing_email': p.billingEmail,
      },
    });
  }

  Future<PaymentMethodPreview?> loadDefaultPaymentMethod() async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) throw Exception("Not authenticated");

    final row = await sb
        .from('billing_payment_methods')
        .select()
        .eq('user_id', uid)
        .eq('is_default', true)
        .order('created_at', ascending: false)
        .maybeSingle();

    if (row == null) return null;

    return PaymentMethodPreview(
      brand: (row['brand'] as String?) ?? 'Carte',
      last4: (row['last4'] as String?) ?? '0000',
      expMonth: (row['exp_month'] as int?) ?? 12,
      expYear: (row['exp_year'] as int?) ?? 2099,
    );
  }

  Future<void> upsertPaymentMethod(PaymentMethodPreview pm) async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) throw Exception("Not authenticated");

    // simple: on insert une nouvelle "default"
    await sb
        .from('billing_payment_methods')
        .update({'is_default': false})
        .eq('user_id', uid);

    await sb.from('billing_payment_methods').insert({
      'user_id': uid,
      'brand': pm.brand,
      'last4': pm.last4,
      'exp_month': pm.expMonth,
      'exp_year': pm.expYear,
      'is_default': true,
    });

    await sb.from('billing_events').insert({
      'user_id': uid,
      'event_type': 'payment_method.updated',
      'payload': {
        'brand': pm.brand,
        'last4': pm.last4,
        'exp_month': pm.expMonth,
        'exp_year': pm.expYear,
      },
    });
  }

  Future<SubscriptionInfo> loadSubscriptionOrDefault() async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) throw Exception("Not authenticated");

    final row = await sb
        .from('billing_subscriptions')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .maybeSingle();

    if (row == null) {
      // default subscription record
      await sb.from('billing_subscriptions').insert({
        'user_id': uid,
        'plan': 'Pro Mensuel',
        'status': 'active',
      });

      await sb.from('billing_events').insert({
        'user_id': uid,
        'event_type': 'subscription.created',
        'payload': {'plan': 'Pro Mensuel'},
      });

      return const SubscriptionInfo(plan: 'Pro Mensuel', status: 'active');
    }

    return SubscriptionInfo(
      plan: (row['plan'] as String?) ?? 'Pro Mensuel',
      status: (row['status'] as String?) ?? 'active',
    );
  }

  Future<void> updateSubscriptionPlan(String plan) async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) throw Exception("Not authenticated");

    // update latest sub
    final row = await sb
        .from('billing_subscriptions')
        .select('id')
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (row == null) {
      await sb.from('billing_subscriptions').insert({
        'user_id': uid,
        'plan': plan,
        'status': 'active',
      });
    } else {
      await sb
          .from('billing_subscriptions')
          .update({'plan': plan})
          .eq('id', row['id']);
    }

    await sb.from('billing_events').insert({
      'user_id': uid,
      'event_type': 'subscription.plan_changed',
      'payload': {'plan': plan},
    });
  }

  Future<List<Invoice>> loadInvoices({
    BillingStatus? status,
    String? query,
  }) async {
    final uid = sb.auth.currentUser?.id;
    if (uid == null) throw Exception("Not authenticated");

    var q = sb.from('billing_invoices').select().eq('user_id', uid);

    if (status != null) {
      q = q.eq('status', _statusToDb(status));
    }

    // Supabase query builder doesn't support full-text here by default;
    // we filter client-side for query.
    final rows = await q.order('created_at', ascending: false).limit(200);

    final list = rows.map((r) {
      final createdAt =
          DateTime.tryParse((r['created_at'] ?? '').toString()) ??
          DateTime.now();
      return Invoice(
        id: r['id'].toString(),
        invoiceNumber: (r['invoice_number'] as String?) ?? 'INV',
        createdAt: createdAt,
        cents: (r['amount_cents'] as int?) ?? 0,
        currency: (r['currency'] as String?) ?? 'EUR',
        status: _statusFromDb((r['status'] as String?) ?? 'due'),
        pdfUrl: r['pdf_url'] as String?,
        notes: r['notes'] as String?,
      );
    }).toList();

    final qq = (query ?? '').trim().toLowerCase();
    if (qq.isEmpty) return list;

    return list.where((i) {
      return i.invoiceNumber.toLowerCase().contains(qq) ||
          (i.notes ?? '').toLowerCase().contains(qq);
    }).toList();
  }
}

/// ===========================================================================
/// UI
/// ===========================================================================

class FacturePage extends StatefulWidget {
  static const routeName = '/factures';
  const FacturePage({super.key});

  @override
  State<FacturePage> createState() => _FacturePageState();
}

class _FacturePageState extends State<FacturePage> {
  final BillingRepo _repo = BillingRepo(Supabase.instance.client);

  bool _loading = true;
  String? _error;

  BillingProfile? _profile;
  PaymentMethodPreview? _pm;
  SubscriptionInfo? _sub;
  List<Invoice> _invoices = const [];

  final TextEditingController _searchCtl = TextEditingController();
  BillingStatus? _statusFilter;

  bool _autoInvoicesByMail = true;
  bool _notifyPaymentEvents = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _stroke =>
      _isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);

  Future<void> _bootstrap() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _repo.loadProfileOrCreate(), // BillingProfile
        _repo.loadDefaultPaymentMethod(), // PaymentMethodPreview?
        _repo.loadSubscriptionOrDefault(), // SubscriptionInfo
        _repo.loadInvoices(), // List<Invoice>
      ]);

      if (!mounted) return;

      final profile = results[0] as BillingProfile;
      final pm = results[1] as PaymentMethodPreview?;
      final sub = results[2] as SubscriptionInfo;
      final inv = results[3] as List<Invoice>;

      setState(() {
        _profile = profile;
        _pm = pm;
        _sub = sub;
        _invoices = inv;

        _autoInvoicesByMail = profile.autoInvoicesByMail;
        _notifyPaymentEvents = profile.notifyPaymentEvents;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      AppNotifier.error(context, title: "Erreur", message: e.toString());
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  List<Invoice> _filteredInvoices() {
    final q = _searchCtl.text.trim().toLowerCase();
    final f = _statusFilter;

    final list = _invoices.where((i) {
      final okFilter = f == null || i.status == f;
      final okQuery = q.isEmpty
          ? true
          : (i.invoiceNumber.toLowerCase().contains(q) ||
                (i.notes ?? '').toLowerCase().contains(q));
      return okFilter && okQuery;
    }).toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  String _statusLabel(BillingStatus s) {
    switch (s) {
      case BillingStatus.paid:
        return 'Payée';
      case BillingStatus.due:
        return 'À payer';
      case BillingStatus.failed:
        return 'Échouée';
      case BillingStatus.refunded:
        return 'Remboursée';
    }
  }

  Color _statusColor(BillingStatus s) {
    final cs = Theme.of(context).colorScheme;
    switch (s) {
      case BillingStatus.paid:
        return const Color(0xFF2F9E44);
      case BillingStatus.due:
        return cs.primary;
      case BillingStatus.failed:
        return const Color(0xFFE03131);
      case BillingStatus.refunded:
        return const Color(0xFFF08C00);
    }
  }

  Future<void> _savePrefs() async {
    final p = _profile;
    if (p == null) return;

    try {
      final updated = p.copyWith(
        autoInvoicesByMail: _autoInvoicesByMail,
        notifyPaymentEvents: _notifyPaymentEvents,
      );
      await _repo.updateProfile(updated);
      setState(() => _profile = updated);
    } catch (e) {
      AppNotifier.error(context, title: "Erreur", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _bootstrap,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            children: [
              _BillingHeader(
                title: "Facturation",
                onBack: () => Navigator.of(context).maybePop(),
                onHelp: () {
                  HapticFeedback.selectionClick();
                  AppNotifier.info(
                    context,
                    title: "Aide",
                    message:
                        "Gère ton abonnement, tes coordonnées, ton paiement et tes factures.",
                  );
                },
              ),
              const SizedBox(height: 14),

              if (_loading) ...[
                _skeletonCard(),
                const SizedBox(height: 10),
                _skeletonCard(),
              ] else if (_error != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFE03131,
                    ).withOpacity(_isDark ? 0.14 : 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE03131).withOpacity(0.28),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFE03131),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                _SectionCard(
                  title: "Abonnement",
                  subtitle: _sub?.plan ?? "—",
                  meta: _sub?.status ?? "—",
                  leading: const Icon(Icons.workspace_premium_rounded),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    // à toi: ouvrir ton picker et appeler _repo.updateSubscriptionPlan(plan)
                  },
                ),

                const SizedBox(height: 10),

                _SectionCard(
                  title: "Coordonnées",
                  subtitle: _profile?.billingName?.trim().isNotEmpty == true
                      ? _profile!.billingName!
                      : "—",
                  meta: _profile?.billingEmail?.trim().isNotEmpty == true
                      ? _profile!.billingEmail!
                      : "—",
                  leading: const Icon(Icons.receipt_long_rounded),
                  trailing: IconButton(
                    tooltip: "Modifier",
                    onPressed: () {
                      // à toi: ouvrir le sheet et appeler _repo.updateProfile(...)
                    },
                    icon: const Icon(Icons.edit_rounded),
                  ),
                  onTap: () {},
                ),

                const SizedBox(height: 10),

                _SectionCard(
                  title: "Paiement",
                  subtitle: _pm == null
                      ? "Aucun moyen de paiement"
                      : "${_pm!.brand} •••• ${_pm!.last4}",
                  meta: _pm == null
                      ? "Ajoute une carte pour activer la facturation auto"
                      : "Exp ${_pm!.expMonth.toString().padLeft(2, '0')}/${(_pm!.expYear % 100).toString().padLeft(2, '0')}",
                  leading: const Icon(Icons.credit_card_rounded),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),

                const SizedBox(height: 14),
                Divider(color: _stroke),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Factures",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    PopupMenuButton<BillingStatus?>(
                      tooltip: "Filtrer",
                      onSelected: (v) => setState(() => _statusFilter = v),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: null, child: Text("Toutes")),
                        PopupMenuItem(
                          value: BillingStatus.paid,
                          child: Text(_statusLabel(BillingStatus.paid)),
                        ),
                        PopupMenuItem(
                          value: BillingStatus.due,
                          child: Text(_statusLabel(BillingStatus.due)),
                        ),
                        PopupMenuItem(
                          value: BillingStatus.failed,
                          child: Text(_statusLabel(BillingStatus.failed)),
                        ),
                        PopupMenuItem(
                          value: BillingStatus.refunded,
                          child: Text(_statusLabel(BillingStatus.refunded)),
                        ),
                      ],
                      child: const Icon(Icons.tune_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _stroke),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: theme.iconTheme.color?.withOpacity(0.70),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchCtl,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: "Rechercher (N°, note)…",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_searchCtl.text.trim().isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _searchCtl.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded, size: 18),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Builder(
                  builder: (_) {
                    final items = _filteredInvoices();
                    if (items.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _stroke),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "Aucune facture ne correspond à la recherche.",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // tu peux réutiliser ton tile pro ou minimal
                    return Column(
                      children: [
                        for (final inv in items) ...[
                          _InvoiceTilePro(
                            invoice: inv,
                            amount:
                                "${(inv.cents / 100).toStringAsFixed(2)} ${inv.currency}",
                            statusLabel: _statusLabel(inv.status),
                            statusColor: _statusColor(inv.status),
                            onDownload: () {},
                            onSendMail: () {},
                            onRetryPayment:
                                (inv.status == BillingStatus.due ||
                                    inv.status == BillingStatus.failed)
                                ? () {}
                                : null,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    );
                  },
                ),

                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _stroke),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: _autoInvoicesByMail,
                        title: const Text(
                          "Recevoir automatiquement les factures par e-mail",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onChanged: (v) async {
                          setState(() => _autoInvoicesByMail = v);
                          await _savePrefs();
                        },
                      ),
                      Divider(color: _stroke),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: _notifyPaymentEvents,
                        title: const Text(
                          "Notifications des événements de paiement",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onChanged: (v) async {
                          setState(() => _notifyPaymentEvents = v);
                          await _savePrefs();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _skeletonCard() {
    final theme = Theme.of(context);
    final base = _isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.06);

    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _stroke),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 160,
                    height: 10,
                    decoration: BoxDecoration(
                      color: base,
                      borderRadius: BorderRadius.circular(999),
                    ),
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

/// ===============================
/// Components (Premium & safe)
/// ===============================

class _BillingHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onHelp;

  const _BillingHeader({
    required this.title,
    required this.onBack,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _IconPillButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _IconPillButton(icon: Icons.help_outline_rounded, onTap: onHelp),
      ],
    );
  }
}

class _IconPillButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconPillButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.dividerColor.withOpacity(.18)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(
                theme.brightness == Brightness.dark ? .30 : .08,
              ),
            ),
          ],
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? meta;
  final Widget leading;
  final Widget trailing;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
    required this.onTap,
    this.meta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final stroke = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.06);

    final iconBg = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: stroke),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: IconTheme(
                  data: IconThemeData(
                    size: 20,
                    color: theme.iconTheme.color?.withOpacity(0.85),
                  ),
                  child: leading,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (meta != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        meta!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.75,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String k;
  final String v;
  final bool multiline;

  const _KeyValue({required this.k, required this.v, this.multiline = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          // On évite “Row overflow” en adaptant automatiquement
          final narrow = constraints.maxWidth < 360;

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  k,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface.withOpacity(.75),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  v,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: multiline
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 4,
                child: Text(
                  k,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface.withOpacity(.72),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                flex: 6,
                child: Text(
                  v,
                  maxLines: multiline ? 6 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color tone;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone.withOpacity(
          theme.brightness == Brightness.dark ? .12 : .10,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tone.withOpacity(.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: tone),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(.85),
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

class _PaymentCard extends StatelessWidget {
  final PaymentMethodPreview pm;
  const _PaymentCard({required this.pm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(.18)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.credit_card_rounded,
            color: theme.colorScheme.onSurface.withOpacity(.9),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${pm.brand} •••• ${pm.last4} • exp ${pm.expMonth.toString().padLeft(2, '0')}/${(pm.expYear % 100).toString().padLeft(2, '0')}',
              style: const TextStyle(fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(
                  theme.brightness == Brightness.dark ? .22 : .14,
                )
              : theme.colorScheme.surfaceContainerHighest.withOpacity(.35),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? color.withOpacity(.55)
                : theme.dividerColor.withOpacity(.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_rounded, size: 16, color: color),
              const SizedBox(width: 6),
            ],
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _InvoiceTilePro extends StatelessWidget {
  final Invoice invoice;
  final String amount;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onDownload;
  final VoidCallback onSendMail;
  final VoidCallback? onRetryPayment;

  const _InvoiceTilePro({
    required this.invoice,
    required this.amount,
    required this.statusLabel,
    required this.statusColor,
    required this.onDownload,
    required this.onSendMail,
    this.onRetryPayment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(.18)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? .30 : .08,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      child: Row(
        children: [
          // status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(
                theme.brightness == Brightness.dark ? .16 : .10,
              ),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: statusColor.withOpacity(.55)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusIcon(invoice.status), size: 16, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_date(invoice.createdAt)} • $amount',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withOpacity(.70),
                  ),
                ),
                if ((invoice.notes ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    invoice.notes!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withOpacity(.85),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          PopupMenuButton<String>(
            tooltip: 'Actions',
            onSelected: (v) {
              switch (v) {
                case 'download':
                  onDownload();
                  break;
                case 'send':
                  onSendMail();
                  break;
                case 'retry':
                  onRetryPayment?.call();
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Télécharger le PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'send',
                child: Row(
                  children: [
                    Icon(Icons.forward_to_inbox_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Envoyer par e-mail'),
                  ],
                ),
              ),
              if (onRetryPayment != null)
                const PopupMenuItem(
                  value: 'retry',
                  child: Row(
                    children: [
                      Icon(Icons.refresh_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Relancer le paiement'),
                    ],
                  ),
                ),
            ],
            child: Container(
              height: 42,
              width: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  .35,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.dividerColor.withOpacity(.18)),
              ),
              child: Icon(
                Icons.more_horiz_rounded,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _date(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  static IconData _statusIcon(BillingStatus s) {
    switch (s) {
      case BillingStatus.paid:
        return Icons.verified_rounded;
      case BillingStatus.due:
        return Icons.hourglass_bottom_rounded;
      case BillingStatus.failed:
        return Icons.error_outline_rounded;
      case BillingStatus.refunded:
        return Icons.reply_rounded;
    }
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final int maxLines;

  const _LabeledField({
    required this.label,
    required this.controller,
    this.keyboard,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: t.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: t.colorScheme.surfaceContainerHighest.withOpacity(.55),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: t.dividerColor.withOpacity(.25)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: t.dividerColor.withOpacity(.25)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      height: 4,
      width: 44,
      decoration: BoxDecoration(
        color: t.dividerColor.withOpacity(.55),
        borderRadius: BorderRadius.circular(999),
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
        Expanded(
          child: Text(
            title,
            style: t.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
