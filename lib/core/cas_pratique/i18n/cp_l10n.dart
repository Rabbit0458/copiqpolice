/// COP'IQ — Cas Pratique — i18n helper
///
/// Provides:
///  - [CpL10n] static accessor for AppLocalizations (graceful fallback to FR
///    if the generated class is not yet wired into MaterialApp).
///  - [CpDateFormat] relative-date helpers (ex: "Il y a 3 jours").
///  - [CpNumberFormat] number formatters (score, percentage).
///
/// ──────────────────────────────────────────────────────────────────────────
/// WIRING IN main.dart (3 additions):
///
///   // 1. import
///   import 'package:flutter_localizations/flutter_localizations.dart';
///   import 'package:copiqpolice/l10n/app_localizations.dart';
///
///   // 2. inside MaterialApp(...)
///   localizationsDelegates: const [
///     AppLocalizations.delegate,
///     GlobalMaterialLocalizations.delegate,
///     GlobalWidgetsLocalizations.delegate,
///     GlobalCupertinoLocalizations.delegate,
///   ],
///   supportedLocales: const [Locale('fr'), Locale('en')],
///   locale: CpLocaleService.instance.locale,       // optional
///   localeResolutionCallback: (device, supported) => // optional
///     CpLocaleService.instance.resolveLocale(device, supported),
///
///   // 3. Run flutter pub get then flutter gen-l10n
/// ──────────────────────────────────────────────────────────────────────────

library cp_l10n;


import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Generated file (available after `flutter gen-l10n`) ──────────────────
// We import conditionally so the rest of the module compiles even if the
// generated file doesn't exist yet (first bootstrap).
// Uncomment once you've run `flutter gen-l10n`:
//
// import 'package:copiqpolice/l10n/app_localizations.dart';

// ─── Locale service ───────────────────────────────────────────────────────

/// Supported locales for COP'IQ.
const List<Locale> kCpSupportedLocales = [Locale('fr'), Locale('en')];

/// Default locale.
const Locale kCpDefaultLocale = Locale('fr');

/// Persistent locale preference key.
const String _kPrefsKey = 'cp_app_locale';

/// Manages the user-selected locale with SharedPreferences persistence.
///
/// Usage:
///   await CpLocaleService.instance.init();
///   CpLocaleService.instance.setLocale(const Locale('en'));
class CpLocaleService extends ChangeNotifier {
  CpLocaleService._();

  static final CpLocaleService instance = CpLocaleService._();

  Locale _locale = kCpDefaultLocale;
  SharedPreferences? _prefs;

  /// Current active locale.
  Locale get locale => _locale;

  /// Initialise — must be called once before the app renders.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs?.getString(_kPrefsKey);
    if (saved != null) {
      _locale = _parseLocale(saved);
    }
  }

  /// Change the active locale and persist the choice.
  Future<void> setLocale(Locale locale) async {
    if (!kCpSupportedLocales.contains(locale)) return;
    _locale = locale;
    await _prefs?.setString(_kPrefsKey, locale.languageCode);
    notifyListeners();
  }

  /// Toggle between FR and EN.
  Future<void> toggle() async {
    await setLocale(_locale.languageCode == 'fr'
        ? const Locale('en')
        : const Locale('fr'));
  }

  /// Locale resolution callback for MaterialApp.
  Locale? resolveLocale(Locale? deviceLocale, Iterable<Locale> supported) {
    if (deviceLocale == null) return kCpDefaultLocale;
    for (final s in supported) {
      if (s.languageCode == deviceLocale.languageCode) return s;
    }
    return kCpDefaultLocale;
  }

  static Locale _parseLocale(String code) {
    return kCpSupportedLocales.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => kCpDefaultLocale,
    );
  }
}

// ─── CpL10n — string accessor ─────────────────────────────────────────────

/// Accessor for the current locale's strings.
///
/// When [AppLocalizations] is wired:
///   CpL10n.of(context).cp_list_title
///
/// Until gen-l10n is run, falls back to the hard-coded FR strings below.
/// This allows the app to compile and run without generated code.
class CpL10n {
  CpL10n._();

  /// Returns [AppLocalizations] if available, else a [_FallbackL10n].
  ///
  /// Uncomment the AppLocalizations line once `flutter gen-l10n` has been run:
  // static AppLocalizations of(BuildContext context) =>
  //     AppLocalizations.of(context);

