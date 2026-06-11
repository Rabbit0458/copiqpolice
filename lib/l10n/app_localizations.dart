import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'COP\'IQ'**
  String get appName;

  /// Bouton retour générique
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// Bouton réessayer
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// Bouton annuler
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// Bouton confirmer
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// Bouton fermer
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// Bouton enregistrer
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// Message de chargement
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get loading;

  /// Erreur générique
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get error_generic;

  /// Erreur chargement
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue pendant le chargement.'**
  String get error_loading;

  /// Erreur réseau
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion réseau. Vérifie ta connexion.'**
  String get error_no_connection;

  /// Non connecté
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour accéder à ce contenu.'**
  String get error_not_authenticated;

  /// Erreur serveur
  ///
  /// In fr, this message translates to:
  /// **'Problème serveur. Réessaie dans quelques instants.'**
  String get error_server;

  /// Nombre de points avec pluriel
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} point} other{{count} points}}'**
  String points_label(num count);

  /// Score X/Y points
  ///
  /// In fr, this message translates to:
  /// **'{scored}/{max} pt'**
  String points_score(num scored, num max);

  /// Titre page liste cas pratiques
  ///
  /// In fr, this message translates to:
  /// **'Cas Pratiques'**
  String get cp_list_title;

  /// Placeholder de recherche
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un cas, un mot-clé…'**
  String get cp_list_search_hint;

  /// Effacer la recherche
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get cp_list_search_clear;

  /// Ouvrir la recherche
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get cp_list_search_open;

  /// Fermer la recherche
  ///
  /// In fr, this message translates to:
  /// **'Fermer la recherche'**
  String get cp_list_search_close;

  /// Bouton trier
  ///
  /// In fr, this message translates to:
  /// **'Trier'**
  String get cp_list_sort;

  /// Indicateur tri actif
  ///
  /// In fr, this message translates to:
  /// **'Trié par : {label}'**
  String cp_list_sorted_by(String label);

  /// Titre état vide (liste)
  ///
  /// In fr, this message translates to:
  /// **'Aucun cas disponible'**
  String get cp_list_empty_title;

  /// Message état vide (liste)
  ///
  /// In fr, this message translates to:
  /// **'Les cas pratiques arrivent bientôt !'**
  String get cp_list_empty_message;

  /// Titre état vide filtres actifs
  ///
  /// In fr, this message translates to:
  /// **'Aucun cas pour ces filtres'**
  String get cp_list_empty_filters_title;

  /// Message état vide filtres actifs
  ///
  /// In fr, this message translates to:
  /// **'Essaie d\'élargir tes critères de recherche.'**
  String get cp_list_empty_filters_message;

  /// Bouton réinitialiser filtres
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les filtres'**
  String get cp_list_reset_filters;

  /// Label filtre année
  ///
  /// In fr, this message translates to:
  /// **'Année'**
  String get cp_filter_year;

  /// Label filtre thème
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get cp_filter_theme;

  /// Label filtre difficulté
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get cp_filter_difficulty;

  /// Effacer tous les filtres
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get cp_filter_clear;

  /// Titre sheet filtre année
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par année'**
  String get cp_filter_title_year;

  /// Titre sheet filtre thème
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par thème'**
  String get cp_filter_title_theme;

  /// Titre sheet filtre difficulté
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par difficulté'**
  String get cp_filter_title_difficulty;

  /// Vide filtre année
  ///
  /// In fr, this message translates to:
  /// **'Aucune année disponible pour le moment.'**
  String get cp_filter_empty_year;

  /// Vide filtre thème
  ///
  /// In fr, this message translates to:
  /// **'Aucun thème disponible pour le moment.'**
  String get cp_filter_empty_theme;

  /// Tri plus récent
  ///
  /// In fr, this message translates to:
  /// **'Plus récent'**
  String get cp_sort_recent;

  /// Sous-titre tri récent
  ///
  /// In fr, this message translates to:
  /// **'Les cas publiés en premier'**
  String get cp_sort_recent_subtitle;

  /// Tri alphabétique
  ///
  /// In fr, this message translates to:
  /// **'Alphabétique (A → Z)'**
  String get cp_sort_alpha;

  /// Sous-titre tri alphabétique
  ///
  /// In fr, this message translates to:
  /// **'Ordre du titre du cas'**
  String get cp_sort_alpha_subtitle;

  /// Tri durée croissante
  ///
  /// In fr, this message translates to:
  /// **'Durée croissante'**
  String get cp_sort_duration_asc;

  /// Sous-titre tri durée croissante
  ///
  /// In fr, this message translates to:
  /// **'Les plus courts d\'abord'**
  String get cp_sort_duration_asc_subtitle;

  /// Tri durée décroissante
  ///
  /// In fr, this message translates to:
  /// **'Durée décroissante'**
  String get cp_sort_duration_desc;

  /// Sous-titre tri durée décroissante
  ///
  /// In fr, this message translates to:
  /// **'Les plus longs d\'abord'**
  String get cp_sort_duration_desc_subtitle;

  /// Titre sheet tri
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get cp_sort_by;

  /// Badge cas gratuit
  ///
  /// In fr, this message translates to:
  /// **'GRATUIT'**
  String get cp_badge_free;

  /// Badge cas premium
  ///
  /// In fr, this message translates to:
  /// **'PREMIUM'**
  String get cp_badge_premium;

  /// Badge cas nouveau
  ///
  /// In fr, this message translates to:
  /// **'NOUVEAU'**
  String get cp_badge_new;

  /// Difficulté facile
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get cp_difficulty_easy;

  /// Difficulté moyen
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get cp_difficulty_medium;

  /// Difficulté difficile
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get cp_difficulty_hard;

  /// Colonne dernier score sur carte cas
  ///
  /// In fr, this message translates to:
  /// **'Dernier'**
  String get cp_tile_last_score;

  /// Colonne meilleur score sur carte cas
  ///
  /// In fr, this message translates to:
  /// **'Meilleur'**
  String get cp_tile_best_score;

  /// Colonne taux de réussite sur carte cas
  ///
  /// In fr, this message translates to:
  /// **'Réussite'**
  String get cp_tile_success_rate;

  /// Statut nouveau sur carte cas
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get cp_tile_status_new;

  /// Titre dialog paywall
  ///
  /// In fr, this message translates to:
  /// **'Cas premium'**
  String get cp_paywall_title;

  /// Message dialog paywall
  ///
  /// In fr, this message translates to:
  /// **'Ce cas fait partie de la bibliothèque COP\'IQ Premium. Active ton abonnement pour débloquer tous les cas.'**
  String get cp_paywall_message;

  /// Bouton plus tard paywall
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get cp_paywall_later;

  /// Bouton CTA paywall
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'abonnement'**
  String get cp_paywall_cta;

  /// Chargement du cas
  ///
  /// In fr, this message translates to:
  /// **'Chargement du cas…'**
  String get cp_case_loading;

  /// Titre erreur cas introuvable
  ///
  /// In fr, this message translates to:
  /// **'Cas introuvable'**
  String get cp_case_not_found_title;

  /// Erreur générique cas
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get cp_case_error;

  /// Étape 'Le cas' dans le stepper
  ///
  /// In fr, this message translates to:
  /// **'Le cas'**
  String get cp_case_step_case;

  /// Étape question dans le stepper
  ///
  /// In fr, this message translates to:
  /// **'Question {index} / {total}'**
  String cp_case_step_question(int index, int total);

  /// Étape correction dans le stepper
  ///
  /// In fr, this message translates to:
  /// **'Correction'**
  String get cp_case_step_correction;

  /// Objectif intro 1
  ///
  /// In fr, this message translates to:
  /// **'Lecture immersive du scénario'**
  String get cp_case_intro_objective_1;

  /// Objectif intro 2
  ///
  /// In fr, this message translates to:
  /// **'Structure claire de réponse'**
  String get cp_case_intro_objective_2;

  /// Objectif intro 3
  ///
  /// In fr, this message translates to:
  /// **'Correction expliquée point par point'**
  String get cp_case_intro_objective_3;

  /// CTA intro cas
  ///
  /// In fr, this message translates to:
  /// **'Lire le scénario'**
  String get cp_case_intro_cta;

  /// CTA texte cas
  ///
  /// In fr, this message translates to:
  /// **'Je commence'**
  String get cp_case_text_cta;

  /// Label question numérotée
  ///
  /// In fr, this message translates to:
  /// **'QUESTION {index} / {total}'**
  String cp_question_label(int index, int total);

  /// Bouton valider dernière question
  ///
  /// In fr, this message translates to:
  /// **'Valider et corriger'**
  String get cp_question_validate_last;

  /// Bouton valider et passer à la suite
  ///
  /// In fr, this message translates to:
  /// **'Valider et continuer'**
  String get cp_question_validate_next;

  /// Pill question validée
  ///
  /// In fr, this message translates to:
  /// **'Réponse validée ✓'**
  String get cp_question_validated;

  /// Pill courte validée
  ///
  /// In fr, this message translates to:
  /// **'Validée'**
  String get cp_question_validated_pill;

  /// Footnote lock navigation
  ///
  /// In fr, this message translates to:
  /// **'Tu ne peux plus revenir en arrière après validation.'**
  String get cp_question_no_back;

  /// Snackbar lock navigation
  ///
  /// In fr, this message translates to:
  /// **'Tu ne peux plus revenir en arrière après validation.'**
  String get cp_question_no_back_snack;

  /// Erreur validation réponse
  ///
  /// In fr, this message translates to:
  /// **'Impossible de valider la réponse. Réessaie.'**
  String get cp_question_validate_error;

  /// Login requis correction
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour obtenir ta correction.'**
  String get cp_question_login_required;

  /// Compteur de caractères dans la zone de réponse
  ///
  /// In fr, this message translates to:
  /// **'{count} caractères — minimum {min}, recommandé {recommended}'**
  String cp_question_char_count(int count, int min, int recommended);

  /// Placeholder zone de réponse
  ///
  /// In fr, this message translates to:
  /// **'Tape ta réponse ici…'**
  String get cp_answer_placeholder;

  /// État typing de la sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Modifié'**
  String get cp_answer_save_typing;

  /// État saving de la sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde…'**
  String get cp_answer_save_saving;

  /// État saved de la sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardé'**
  String get cp_answer_save_saved;

  /// Sauvegardé il y a X
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardé {time}'**
  String cp_answer_save_saved_at(String time);

  /// Chargement correction
  ///
  /// In fr, this message translates to:
  /// **'On corrige ta copie…'**
  String get cp_correction_loading;

  /// Détail chargement correction
  ///
  /// In fr, this message translates to:
  /// **'Analyse de chaque réponse, mots-clés, formulations…'**
  String get cp_correction_loading_detail;

  /// Erreur correction
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue pendant la correction.'**
  String get cp_correction_error;

  /// Titre erreur correction
  ///
  /// In fr, this message translates to:
  /// **'Correction impossible'**
  String get cp_correction_error_title;

  /// Bouton retour à la liste
  ///
  /// In fr, this message translates to:
  /// **'Retour à la liste'**
  String get cp_correction_back_to_list;

  /// Footer version moteur
  ///
  /// In fr, this message translates to:
  /// **'Moteur de correction v{version}'**
  String cp_correction_engine_version(String version);

  /// Pas de détail correction
  ///
  /// In fr, this message translates to:
  /// **'Pas de détail de correction pour cette question.'**
  String get cp_correction_no_detail;

  /// Mention score excellent (≥90%)
  ///
  /// In fr, this message translates to:
  /// **'Excellent !'**
  String get cp_score_excellent;

  /// Mention score solide (≥70%)
  ///
  /// In fr, this message translates to:
  /// **'Solide.'**
  String get cp_score_solid;

  /// Mention score moyen (≥50%)
  ///
  /// In fr, this message translates to:
  /// **'Pas mal, mais il y a mieux.'**
  String get cp_score_not_bad;

  /// Mention score faible (<50%)
  ///
  /// In fr, this message translates to:
  /// **'On recommence et on cible les points manqués.'**
  String get cp_score_work;

  /// Statut point couvert
  ///
  /// In fr, this message translates to:
  /// **'Couvert'**
  String get cp_point_covered;

  /// Statut point partiel
  ///
  /// In fr, this message translates to:
  /// **'Partiel'**
  String get cp_point_partial;

  /// Statut point manqué
  ///
  /// In fr, this message translates to:
  /// **'Manqué'**
  String get cp_point_missing;

  /// Label mots-clés trouvés
  ///
  /// In fr, this message translates to:
  /// **'Trouvé dans ta réponse :'**
  String get cp_point_keywords_found;

  /// CTA appel sur point manqué
  ///
  /// In fr, this message translates to:
  /// **'Je pense que ma réponse est correcte'**
  String get cp_point_appeal_cta;

  /// Titre sheet appel
  ///
  /// In fr, this message translates to:
  /// **'Faire appel'**
  String get cp_appeal_title;

  /// Label point attendu dans l'appel
  ///
  /// In fr, this message translates to:
  /// **'POINT ATTENDU'**
  String get cp_appeal_label_point;

  /// Label réponse user dans l'appel
  ///
  /// In fr, this message translates to:
  /// **'TA RÉPONSE'**
  String get cp_appeal_label_answer;

  /// Hint textarea appel
  ///
  /// In fr, this message translates to:
  /// **'Ton argumentaire'**
  String get cp_appeal_textarea_hint;

  /// Avertissement appel
  ///
  /// In fr, this message translates to:
  /// **'Ton message sera transmis à l\'équipe pédagogique. Les appels sont examinés sous 48 h.'**
  String get cp_appeal_warning;

  /// Bouton envoyer appel
  ///
  /// In fr, this message translates to:
  /// **'Envoyer mon appel'**
  String get cp_appeal_send;

  /// Snackbar appel envoyé
  ///
  /// In fr, this message translates to:
  /// **'Appel envoyé. L\'équipe pédagogique va l\'examiner.'**
  String get cp_appeal_sent_snack;

  /// Erreur envoi appel
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'envoyer ton appel. Réessaie.'**
  String get cp_appeal_send_error;

  /// Suffixe explication après envoi appel
  ///
  /// In fr, this message translates to:
  /// **'📨 Appel envoyé. L\'équipe pédagogique va l\'examiner.'**
  String get cp_appeal_already_sent;

  /// Erreur appel point invalide
  ///
  /// In fr, this message translates to:
  /// **'Impossible de faire appel sur ce point.'**
  String get cp_appeal_no_appeal_on_point;

  /// Titre page mes appels
  ///
  /// In fr, this message translates to:
  /// **'Mes appels'**
  String get cp_my_appeals_title;

  /// Sous-titre nb appels
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, zero{Aucun appel pour le moment} one{{count} appel au total} other{{count} appels au total}}'**
  String cp_my_appeals_count(int count);

  /// Filtre appels tous
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get cp_appeal_status_all;

  /// Statut appel en cours
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get cp_appeal_status_pending;

  /// Statut appels approuvés
  ///
  /// In fr, this message translates to:
  /// **'Approuvés'**
  String get cp_appeal_status_approved;

  /// Statut appels rejetés
  ///
  /// In fr, this message translates to:
  /// **'Rejetés'**
  String get cp_appeal_status_rejected;

  /// Label réponse admin
  ///
  /// In fr, this message translates to:
  /// **'RÉPONSE DE L\'ÉQUIPE'**
  String get cp_appeal_admin_response;

  /// Pas de message dans appel
  ///
  /// In fr, this message translates to:
  /// **'Pas de message ajouté.'**
  String get cp_appeal_no_message;

  /// Bouton voir tous les appels
  ///
  /// In fr, this message translates to:
  /// **'Voir tous les appels'**
  String get cp_appeal_see_all;

  /// Message vide appels par défaut
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'as encore jamais fait appel.\nSur une correction, tape Faire appel sur un point manqué.'**
  String get cp_appeal_empty_default;

  /// Message vide appels filtrés
  ///
  /// In fr, this message translates to:
  /// **'Aucun appel ne correspond à ce filtre.'**
  String get cp_appeal_empty_filtered;

  /// Erreur pas de slug
  ///
  /// In fr, this message translates to:
  /// **'Aucun cas spécifié.'**
  String get cp_case_no_slug;

  /// Fallback label point manqué
  ///
  /// In fr, this message translates to:
  /// **'Point manqué'**
  String get cp_case_point_missing_fallback;

  /// Titre du sélecteur de langue
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'application'**
  String get langSwitcherTitle;

  /// Option langue française
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get langSwitcherFr;

  /// Option langue anglaise
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get langSwitcherEn;

  /// Sous-titre langue active
  ///
  /// In fr, this message translates to:
  /// **'Langue active : {lang}'**
  String langSwitcherSubtitle(String lang);

  /// Date aujourd'hui
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get dateToday;

  /// Date hier
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get dateYesterday;

  /// Il y a N jours
  ///
  /// In fr, this message translates to:
  /// **'Il y a {n} jours'**
  String dateNDaysAgo(int n);

  /// Il y a N mois
  ///
  /// In fr, this message translates to:
  /// **'Il y a {n} mois'**
  String dateNMonthsAgo(int n);

  /// Il y a N minutes
  ///
  /// In fr, this message translates to:
  /// **'Il y a {n} min'**
  String dateNMinutesAgo(int n);

  /// Maintenant / à l'instant
  ///
  /// In fr, this message translates to:
  /// **'À l\'instant'**
  String get dateNSecondsAgo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
