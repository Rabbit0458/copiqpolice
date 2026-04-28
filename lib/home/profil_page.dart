// lib/home/profil_page.dart
//
// PROD v4 — Profil complet + session fiable + logs enrichis (Web/Desktop/Mobile)
// - Table: public.user_profiles
// - Champs: user_id, email, first_name, last_name, city, phone, avatar_index, username, birthday, created_at, updated_at
// - Session robuste via polling/backoff + écoute onAuthStateChange
// - Popup OBLIGATOIRE tant que profil incomplet (aucun flag local bloquant)
// - Username: validation + vérif disponibilité + index unique côté DB
// - Upsert onConflict:'user_id' ; synchro silencieuse de l'email Auth
// - Logs: utilise AppConsoleLogger (table public.app_logs) avec event/context/error_json
// - Design dark/light, fluide, pro ; loader animé “Apple-like”
// - 100 % compatible Supabase actuel
//
// Dépendances: supabase_flutter, shared_preferences, cupertino, device_info_plus
//
// IMPORTANT : AppConsoleLogger doit être initialisé une fois au boot de l’app :
//   await AppConsoleLogger.init(version: '1.0.0', build: '1', env: 'production', initHooks: true);

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:copiqpolice/home/abonnement_page.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart';
import 'package:copiqpolice/home/parametre_home.dart';
import 'package:copiqpolice/home/information_page.dart';
import 'package:copiqpolice/home/facture_page.dart';
import 'package:copiqpolice/home/user_page.dart';
import 'package:copiqpolice/onboarding/onboarding_screen.dart';

// <-- Logger centralisé (fourni par toi)
import 'package:copiqpolice/core/services/app_console_logger.dart';

/// ===== Validators

bool isValidFrMobile(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  return RegExp(r'^(06|07)\d{8}$').hasMatch(digits);
}

bool isValidUsernameFormat(String raw) {
  // 3–20 caractères, lettres/chiffres/underscore, commence par lettre
  return RegExp(r'^[A-Za-z][A-Za-z0-9_]{2,19}$').hasMatch(raw);
}

/// ===== Domain