  /// Temporary fallback — remove once gen-l10n is wired.
  static _FallbackL10n of(BuildContext context) {
    final lang = CpLocaleService.instance.locale.languageCode;
    return lang == 'en' ? _FallbackL10n.en() : _FallbackL10n.fr();
  }
}

// ─── Fallback strings (no generated code needed) ──────────────────────────

/// Compile-time fallback — mirrors intl_fr.arb / intl_en.arb.
/// Replace with the generated AppLocalizations once `flutter gen-l10n` runs.
class _FallbackL10n {
  final bool _isEn;

  const _FallbackL10n._(this._isEn);

  factory _FallbackL10n.fr() => const _FallbackL10n._(false);
  factory _FallbackL10n.en() => const _FallbackL10n._(true);

  String get appName => "COP'IQ";
  String get back => _isEn ? 'Back' : 'Retour';
  String get retry => _isEn ? 'Try again' : 'Réessayer';
  String get cancel => _isEn ? 'Cancel' : 'Annuler';
  String get confirm => _isEn ? 'Confirm' : 'Confirmer';
  String get close => _isEn ? 'Close' : 'Fermer';
  String get save => _isEn ? 'Save' : 'Enregistrer';
  String get loading => _isEn ? 'Loading…' : 'Chargement…';
  String get error_generic => _isEn ? 'Something went wrong.' : 'Une erreur est survenue.';
  String get error_loading => _isEn ? 'An error occurred while loading.' : 'Une erreur est survenue pendant le chargement.';
  String get error_no_connection => _isEn ? 'No network connection.' : 'Pas de connexion réseau.';
  String get error_not_authenticated => _isEn ? 'Sign in to access this content.' : 'Connecte-toi pour accéder à ce contenu.';
  String get error_server => _isEn ? 'Server issue. Try again shortly.' : 'Problème serveur. Réessaie dans quelques instants.';

  // Lists
  String get cp_list_title => _isEn ? 'Practical Cases' : 'Cas Pratiques';
  String get cp_list_search_hint => _isEn ? 'Search a case, a keyword…' : 'Rechercher un cas, un mot-clé…';
  String get cp_list_search_clear => _isEn ? 'Clear' : 'Effacer';
  String get cp_list_search_open => _isEn ? 'Search' : 'Rechercher';
  String get cp_list_search_close => _isEn ? 'Close search' : 'Fermer la recherche';
  String get cp_list_sort => _isEn ? 'Sort' : 'Trier';
  String cp_list_sorted_by(String label) => _isEn ? 'Sorted by: $label' : 'Trié par : $label';
  String get cp_list_empty_title => _isEn ? 'No cases available' : 'Aucun cas disponible';
  String get cp_list_empty_message => _isEn ? 'Practical cases are coming soon!' : 'Les cas pratiques arrivent bientôt !';
  String get cp_list_empty_filters_title => _isEn ? 'No cases for these filters' : 'Aucun cas pour ces filtres';
  String get cp_list_empty_filters_message => _isEn ? 'Try broadening your search criteria.' : 'Essaie d\'élargir tes critères de recherche.';
  String get cp_list_reset_filters => _isEn ? 'Reset filters' : 'Réinitialiser les filtres';

  // Filters
  String get cp_filter_year => _isEn ? 'Year' : 'Année';
  String get cp_filter_theme => _isEn ? 'Theme' : 'Thème';
  String get cp_filter_difficulty => _isEn ? 'Difficulty' : 'Difficulté';
  String get cp_filter_clear => _isEn ? 'Clear' : 'Effacer';
  String get cp_filter_title_year => _isEn ? 'Filter by year' : 'Filtrer par année';
  String get cp_filter_title_theme => _isEn ? 'Filter by theme' : 'Filtrer par thème';
  String get cp_filter_title_difficulty => _isEn ? 'Filter by difficulty' : 'Filtrer par difficulté';
  String get cp_filter_empty_year => _isEn ? 'No years available yet.' : 'Aucune année disponible pour le moment.';
  String get cp_filter_empty_theme => _isEn ? 'No themes available yet.' : 'Aucun thème disponible pour le moment.';

