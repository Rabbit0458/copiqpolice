// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'COP\'IQ';

  @override
  String get back => 'Retour';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get close => 'Fermer';

  @override
  String get save => 'Enregistrer';

  @override
  String get loading => 'Chargement…';

  @override
  String get error_generic => 'Une erreur est survenue.';

  @override
  String get error_loading => 'Une erreur est survenue pendant le chargement.';

  @override
  String get error_no_connection =>
      'Pas de connexion réseau. Vérifie ta connexion.';

  @override
  String get error_not_authenticated =>
      'Connecte-toi pour accéder à ce contenu.';

  @override
  String get error_server =>
      'Problème serveur. Réessaie dans quelques instants.';

  @override
  String points_label(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString points',
      one: '$countString point',
    );
    return '$_temp0';
  }

  @override
  String points_score(num scored, num max) {
    return '$scored/$max pt';
  }

  @override
  String get cp_list_title => 'Cas Pratiques';

  @override
  String get cp_list_search_hint => 'Rechercher un cas, un mot-clé…';

  @override
  String get cp_list_search_clear => 'Effacer';

  @override
  String get cp_list_search_open => 'Rechercher';

  @override
  String get cp_list_search_close => 'Fermer la recherche';

  @override
  String get cp_list_sort => 'Trier';

  @override
  String cp_list_sorted_by(String label) {
    return 'Trié par : $label';
  }

  @override
  String get cp_list_empty_title => 'Aucun cas disponible';

  @override
  String get cp_list_empty_message => 'Les cas pratiques arrivent bientôt !';

  @override
  String get cp_list_empty_filters_title => 'Aucun cas pour ces filtres';

  @override
  String get cp_list_empty_filters_message =>
      'Essaie d\'élargir tes critères de recherche.';

  @override
  String get cp_list_reset_filters => 'Réinitialiser les filtres';

  @override
  String get cp_filter_year => 'Année';

  @override
  String get cp_filter_theme => 'Thème';

  @override
  String get cp_filter_difficulty => 'Difficulté';

  @override
  String get cp_filter_clear => 'Effacer';

  @override
  String get cp_filter_title_year => 'Filtrer par année';

  @override
  String get cp_filter_title_theme => 'Filtrer par thème';

  @override
  String get cp_filter_title_difficulty => 'Filtrer par difficulté';

  @override
  String get cp_filter_empty_year => 'Aucune année disponible pour le moment.';

  @override
  String get cp_filter_empty_theme => 'Aucun thème disponible pour le moment.';

  @override
  String get cp_sort_recent => 'Plus récent';

  @override
  String get cp_sort_recent_subtitle => 'Les cas publiés en premier';

  @override
  String get cp_sort_alpha => 'Alphabétique (A → Z)';

  @override
  String get cp_sort_alpha_subtitle => 'Ordre du titre du cas';

  @override
  String get cp_sort_duration_asc => 'Durée croissante';

  @override
  String get cp_sort_duration_asc_subtitle => 'Les plus courts d\'abord';

  @override
  String get cp_sort_duration_desc => 'Durée décroissante';

  @override
  String get cp_sort_duration_desc_subtitle => 'Les plus longs d\'abord';

  @override
  String get cp_sort_by => 'Trier par';

  @override
  String get cp_badge_free => 'GRATUIT';

  @override
  String get cp_badge_premium => 'PREMIUM';

  @override
  String get cp_badge_new => 'NOUVEAU';

  @override
  String get cp_difficulty_easy => 'Facile';

  @override
  String get cp_difficulty_medium => 'Moyen';

  @override
  String get cp_difficulty_hard => 'Difficile';

  @override
  String get cp_tile_last_score => 'Dernier';

  @override
  String get cp_tile_best_score => 'Meilleur';

  @override
  String get cp_tile_success_rate => 'Réussite';

  @override
  String get cp_tile_status_new => 'Nouveau';

  @override
  String get cp_paywall_title => 'Cas premium';

  @override
  String get cp_paywall_message =>
      'Ce cas fait partie de la bibliothèque COP\'IQ Premium. Active ton abonnement pour débloquer tous les cas.';

  @override
  String get cp_paywall_later => 'Plus tard';

  @override
  String get cp_paywall_cta => 'Voir l\'abonnement';

  @override
  String get cp_case_loading => 'Chargement du cas…';

  @override
  String get cp_case_not_found_title => 'Cas introuvable';

  @override
  String get cp_case_error => 'Une erreur est survenue.';

  @override
  String get cp_case_step_case => 'Le cas';

  @override
  String cp_case_step_question(int index, int total) {
    return 'Question $index / $total';
  }

  @override
  String get cp_case_step_correction => 'Correction';

  @override
  String get cp_case_intro_objective_1 => 'Lecture immersive du scénario';

  @override
  String get cp_case_intro_objective_2 => 'Structure claire de réponse';

  @override
  String get cp_case_intro_objective_3 =>
      'Correction expliquée point par point';

  @override
  String get cp_case_intro_cta => 'Lire le scénario';

  @override
  String get cp_case_text_cta => 'Je commence';

  @override
  String cp_question_label(int index, int total) {
    return 'QUESTION $index / $total';
  }

  @override
  String get cp_question_validate_last => 'Valider et corriger';

  @override
  String get cp_question_validate_next => 'Valider et continuer';

  @override
  String get cp_question_validated => 'Réponse validée ✓';

  @override
  String get cp_question_validated_pill => 'Validée';

  @override
  String get cp_question_no_back =>
      'Tu ne peux plus revenir en arrière après validation.';

  @override
  String get cp_question_no_back_snack =>
      'Tu ne peux plus revenir en arrière après validation.';

  @override
  String get cp_question_validate_error =>
      'Impossible de valider la réponse. Réessaie.';

  @override
  String get cp_question_login_required =>
      'Connecte-toi pour obtenir ta correction.';

  @override
  String cp_question_char_count(int count, int min, int recommended) {
    return '$count caractères — minimum $min, recommandé $recommended';
  }

  @override
  String get cp_answer_placeholder => 'Tape ta réponse ici…';

  @override
  String get cp_answer_save_typing => 'Modifié';

  @override
  String get cp_answer_save_saving => 'Sauvegarde…';

  @override
  String get cp_answer_save_saved => 'Sauvegardé';

  @override
  String cp_answer_save_saved_at(String time) {
    return 'Sauvegardé $time';
  }

  @override
  String get cp_correction_loading => 'On corrige ta copie…';

  @override
  String get cp_correction_loading_detail =>
      'Analyse de chaque réponse, mots-clés, formulations…';

  @override
  String get cp_correction_error =>
      'Une erreur est survenue pendant la correction.';

  @override
  String get cp_correction_error_title => 'Correction impossible';

  @override
  String get cp_correction_back_to_list => 'Retour à la liste';

  @override
  String cp_correction_engine_version(String version) {
    return 'Moteur de correction v$version';
  }

  @override
  String get cp_correction_no_detail =>
      'Pas de détail de correction pour cette question.';

  @override
  String get cp_score_excellent => 'Excellent !';

  @override
  String get cp_score_solid => 'Solide.';

  @override
  String get cp_score_not_bad => 'Pas mal, mais il y a mieux.';

  @override
  String get cp_score_work => 'On recommence et on cible les points manqués.';

  @override
  String get cp_point_covered => 'Couvert';

  @override
  String get cp_point_partial => 'Partiel';

  @override
  String get cp_point_missing => 'Manqué';

  @override
  String get cp_point_keywords_found => 'Trouvé dans ta réponse :';

  @override
  String get cp_point_appeal_cta => 'Je pense que ma réponse est correcte';

  @override
  String get cp_appeal_title => 'Faire appel';

  @override
  String get cp_appeal_label_point => 'POINT ATTENDU';

  @override
  String get cp_appeal_label_answer => 'TA RÉPONSE';

  @override
  String get cp_appeal_textarea_hint => 'Ton argumentaire';

  @override
  String get cp_appeal_warning =>
      'Ton message sera transmis à l\'équipe pédagogique. Les appels sont examinés sous 48 h.';

  @override
  String get cp_appeal_send => 'Envoyer mon appel';

  @override
  String get cp_appeal_sent_snack =>
      'Appel envoyé. L\'équipe pédagogique va l\'examiner.';

  @override
  String get cp_appeal_send_error =>
      'Impossible d\'envoyer ton appel. Réessaie.';

  @override
  String get cp_appeal_already_sent =>
      '📨 Appel envoyé. L\'équipe pédagogique va l\'examiner.';

  @override
  String get cp_appeal_no_appeal_on_point =>
      'Impossible de faire appel sur ce point.';

  @override
  String get cp_my_appeals_title => 'Mes appels';

  @override
  String cp_my_appeals_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appels au total',
      one: '$count appel au total',
      zero: 'Aucun appel pour le moment',
    );
    return '$_temp0';
  }

  @override
  String get cp_appeal_status_all => 'Tous';

  @override
  String get cp_appeal_status_pending => 'En cours';

  @override
  String get cp_appeal_status_approved => 'Approuvés';

  @override
  String get cp_appeal_status_rejected => 'Rejetés';

  @override
  String get cp_appeal_admin_response => 'RÉPONSE DE L\'ÉQUIPE';

  @override
  String get cp_appeal_no_message => 'Pas de message ajouté.';

  @override
  String get cp_appeal_see_all => 'Voir tous les appels';

  @override
  String get cp_appeal_empty_default =>
      'Tu n\'as encore jamais fait appel.\nSur une correction, tape Faire appel sur un point manqué.';

  @override
  String get cp_appeal_empty_filtered =>
      'Aucun appel ne correspond à ce filtre.';

  @override
  String get cp_case_no_slug => 'Aucun cas spécifié.';

  @override
  String get cp_case_point_missing_fallback => 'Point manqué';

  @override
  String get langSwitcherTitle => 'Langue de l\'application';

  @override
  String get langSwitcherFr => 'Français';

  @override
  String get langSwitcherEn => 'English';

  @override
  String langSwitcherSubtitle(String lang) {
    return 'Langue active : $lang';
  }

  @override
  String get dateToday => 'Aujourd\'hui';

  @override
  String get dateYesterday => 'Hier';

  @override
  String dateNDaysAgo(int n) {
    return 'Il y a $n jours';
  }

  @override
  String dateNMonthsAgo(int n) {
    return 'Il y a $n mois';
  }

  @override
  String dateNMinutesAgo(int n) {
    return 'Il y a $n min';
  }

  @override
  String get dateNSecondsAgo => 'À l\'instant';
}