class Profile {
  final String userId;
  final String? email;
  final String firstName;
  final String lastName;
  final String city;
  final String phone;
  final int avatarIndex;
  final String? username;
  final DateTime? birthday;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.phone,
    required this.avatarIndex,
    this.username,
    this.birthday,
    this.createdAt,
    this.updatedAt,
  });

  bool get isComplete =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      isValidFrMobile(phone) &&
      (username != null && username!.trim().isNotEmpty);

  Map<String, dynamic> toUpsertMap() => {
    'user_id': userId,
    if (email != null) 'email': email,
    'first_name': firstName.trim(),
    'last_name': lastName.trim(),
    'city': city.trim(),
    'phone': phone.replaceAll(RegExp(r'[^0-9]'), ''),
    'avatar_index': avatarIndex,
    'username': username?.trim(),
    'birthday': birthday != null
        ? DateTime(
            birthday!.year,
            birthday!.month,
            birthday!.day,
          ).toIso8601String()
        : null,
  };

  Profile copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? city,
    String? phone,
    int? avatarIndex,
    String? username,
    DateTime? birthday,
  }) {
    return Profile(
      userId: userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      username: username ?? this.username,
      birthday: birthday ?? this.birthday,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static Profile empty(String userId, {String? email}) => Profile(
    userId: userId,
    email: email,
    firstName: '',
    lastName: '',
    city: '',
    phone: '',
    avatarIndex: 1,
    username: null,
    birthday: null,
  );

  static Profile fromMap(Map<String, dynamic> m) => Profile(
    userId: m['user_id'] as String,
    email: m['email'] as String?,
    firstName: (m['first_name'] as String?) ?? '',
    lastName: (m['last_name'] as String?) ?? '',
    city: (m['city'] as String?) ?? '',
    phone: (m['phone'] as String?) ?? '',
    avatarIndex: ((m['avatar_index'] as num?) ?? 1).toInt(),
    username: m['username'] as String?,
    birthday: (() {
      final v = m['birthday'];
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    })(),
    createdAt: m['created_at'] != null
        ? DateTime.tryParse(m['created_at'].toString())
        : null,
    updatedAt: m['updated_at'] != null
        ? DateTime.tryParse(m['updated_at'].toString())
        : null,
  );
}

/// ===== Repository

class ProfileRepository {
  final SupabaseClient sb;
  ProfileRepository(this.sb);

  static const table = 'user_profiles';

  Future<Profile> fetchOrCreate(String userId, {required String? email}) async {
    final res = await sb
        .from(table)
        .select()
        .eq('user_id', userId)
        .maybeSingle()
        .timeout(const Duration(seconds: 10));

    if (res != null) {
      final existing = Profile.fromMap(res);
      if (email != null && existing.email != email) {
        final updated = await sb
            .from(table)
            .update({'email': email})
            .eq('user_id', userId)
            .select()
            .single();
        return Profile.fromMap(updated);
      }
      return existing;
    }

    final inserted = await sb
        .from(table)
        .insert({
          'user_id': userId,
          'email': email,
          'first_name': '',
          'last_name': '',
          'city': '',
          'phone': '',
          'avatar_index': 1,
          'username': null,
          'birthday': null,
        })
        .select()
        .single();

    return Profile.fromMap(inserted);
  }

  Future<bool> isUsernameTaken(String username, String exceptUserId) async {
    final res = await sb
        .from(table)
        .select('user_id')
        .ilike('username', username)
        .neq('user_id', exceptUserId)
        .maybeSingle()
        .timeout(const Duration(seconds: 8));
    return res != null;
  }

  Future<Profile> upsert(Profile p) async {
    final row = await sb
        .from(table)
        .upsert(p.toUpsertMap(), onConflict: 'user_id')
        .select()
        .single()
        .timeout(const Duration(seconds: 10));
    return Profile.fromMap(row);
  }
}

/// ===== Dialog 1ère connexion (infos obligatoires)
/// Style inspiré de tes captures (light/dark), blocage tant que champs non valides.

class FirstTimeWelcomeDialog extends StatefulWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController city;
  final TextEditingController phone;
  final TextEditingController username;
  final DateTime? initialBirthday;
  final Future<bool> Function({
    required String firstName,
    required String lastName,
    required String city,
    required String phone,
    required String username,
    required DateTime? birthday,
  })
  onSubmit;

  const FirstTimeWelcomeDialog({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.phone,
    required this.username,
    required this.initialBirthday,
    required this.onSubmit,
  });

  @override
  State<FirstTimeWelcomeDialog> createState() => _FirstTimeWelcomeDialogState();
}

class _FirstTimeWelcomeDialogState extends State<FirstTimeWelcomeDialog> {
  bool _saving = false;
  DateTime? _birthday;