  // Sort
  String get cp_sort_recent => _isEn ? 'Most recent' : 'Plus récent';
  String get cp_sort_recent_subtitle => _isEn ? 'Cases published first' : 'Les cas publiés en premier';
  String get cp_sort_alpha => _isEn ? 'Alphabetical (A → Z)' : 'Alphabétique (A → Z)';
  String get cp_sort_alpha_subtitle => _isEn ? 'Ordered by case title' : 'Ordre du titre du cas';
  String get cp_sort_duration_asc => _isEn ? 'Shortest first' : 'Durée croissante';
  String get cp_sort_duration_asc_subtitle => _isEn ? 'Quickest cases first' : 'Les plus courts d\'abord';
  String get cp_sort_duration_desc => _isEn ? 'Longest first' : 'Durée décroissante';
  String get cp_sort_duration_desc_subtitle => _isEn ? 'Longest cases first' : 'Les plus longs d\'abord';
  String get cp_sort_by => _isEn ? 'Sort by' : 'Trier par';

  // Badges / difficulty
  String get cp_badge_free => _isEn ? 'FREE' : 'GRATUIT';
  String get cp_badge_premium => 'PREMIUM';
  String get cp_badge_new => _isEn ? 'NEW' : 'NOUVEAU';
  String get cp_difficulty_easy => _isEn ? 'Easy' : 'Facile';
  String get cp_difficulty_medium => _isEn ? 'Medium' : 'Moyen';
  String get cp_difficulty_hard => _isEn ? 'Hard' : 'Difficile';

  // Tile
  String get cp_tile_last_score => _isEn ? 'Last' : 'Dernier';
  String get cp_tile_best_score => _isEn ? 'Best' : 'Meilleur';
  String get cp_tile_success_rate => _isEn ? 'Rate' : 'Réussite';
  String get cp_tile_status_new => _isEn ? 'New' : 'Nouveau';

  // Paywall
  String get cp_paywall_title => _isEn ? 'Premium case' : 'Cas premium';
  String get cp_paywall_message => _isEn
      ? "This case is part of COP'IQ Premium. Activate your subscription."
      : "Ce cas fait partie de la bibliothèque COP'IQ Premium. Active ton abonnement pour débloquer tous les cas.";
  String get cp_paywall_later => _isEn ? 'Not now' : 'Plus tard';
  String get cp_paywall_cta => _isEn ? 'See subscription' : "Voir l'abonnement";

  // Case flow
  String get cp_case_loading => _isEn ? 'Loading case…' : 'Chargement du cas…';
  String get cp_case_not_found_title => _isEn ? 'Case not found' : 'Cas introuvable';
  String get cp_case_error => _isEn ? 'Something went wrong.' : 'Une erreur est survenue.';
  String get cp_case_step_case => _isEn ? 'The case' : 'Le cas';
  String cp_case_step_question(int index, int total) =>
      _isEn ? 'Question $index / $total' : 'Question $index / $total';
  String get cp_case_step_correction => _isEn ? 'Correction' : 'Correction';
  String get cp_case_intro_objective_1 => _isEn ? 'Immersive reading of the scenario' : 'Lecture immersive du scénario';
  String get cp_case_intro_objective_2 => _isEn ? 'Clear answer structure' : 'Structure claire de réponse';
  String get cp_case_intro_objective_3 => _isEn ? 'Correction explained point by point' : 'Correction expliquée point par point';
  String get cp_case_intro_cta => _isEn ? 'Read the scenario' : 'Lire le scénario';
  String get cp_case_text_cta => _isEn ? 'Start' : 'Je commence';

  // Questions
  String cp_question_label(int index, int total) =>
      _isEn ? 'QUESTION $index / $total' : 'QUESTION $index / $total';
  String get cp_question_validate_last => _isEn ? 'Validate & correct' : 'Valider et corriger';
  String get cp_question_validate_next => _isEn ? 'Validate & continue' : 'Valider et continuer';
  String get cp_question_validated => _isEn ? 'Answer validated ✓' : 'Réponse validée ✓';
  String get cp_question_validated_pill => _isEn ? 'Validated' : 'Validée';
  String get cp_question_no_back => _isEn ? 'You can no longer go back after validation.' : 'Tu ne peux plus revenir en arrière après validation.';
  String get cp_question_no_back_snack => cp_question_no_back;
  String get cp_question_validate_error => _isEn ? 'Could not validate the answer. Please try again.' : 'Impossible de valider la réponse. Réessaie.';
  String get cp_question_login_required => _isEn ? 'Sign in to get your correction.' : 'Connecte-toi pour obtenir ta correction.';
  String cp_question_char_count(int count, int min, int recommended) =>
      _isEn ? '$count characters — min $min, recommended $recommended' : '$count caractères — minimum $min, recommandé $recommended';

  // Answer area
  String get cp_answer_placeholder => _isEn ? 'Type your answer here…' : 'Tape ta réponse ici…';
  String get cp_answer_save_typing => _isEn ? 'Modified' : 'Modifié';
  String get cp_answer_save_saving => _isEn ? 'Saving…' : 'Sauvegarde…';
  String get cp_answer_save_saved => _isEn ? 'Saved' : 'Sauvegardé';
  String cp_answer_save_saved_at(String time) =>
      _isEn ? 'Saved $time' : 'Sauvegardé $time';

  // Correction
  String get cp_correction_loading => _isEn ? 'Correcting your answers…' : 'On corrige ta copie…';
  String get cp_correction_loading_detail => _isEn ? 'Analysing each answer, keywords, formulations…' : 'Analyse de chaque réponse, mots-clés, formulations…';
  String get cp_correction_error => _isEn ? 'An error occurred during correction.' : 'Une erreur est survenue pendant la correction.';
  String get cp_correction_error_title => _isEn ? 'Correction failed' : 'Correction impossible';
  String get cp_correction_back_to_list => _isEn ? 'Back to list' : 'Retour à la liste';
  String cp_correction_engine_version(String version) =>
      _isEn ? 'Correction engine v$version' : 'Moteur de correction v$version';
  String get cp_correction_no_detail => _isEn ? 'No correction detail for this question.' : 'Pas de détail de correction pour cette question.';

  // Score
  String scoreLabel(double percent) {
    if (percent >= 90) return _isEn ? 'Excellent!' : 'Excellent !';
    if (percent >= 70) return _isEn ? 'Solid.' : 'Solide.';
    if (percent >= 50) return _isEn ? 'Not bad, but you can do better.' : 'Pas mal, mais il y a mieux.';
    return _isEn ? "Let's try again and target the missed points." : 'On recommence et on cible les points manqués.';
  }

  // Points
  String get cp_point_covered => _isEn ? 'Covered' : 'Couvert';
  String get cp_point_partial => _isEn ? 'Partial' : 'Partiel';
  String get cp_point_missing => _isEn ? 'Missed' : 'Manqué';
  String get cp_point_keywords_found => _isEn ? 'Found in your answer:' : 'Trouvé dans ta réponse :';
  String get cp_point_appeal_cta => _isEn ? 'I think my answer is correct' : 'Je pense que ma réponse est correcte';

  // Appeal
  String get cp_appeal_title => _isEn ? 'Appeal' : 'Faire appel';
  String get cp_appeal_label_point => _isEn ? 'EXPECTED POINT' : 'POINT ATTENDU';
  String get cp_appeal_label_answer => _isEn ? 'YOUR ANSWER' : 'TA RÉPONSE';
  String get cp_appeal_textarea_hint => _isEn ? 'Your argument' : 'Ton argumentaire';
  String get cp_appeal_warning => _isEn
      ? 'Your message will be sent to the teaching team. Appeals are reviewed within 48 hours.'
      : "Ton message sera transmis à l'équipe pédagogique. Les appels sont examinés sous 48 h.";
  String get cp_appeal_send => _isEn ? 'Send my appeal' : 'Envoyer mon appel';
  String get cp_appeal_sent_snack => _isEn ? 'Appeal sent. The teaching team will review it.' : "Appel envoyé. L'équipe pédagogique va l'examiner.";
  String get cp_appeal_send_error => _isEn ? "Could not send your appeal. Please try again." : "Impossible d'envoyer ton appel. Réessaie.";
  String get cp_appeal_already_sent => _isEn ? '📨 Appeal sent. The teaching team will review it.' : "📨 Appel envoyé. L'équipe pédagogique va l'examiner.";
  String get cp_appeal_no_appeal_on_point => _isEn ? 'Cannot appeal this point.' : 'Impossible de faire appel sur ce point.';

  // My appeals page
  String get cp_my_appeals_title => _isEn ? 'My Appeals' : 'Mes appels';
  String cp_my_appeals_count(int count) {
    if (count == 0) return _isEn ? 'No appeals yet' : 'Aucun appel pour le moment';
    if (count == 1) return _isEn ? '1 appeal in total' : '1 appel au total';
    return _isEn ? '$count appeals in total' : '$count appels au total';
  }
  String get cp_appeal_status_all => _isEn ? 'All' : 'Tous';
  String get cp_appeal_status_pending => _isEn ? 'Pending' : 'En cours';
  String get cp_appeal_status_approved => _isEn ? 'Approved' : 'Approuvés';
  String get cp_appeal_status_rejected => _isEn ? 'Rejected' : 'Rejetés';
  String get cp_appeal_admin_response => _isEn ? 'TEAM RESPONSE' : "RÉPONSE DE L'ÉQUIPE";
  String get cp_appeal_no_message => _isEn ? 'No message added.' : 'Pas de message ajouté.';
  String get cp_appeal_see_all => _isEn ? 'See all appeals' : 'Voir tous les appels';
  String get cp_appeal_empty_default => _isEn
      ? 'You haven\'t filed any appeal yet.\nOn a correction, tap "Appeal" on a missed point.'
      : "Tu n'as encore jamais fait appel.\nSur une correction, tape \"Faire appel\" sur un point manqué.";
  String get cp_appeal_empty_filtered => _isEn ? 'No appeal matches this filter.' : 'Aucun appel ne correspond à ce filtre.';