  @override
  void initState() {
    super.initState();
    _birthday = widget.initialBirthday;
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    DateTime tmp = _birthday ?? DateTime(now.year - 18, now.month, now.day);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      barrierColor: Colors.black.withOpacity(.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: SizedBox(
          height: 320,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
                child: Row(
                  children: [
                    Text(
                      'Birth date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() => _birthday = tmp);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tmp,
                  maximumDate: DateTime(now.year - 10, now.month, now.day),
                  minimumDate: DateTime(1900, 1, 1),
                  onDateTimeChanged: (d) => tmp = d,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;

    // Validations “hard” pour bloquer la fermeture
    if (widget.firstName.text.trim().isEmpty) {
      AppNotifier.error(
        context,
        title: 'Prénom requis',
        message: 'Veuillez renseigner votre prénom',
      );
      return;
    }
    if (widget.lastName.text.trim().isEmpty) {
      AppNotifier.error(
        context,
        title: 'Nom requis',
        message: 'Veuillez renseigner votre nom',
      );
      return;
    }
    if (widget.city.text.trim().isNotEmpty == false) {
      AppNotifier.error(
        context,
        title: 'Ville requise',
        message: 'Veuillez renseigner votre ville',
      );
      return;
    }
    if (!isValidFrMobile(widget.phone.text)) {
      AppNotifier.error(
        context,
        title: 'Téléphone invalide',
        message: 'Format FR requis: 06/07 + 8 chiffres',
      );
      return;
    }
    final uname = widget.username.text.trim();
    if (!isValidUsernameFormat(uname)) {
      AppNotifier.error(
        context,
        title: 'Username invalide',
        message:
            '3–20 caractères, lettres/chiffres/underscore, commence par une lettre.',
      );
      return;
    }

    setState(() => _saving = true);
    final ok = await widget.onSubmit(
      firstName: widget.firstName.text,
      lastName: widget.lastName.text,
      city: widget.city.text,
      phone: widget.phone.text,
      username: uname,
      birthday: _birthday,
    );
    if (mounted) setState(() => _saving = false);
    if (ok && mounted) Navigator.of(context).pop();
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
  );

  Widget _field({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String hint = '',
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.16)
                  : Colors.black.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(icon, color: Theme.of(context).hintColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: _inputDecoration(hint),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Crée ton profil',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    // aucune fermeture (bloquant)
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Ajoute tes infos pour personnaliser l'expérience.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 18),

                _field(
                  label: 'Prénom',
                  icon: Icons.person_outline_rounded,
                  controller: widget.firstName,
                  hint: 'Ex. Nicolas',
                ),
                _field(
                  label: 'Nom',
                  icon: Icons.badge_outlined,
                  controller: widget.lastName,
                  hint: 'Ex. Dupont',
                ),
                _field(
                  label: 'Ville',
                  icon: Icons.location_city_outlined,
                  controller: widget.city,
                  hint: 'Ex. Paris',
                ),
                _field(
                  label: 'Téléphone (06/07...)',
                  icon: Icons.phone_iphone_rounded,
                  controller: widget.phone,
                  hint: '06 12 34 56 78',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\s\.\-]')),
                    LengthLimitingTextInputFormatter(14),
                  ],
                ),
                _field(
                  label: 'Username',
                  icon: Icons.alternate_email_rounded,
                  controller: widget.username,
                  hint: 'Ex. copiq_75',
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9_]')),
                  ],
                ),

                Text(
                  'Anniversaire',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickBirthday,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 52,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.16)
                            : Colors.black.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cake_rounded,
                          color: Theme.of(context).hintColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _birthday == null
                              ? 'Sélectionnez… (facultatif)'
                              : '${_birthday!.day.toString().padLeft(2, '0')}.${_birthday!.month.toString().padLeft(2, '0')}.${_birthday!.year}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _saving
                        ? const _AppleLikeLoader(size: 20)
                        : const Text(
                            'Confirm',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Vos informations sont sécurisées et ne seront jamais partagées.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ===== Page de profil

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});
  static const routeName = '/profil';

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _sb = Supabase.instance.client;
  late final ProfileRepository _repo;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _city = TextEditingController();
  final _phone = TextEditingController();
  final _username = TextEditingController();

  DateTime? _birthDate;

  Profile? _profile;
  bool _loading = true;
  bool _firstSheetGuard = false;
  int _avatarIndex = 1;

  // UI prefs sliders
  static const double kMinAvatarRadius = 40;
  static const double kMaxAvatarRadius = 90;
  static const double kMinGrid = 100;
  static const double kMaxGrid = 220;
  static const double kMinAvatarZoom = 1.0;
  static const double kMaxAvatarZoom = 2.25;
  static const double kDefaultAvatarRadius = 76;
  static const double kDefaultGrid = 160;
  static const double kDefaultAvatarZoom = 1.71;

  double _avatarRadius = kDefaultAvatarRadius;
  double _gridIcon = kDefaultGrid;
  double _avatarZoom = kDefaultAvatarZoom;

  Color get _primary => const Color(0xFF2D6CEA);
  Color _ink(BuildContext c) => Theme.of(c).brightness == Brightness.dark
      ? Colors.white
      : const Color(0xFF212529);

  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _repo = ProfileRepository(_sb);

    // Contexte d’écran pour les logs enrichis
    AppConsoleLogger.setScreenContext(
      screenName: 'ProfilPage',
      routeName: ProfilPage.routeName,
    );

    _authSub = _sb.auth.onAuthStateChange.listen((event) async {
      if (event.session?.user != null) {
        await AppConsoleLogger.info(
          'auth_state_change:session_available',
          context: {'event': event.event.name},
        );
        if (mounted) _bootstrap();
      } else {
        await AppConsoleLogger.info(
          'auth_state_change:no_session',
          context: {'event': event.event.name},
        );
        if (mounted) {
          setState(() {
            _loading = false;
            _profile = null;
          });
        }
      }
    });

    _bootstrap();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _firstName.dispose();
    _lastName.dispose();
    _city.dispose();
    _phone.dispose();
    _username.dispose();
    super.dispose();
  }

  /// Attente/hydratation de session — compatible toutes versions du SDK.
  Future<User?> _waitForSessionUser({
    Duration timeout = const Duration(seconds: 6),
  }) async {
    final sw = Stopwatch()..start();
    var delay = const Duration(milliseconds: 120);

    while (sw.elapsed < timeout) {
      try {
        final u = _sb.auth.currentUser;
        if (u != null) return u;
      } catch (_) {
        /* ignore */
      }
      await Future.delayed(delay);
      if (delay.inMilliseconds < 600) {
        delay += const Duration(milliseconds: 120);
      }
    }
    return null;
  }

  Future<void> _bootstrap() async {
    if (!mounted) return;
    setState(() => _loading = true);
    await AppConsoleLogger.info('profil_bootstrap:start');

    try {
      // 1) Session fiable
      final user = await _waitForSessionUser();
      if (user == null) {
        await AppConsoleLogger.warn('profil_bootstrap:no_current_user');
        if (mounted) setState(() => _loading = false);
        return;
      }

      // 2) Charger/créer profil
      final profile = await _repo.fetchOrCreate(user.id, email: user.email);
      _profile = profile;

      // 3) Bind contrôleurs
      _firstName.text = profile.firstName;
      _lastName.text = profile.lastName;
      _city.text = profile.city;
      _phone.text = profile.phone;
      _avatarIndex = profile.avatarIndex;
      _username.text = profile.username ?? '';
      _birthDate = profile.birthday;

      await AppConsoleLogger.info(
        'profil_bootstrap:success',
        context: {
          'profile_complete': profile.isComplete,
          'user_id': profile.userId,
        },
      );

      // 4) Popup forcée tant que profil incomplet
      if ((_profile?.isComplete != true) && !_firstSheetGuard) {
        _firstSheetGuard = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showFirstTimeWelcomeDialog();
        });
      }
    } catch (e, st) {
      await AppConsoleLogger.error(
        'profil_bootstrap:exception',
        message: 'bootstrap failed',
        err: e,
        stack: st,
      );
      if (mounted) {
        AppNotifier.error(
          context,
          title: 'Erreur de chargement',
          message: 'Impossible de charger votre profil.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _joinedText {
    final created = _sb.auth.currentUser?.createdAt;
    try {
      final dt = created != null ? DateTime.parse(created) : DateTime.now();
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
    } catch (_) {
      final now = DateTime.now();
      return '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';
    }
  }

  Future<bool> _saveAll({
    required String firstName,
    required String lastName,
    required String city,
    required String phone,
    required String username,
    required int avatarIndex,
    required DateTime? birthday,
  }) async {
    HapticFeedback.selectionClick();

    final user = await _waitForSessionUser();
    if (user == null) {
      await AppConsoleLogger.warn('profile_save:blocked_no_session');
      AppNotifier.error(
        context,
        title: 'Non connecté',
        message: 'Veuillez vous reconnecter.',
      );
      return false;
    }

    if (!isValidFrMobile(phone)) {
      AppNotifier.error(
        context,
        title: 'Téléphone invalide',
        message: 'Format FR requis: 06/07 + 8 chiffres.',
      );
      return false;
    }
    if (!isValidUsernameFormat(username)) {
      AppNotifier.error(
        context,
        title: 'Username invalide',
        message:
            '3–20 caractères, lettres/chiffres/underscore, commence par une lettre.',
      );
      return false;
    }

    final taken = await _repo.isUsernameTaken(username, user.id);
    if (taken) {
      AppNotifier.error(
        context,
        title: 'Username déjà utilisé',
        message: 'Merci d’en choisir un autre.',
      );
      return false;
    }

    try {
      final newProfile = (_profile ?? Profile.empty(user.id, email: user.email))
          .copyWith(
            email: user.email,
            firstName: firstName,
            lastName: lastName,
            city: city,
            phone: phone,
            avatarIndex: avatarIndex,
            username: username,
            birthday: birthday,
          );

      final saved = await _repo.upsert(newProfile);
      if (!mounted) return true;

      setState(() {
        _profile = saved;
        _firstName.text = saved.firstName;
        _lastName.text = saved.lastName;
        _city.text = saved.city;
        _phone.text = saved.phone;
        _username.text = saved.username ?? '';
        _avatarIndex = saved.avatarIndex;
        _birthDate = saved.birthday;
      });

      await AppConsoleLogger.success(
        'profile_save:upsert_success',
        context: {
          'profile_complete': saved.isComplete,
          'user_id': saved.userId,
        },
      );

      AppNotifier.success(
        context,
        title: 'Profil enregistré',
        message: 'Vos informations ont été mises à jour.',
      );
      return true;
    } catch (e, st) {
      await AppConsoleLogger.error(
        'profile_save:upsert_failed',
        message: 'upsert error',
        err: e,
        stack: st,
      );
      AppNotifier.error(
        context,
        title: 'Erreur de sauvegarde',
        message: 'Veuillez réessayer.',
      );
      return false;
    }
  }

  Future<void> _showFirstTimeWelcomeDialog() async {
    await AppConsoleLogger.info('profile_first_welcome_dialog:showing');
    showDialog(
      context: context,
      barrierDismissible: false, // 🔒 bloquant
      barrierColor: Colors.black.withOpacity(.7),
      builder: (ctx) => FirstTimeWelcomeDialog(
        firstName: _firstName,
        lastName: _lastName,
        city: _city,
        phone: _phone,
        username: _username,
        initialBirthday: _birthDate,
        onSubmit:
            ({
              required String firstName,
              required String lastName,
              required String city,
              required String phone,
              required String username,
              required DateTime? birthday,
            }) async {
              final ok = await _saveAll(
                firstName: firstName,
                lastName: lastName,
                city: city,
                phone: phone,
                username: username,
                avatarIndex: _avatarIndex,
                birthday: birthday,
              );
              await AppConsoleLogger.info(
                'profile_complete_welcome_dialog:${ok ? 'success' : 'save_failed'}',
              );
              return ok;
            },
      ),
    );
  }

  // ===== UI

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: _AppleLikeLoader(size: 28)));
    }

    final fullName = ('${_firstName.text.trim()} ${_lastName.text.trim()}')
        .trim();
    final displayName = fullName.isEmpty
        ? (_username.text.isEmpty ? 'Mon profil' : _username.text)
        : fullName;
    final double headerHeight = math.max(260, _avatarRadius * 2 + 120);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 68, 20, 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Header
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: headerHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: _avatarRadius * 2 + 6,
                        height: _avatarRadius * 2 + 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _primary, width: 2),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: _avatarRadius,
                            backgroundColor: Theme.of(context).cardColor,
                            child: _AvatarImage(
                              index: _avatarIndex,
                              radius: _avatarRadius,
                              zoom: _avatarZoom,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      if (_username.text.isNotEmpty)
                        Text(
                          '@${_username.text}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EditProfilePage(
                                  primary: _primary,
                                  avatarIndex: _avatarIndex,
                                  avatarZoom: _avatarZoom,
                                  gridIcon: _gridIcon,
                                  name: displayName,
                                  birthDate: _birthDate,
                                  onPickAvatar: _openAvatarPicker,
                                  getCurrentAvatarIndex: () => _avatarIndex,
                                  getCurrentAvatarZoom: () => _avatarZoom,
                                  onSaveImmediate: (name, bdate) async {
                                    final parts = name.trim().split(
                                      RegExp(r'\s+'),
                                    );
                                    final fn = parts.isEmpty ? '' : parts.first;
                                    final ln = parts.length > 1
                                        ? parts.sublist(1).join(' ')
                                        : '';
                                    await _saveAll(
                                      firstName: fn,
                                      lastName: ln,
                                      city: _city.text,
                                      phone: _phone.text,
                                      username: _username.text.isEmpty
                                          ? 'user_${_sb.auth.currentUser!.id.substring(0, 8)}'
                                          : _username.text,
                                      avatarIndex: _avatarIndex,
                                      birthday: bdate ?? _birthDate,
                                    );
                                  },
                                  onSliderChanged: (r, z, g) async {
                                    setState(() {
                                      _avatarRadius = r;
                                      _avatarZoom = z;
                                      _gridIcon = g;
                                    });
                                    final sp =
                                        await SharedPreferences.getInstance();
                                    await sp.setDouble(
                                      'profile_avatar_radius',
                                      r,
                                    );
                                    await sp.setDouble(
                                      'profile_avatar_zoom',
                                      z,
                                    );
                                    await sp.setDouble(
                                      'profile_grid_icon_size',
                                      g,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_note_rounded, size: 18),
                          label: const Text('Modifier le profil'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _ink(context),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(.35),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Joined $_joinedText',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.workspace_premium_outlined,
                      title: 'Abonnement',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AbonnementPage()),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.settings_outlined,
                      title: 'Paramètres',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ParametreHomePage(),
                        ),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'Facturation',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FacturePage()),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.group_outlined,
                      title: 'Mon compte',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const UserPage()),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Information',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const InformationPage(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await AppConsoleLogger.info('auth:sign_out_initiated');
                      final sp = await SharedPreferences.getInstance();
                      await sp.remove('first_time_welcome_shown');
                      await _sb.auth.signOut();
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const OnboardingScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Déconnexion'),
                  ),
                ),
              ],
            ),
          ),

          // bouton “tune” (personnalisation)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    icon: const Icon(Icons.tune_rounded),
                    tooltip: 'Personnaliser',
                    onPressed: _openPersonalisationSheet,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPersonalisationSheet() {
    double localAvatarRadius = _avatarRadius;
    double localAvatarZoom = _avatarZoom;
    double localGridIcon = _gridIcon;

    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(.25),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) {
          TextStyle? labelStyle = Theme.of(
            ctx,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700);

          Widget sliderRow({
            required String label,
            required double value,
            required double min,
            required double max,
            String? unit,
            required ValueChanged<double> onChangedLocal,
            required ValueChanged<double> onChangeEndPersist,
          }) {
            final unitText = unit == 'x'
                ? '${value.toStringAsFixed(2)} x'
                : '${value.toStringAsFixed(0)}${unit != null ? ' $unit' : ''}';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(label, style: labelStyle)),
                    Text(unitText, style: Theme.of(ctx).textTheme.bodySmall),
                  ],
                ),
                Slider(
                  value: value.clamp(min, max).toDouble(),
                  min: min,
                  max: max,
                  onChanged: (v) => setModal(() => onChangedLocal(v)),
                  onChangeEnd: (v) => onChangeEndPersist(v),
                ),
                const SizedBox(height: 8),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _grabber(),
                const SizedBox(height: 12),
                Text(
                  'Personnalisation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                sliderRow(
                  label: 'Taille icône de profil',
                  value: localAvatarRadius,
                  min: kMinAvatarRadius,
                  max: kMaxAvatarRadius,
                  unit: 'px (rayon)',
                  onChangedLocal: (v) => localAvatarRadius = v,
                  onChangeEndPersist: (v) async => _saveAvatarRadius(v),
                ),
                sliderRow(
                  label: 'Zoom de l\'avatar',
                  value: localAvatarZoom,
                  min: kMinAvatarZoom,
                  max: kMaxAvatarZoom,
                  unit: 'x',
                  onChangedLocal: (v) => localAvatarZoom = v,
                  onChangeEndPersist: (v) async => _saveAvatarZoom(v),
                ),
                sliderRow(
                  label: 'Taille des vignettes du sélecteur',
                  value: localGridIcon,
                  min: kMinGrid,
                  max: kMaxGrid,
                  unit: 'px',
                  onChangedLocal: (v) => localGridIcon = v,
                  onChangeEndPersist: (v) async => _saveGridIcon(v),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveAvatarRadius(double v) async {
    final r = v.clamp(kMinAvatarRadius, kMaxAvatarRadius).toDouble();
    setState(() => _avatarRadius = r);
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble('profile_avatar_radius', r);
  }

  Future<void> _saveGridIcon(double v) async {
    final s = v.clamp(kMinGrid, kMaxGrid).toDouble();
    setState(() => _gridIcon = s);
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble('profile_grid_icon_size', s);
  }

  Future<void> _saveAvatarZoom(double v) async {
    final z = v.clamp(kMinAvatarZoom, kMaxAvatarZoom).toDouble();
    setState(() => _avatarZoom = z);
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble('profile_avatar_zoom', z);
  }

  Future<void> _openAvatarPicker() async {
    final sp = await SharedPreferences.getInstance();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(.25),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        minChildSize: .45,
        initialChildSize: .85,
        maxChildSize: .95,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: ListView(
            controller: scrollCtrl,
            children: [
              _grabber(context: ctx),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Choisissez une icône',
                      style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Taille des vignettes',
                    onPressed: _openPersonalisationSheet,
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: _gridIcon + 64,
                  mainAxisExtent: _gridIcon + 64,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 20,
                itemBuilder: (_, i) {
                  final index = i + 1;
                  final selected = index == _avatarIndex;
                  return GestureDetector(
                    onTap: () async {
                      setState(() => _avatarIndex = index);
                      await _saveAll(
                        firstName: _firstName.text,
                        lastName: _lastName.text,
                        city: _city.text,
                        phone: _phone.text,
                        username: _username.text.isEmpty
                            ? 'user_${_sb.auth.currentUser!.id.substring(0, 8)}'
                            : _username.text,
                        avatarIndex: _avatarIndex,
                        birthday: _birthDate,
                      );
                      if (mounted) Navigator.of(ctx).pop();
                    },
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: _gridIcon + 44,
                        height: _gridIcon + 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            width: selected ? 2 : 1,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).dividerColor.withOpacity(.35),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/icon_profile/$index.png',
                          width: _gridIcon,
                          height: _gridIcon,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    await sp.setDouble('profile_grid_icon_size', _gridIcon);
  }

  Widget _grabber({BuildContext? context}) {
    final c = context ?? this.context;
    return Center(
      child: Container(
        width: 48,
        height: 5,
        decoration: BoxDecoration(
          color: Theme.of(c).dividerColor.withOpacity(.35),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

/// ===== Edit Page (identique à ta V2, sauvegarde auto via callback)

class EditProfilePage extends StatefulWidget {
  final Color primary;
  final int avatarIndex;
  final double avatarZoom;
  final double gridIcon;
  final String name;
  final DateTime? birthDate;
  final Future<void> Function() onPickAvatar;
  final Future<void> Function(double radius, double zoom, double grid)?
  onSliderChanged;
  final Future<void> Function(String name, DateTime? birthDate) onSaveImmediate;
  final int Function()? getCurrentAvatarIndex;
  final double Function()? getCurrentAvatarZoom;

  const EditProfilePage({
    super.key,
    required this.primary,
    required this.avatarIndex,
    required this.avatarZoom,
    required this.gridIcon,
    required this.name,
    required this.birthDate,
    required this.onPickAvatar,
    required this.onSaveImmediate,
    this.onSliderChanged,
    this.getCurrentAvatarIndex,
    this.getCurrentAvatarZoom,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameCtrl;
  DateTime? _birthDate;
  Timer? _debounce;

  late int _avatarIndexLocal;
  late double _avatarZoomLocal;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _birthDate = widget.birthDate;
    _avatarIndexLocal = widget.avatarIndex;
    _avatarZoomLocal = widget.avatarZoom;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _debouncedSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      await widget.onSaveImmediate(_nameCtrl.text, _birthDate);
    });
  }

  Future<void> _openBirthPicker() async {
    final now = DateTime.now();
    final init = _birthDate ?? DateTime(now.year - 18, now.month, now.day);
    DateTime temp = init;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      barrierColor: Colors.black.withOpacity(.25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: SizedBox(
          height: 320,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
                child: Row(
                  children: [
                    Text(
                      'Birth Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() => _birthDate = temp);
                        Navigator.of(ctx).pop();
                        _debouncedSave();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: init,
                  maximumDate: DateTime(now.year - 10, now.month, now.day),
                  minimumDate: DateTime(1900, 1, 1),
                  onDateTimeChanged: (d) => temp = d,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillColor = isDark
        ? Colors.white.withOpacity(.06)
        : Colors.black.withOpacity(.05);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Modifier le profil'),
        actions: const [SizedBox(width: 48)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 48 * 2 + 6,
                  height: 48 * 2 + 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.primary, width: 2),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Theme.of(context).cardColor,
                      child: _AvatarImage(
                        index: _avatarIndexLocal,
                        radius: 48,
                        zoom: _avatarZoomLocal,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: widget.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () async {
                      await widget.onPickAvatar();
                      if (!mounted) return;
                      setState(() {
                        _avatarIndexLocal =
                            widget.getCurrentAvatarIndex?.call() ??
                            _avatarIndexLocal;
                        _avatarZoomLocal =
                            widget.getCurrentAvatarZoom?.call() ??
                            _avatarZoomLocal;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _LabeledPill(
            label: 'Name',
            child: TextField(
              controller: _nameCtrl,
              onChanged: (_) => _debouncedSave(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Votre nom',
              ),
            ),
            background: pillColor,
          ),
          const SizedBox(height: 12),

          _LabeledPill(
            label: 'Anniversaire',
            onTap: _openBirthPicker,
            child: Text(
              _birthDate == null
                  ? 'Sélectionnez…'
                  : '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            background: pillColor,
          ),

          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Les modifications sont enregistrées automatiquement.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),

          const SizedBox(height: 22),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.check_rounded),
              label: const Text('Terminer'),
              onPressed: () async {
                await widget.onSaveImmediate(_nameCtrl.text, _birthDate);
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// --- pill
class _LabeledPill extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color background;
  const _LabeledPill({
    required this.label,
    required this.child,
    required this.background,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      height: 48,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          if (trailing != null) trailing!,
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(14),
                child: content,
              ),
      ],
    );
  }
}

/// --- avatar + settings list items
class _AvatarImage extends StatelessWidget {
  final int index;
  final double radius;
  final double zoom;
  const _AvatarImage({
    required this.index,
    required this.radius,
    required this.zoom,
  });
  @override
  Widget build(BuildContext context) {
    final z = zoom
        .clamp(_ProfilPageState.kMinAvatarZoom, _ProfilPageState.kMaxAvatarZoom)
        .toDouble();
    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Transform.scale(
          scale: z,
          child: Image.asset(
            'assets/icon_profile/$index.png',
            fit: BoxFit.cover,
          ),
        ),
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
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      title: const Text(''),
      subtitle: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

/// Loader “Apple-like” (3 points qui pulsents)
class _AppleLikeLoader extends StatefulWidget {
  final double size;
  const _AppleLikeLoader({this.size = 22, super.key});
  @override
  State<_AppleLikeLoader> createState() => _AppleLikeLoaderState();
}

class _AppleLikeLoaderState extends State<_AppleLikeLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = widget.size / 5;
    return AnimatedBuilder(
      animation: _ctl,
      builder: (_, __) {
        final t = _ctl.value; // 0..1
        double p(int i) => ((t + i / 3) % 1.0);
        double s(int i) => 0.6 + 0.4 * (1 - (p(i) - .5).abs() * 2);
        return SizedBox(
          height: widget.size,
          width: widget.size * 2.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: dot / 3),
                child: Transform.scale(
                  scale: s(i),
                  child: Container(
                    width: dot,
                    height: dot,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