  // Misc
  String get cp_case_no_slug => _isEn ? 'No case specified.' : 'Aucun cas spécifié.';
  String get cp_case_point_missing_fallback => _isEn ? 'Missed point' : 'Point manqué';

  // Language switcher
  String get langSwitcherTitle => _isEn ? 'App language' : "Langue de l'application";
  String get langSwitcherFr => 'Français';
  String get langSwitcherEn => 'English';
  String langSwitcherSubtitle(String lang) =>
      _isEn ? 'Active language: $lang' : 'Langue active : $lang';
}

// ─── CpDateFormat — relative dates ────────────────────────────────────────

/// Formats a [DateTime] as a locale-aware relative string.
///
/// Examples (FR): "Aujourd'hui", "Hier", "Il y a 3 jours", "Il y a 2 mois".
class CpDateFormat {
  CpDateFormat._();

  /// Returns a short relative string for [date].
  static String relative(DateTime date, {String langCode = 'fr'}) {
    final now = DateTime.now();
    final diff = now.difference(date);
    final isEn = langCode == 'en';

    if (diff.inSeconds < 60) {
      return isEn ? 'Just now' : "À l'instant";
    }
    if (diff.inMinutes < 60) {
      final n = diff.inMinutes;
      return isEn ? '${n}min ago' : 'Il y a $n min';
    }
    // Same calendar day
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final dayDiff = today.difference(dateDay).inDays;
    if (dayDiff == 0) return isEn ? 'Today' : "Aujourd'hui";
    if (dayDiff == 1) return isEn ? 'Yesterday' : 'Hier';
    if (dayDiff < 30) return isEn ? 'Il y a $dayDiff days ago' : 'Il y a $dayDiff jours';
    final months = (dayDiff / 30).floor();
    return isEn ? '$months months ago' : 'Il y a $months mois';
  }

  /// Formats as full date — ex: "5 juin 2026" (FR) / "Jun 5, 2026" (EN).
  static String full(DateTime date, {String langCode = 'fr'}) {
    return DateFormat(
      langCode == 'en' ? 'MMM d, yyyy' : 'd MMMM yyyy',
      langCode,
    ).format(date);
  }

  /// Formats as short date — ex: "05/06/2026" (FR) / "06/05/2026" (EN).
  static String short(DateTime date, {String langCode = 'fr'}) {
    return DateFormat.yMd(langCode).format(date);
  }

  /// Formats a time — ex: "14:32" (FR/24h) / "2:32 PM" (EN).
  static String time(DateTime date, {String langCode = 'fr'}) {
    return langCode == 'en'
        ? DateFormat.jm('en').format(date)
        : DateFormat('HH:mm', 'fr').format(date);
  }
}

// ─── CpNumberFormat — scores and percentages ──────────────────────────────

/// Formats numbers in a locale-aware way (scores, percentages).
class CpNumberFormat {
  CpNumberFormat._();

  /// "12,5 / 15" (FR) or "12.5 / 15" (EN).
  static String score(double value, double max, {String langCode = 'fr'}) {
    final fmt = NumberFormat.decimalPatternDigits(
      locale: langCode,
      decimalDigits: value == value.truncateToDouble() ? 0 : 1,
    );
    return '${fmt.format(value)} / ${fmt.format(max)}';
  }

  /// "83 %" (FR) or "83%" (EN).
  static String percent(double value, {String langCode = 'fr', int decimals = 0}) {
    final fmt = NumberFormat.percentPattern(langCode);
    fmt.maximumFractionDigits = decimals;
    return fmt.format(value / 100);
  }

  /// Compact integer — "1 234" (FR) or "1,234" (EN).
  static String compact(num value, {String langCode = 'fr'}) {
    return NumberFormat.decimalPattern(langCode).format(value);
  }
}
