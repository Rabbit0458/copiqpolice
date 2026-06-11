// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'COP\'IQ';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get loading => 'Loading…';

  @override
  String get error_generic => 'Something went wrong.';

  @override
  String get error_loading => 'An error occurred while loading.';

  @override
  String get error_no_connection =>
      'No network connection. Check your connection.';

  @override
  String get error_not_authenticated => 'Sign in to access this content.';

  @override
  String get error_server => 'Server issue. Try again in a moment.';

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
  String get cp_list_title => 'Practical Cases';

  @override
  String get cp_list_search_hint => 'Search a case, a keyword…';

  @override
  String get cp_list_search_clear => 'Clear';

  @override
  String get cp_list_search_open => 'Search';

  @override
  String get cp_list_search_close => 'Close search';

  @override
  String get cp_list_sort => 'Sort';

  @override
  String cp_list_sorted_by(String label) {
    return 'Sorted by: $label';
  }

  @override
  String get cp_list_empty_title => 'No cases available';

  @override
  String get cp_list_empty_message => 'Practical cases are coming soon!';

  @override
  String get cp_list_empty_filters_title => 'No cases for these filters';

  @override
  String get cp_list_empty_filters_message =>
      'Try broadening your search criteria.';

  @override
  String get cp_list_reset_filters => 'Reset filters';

  @override
  String get cp_filter_year => 'Year';

  @override
  String get cp_filter_theme => 'Theme';

  @override
  String get cp_filter_difficulty => 'Difficulty';

  @override
  String get cp_filter_clear => 'Clear';

  @override
  String get cp_filter_title_year => 'Filter by year';

  @override
  String get cp_filter_title_theme => 'Filter by theme';

  @override
  String get cp_filter_title_difficulty => 'Filter by difficulty';

  @override
  String get cp_filter_empty_year => 'No years available yet.';

  @override
  String get cp_filter_empty_theme => 'No themes available yet.';

  @override
  String get cp_sort_recent => 'Most recent';

  @override
  String get cp_sort_recent_subtitle => 'Cases published first';

  @override
  String get cp_sort_alpha => 'Alphabetical (A → Z)';

  @override
  String get cp_sort_alpha_subtitle => 'Ordered by case title';

  @override
  String get cp_sort_duration_asc => 'Shortest first';

  @override
  String get cp_sort_duration_asc_subtitle => 'Quickest cases first';

  @override
  String get cp_sort_duration_desc => 'Longest first';

  @override
  String get cp_sort_duration_desc_subtitle => 'Longest cases first';

  @override
  String get cp_sort_by => 'Sort by';

  @override
  String get cp_badge_free => 'FREE';

  @override
  String get cp_badge_premium => 'PREMIUM';

  @override
  String get cp_badge_new => 'NEW';

  @override
  String get cp_difficulty_easy => 'Easy';

  @override
  String get cp_difficulty_medium => 'Medium';

  @override
  String get cp_difficulty_hard => 'Hard';

  @override
  String get cp_tile_last_score => 'Last';

  @override
  String get cp_tile_best_score => 'Best';

  @override
  String get cp_tile_success_rate => 'Rate';

  @override
  String get cp_tile_status_new => 'New';

  @override
  String get cp_paywall_title => 'Premium case';

  @override
  String get cp_paywall_message =>
      'This case is part of the COP\'IQ Premium library. Activate your subscription to unlock all cases.';

  @override
  String get cp_paywall_later => 'Not now';

  @override
  String get cp_paywall_cta => 'See subscription';

  @override
  String get cp_case_loading => 'Loading case…';

  @override
  String get cp_case_not_found_title => 'Case not found';

  @override
  String get cp_case_error => 'Something went wrong.';

  @override
  String get cp_case_step_case => 'The case';

  @override
  String cp_case_step_question(int index, int total) {
    return 'Question $index / $total';
  }

  @override
  String get cp_case_step_correction => 'Correction';

  @override
  String get cp_case_intro_objective_1 => 'Immersive reading of the scenario';

  @override
  String get cp_case_intro_objective_2 => 'Clear answer structure';

  @override
  String get cp_case_intro_objective_3 => 'Correction explained point by point';

  @override
  String get cp_case_intro_cta => 'Read the scenario';

  @override
  String get cp_case_text_cta => 'Start';

  @override
  String cp_question_label(int index, int total) {
    return 'QUESTION $index / $total';
  }

  @override
  String get cp_question_validate_last => 'Validate & correct';

  @override
  String get cp_question_validate_next => 'Validate & continue';

  @override
  String get cp_question_validated => 'Answer validated ✓';

  @override
  String get cp_question_validated_pill => 'Validated';

  @override
  String get cp_question_no_back =>
      'You can no longer go back after validation.';

  @override
  String get cp_question_no_back_snack =>
      'You can no longer go back after validation.';

  @override
  String get cp_question_validate_error =>
      'Could not validate the answer. Please try again.';

  @override
  String get cp_question_login_required => 'Sign in to get your correction.';

  @override
  String cp_question_char_count(int count, int min, int recommended) {
    return '$count characters — min $min, recommended $recommended';
  }

  @override
  String get cp_answer_placeholder => 'Type your answer here…';

  @override
  String get cp_answer_save_typing => 'Modified';

  @override
  String get cp_answer_save_saving => 'Saving…';

  @override
  String get cp_answer_save_saved => 'Saved';

  @override
  String cp_answer_save_saved_at(String time) {
    return 'Saved $time';
  }

  @override
  String get cp_correction_loading => 'Correcting your answers…';

  @override
  String get cp_correction_loading_detail =>
      'Analysing each answer, keywords, formulations…';

  @override
  String get cp_correction_error => 'An error occurred during correction.';

  @override
  String get cp_correction_error_title => 'Correction failed';

  @override
  String get cp_correction_back_to_list => 'Back to list';

  @override
  String cp_correction_engine_version(String version) {
    return 'Correction engine v$version';
  }

  @override
  String get cp_correction_no_detail =>
      'No correction detail for this question.';

  @override
  String get cp_score_excellent => 'Excellent!';

  @override
  String get cp_score_solid => 'Solid.';

  @override
  String get cp_score_not_bad => 'Not bad, but you can do better.';

  @override
  String get cp_score_work => 'Let\'s try again and target the missed points.';

  @override
  String get cp_point_covered => 'Covered';

  @override
  String get cp_point_partial => 'Partial';

  @override
  String get cp_point_missing => 'Missed';

  @override
  String get cp_point_keywords_found => 'Found in your answer:';

  @override
  String get cp_point_appeal_cta => 'I think my answer is correct';

  @override
  String get cp_appeal_title => 'Appeal';

  @override
  String get cp_appeal_label_point => 'EXPECTED POINT';

  @override
  String get cp_appeal_label_answer => 'YOUR ANSWER';

  @override
  String get cp_appeal_textarea_hint => 'Your argument';

  @override
  String get cp_appeal_warning =>
      'Your message will be sent to the teaching team. Appeals are reviewed within 48 hours.';

  @override
  String get cp_appeal_send => 'Send my appeal';

  @override
  String get cp_appeal_sent_snack =>
      'Appeal sent. The teaching team will review it.';

  @override
  String get cp_appeal_send_error =>
      'Could not send your appeal. Please try again.';

  @override
  String get cp_appeal_already_sent =>
      '📨 Appeal sent. The teaching team will review it.';

  @override
  String get cp_appeal_no_appeal_on_point => 'Cannot appeal this point.';

  @override
  String get cp_my_appeals_title => 'My Appeals';

  @override
  String cp_my_appeals_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appeals in total',
      one: '$count appeal in total',
      zero: 'No appeals yet',
    );
    return '$_temp0';
  }

  @override
  String get cp_appeal_status_all => 'All';

  @override
  String get cp_appeal_status_pending => 'Pending';

  @override
  String get cp_appeal_status_approved => 'Approved';

  @override
  String get cp_appeal_status_rejected => 'Rejected';

  @override
  String get cp_appeal_admin_response => 'TEAM RESPONSE';

  @override
  String get cp_appeal_no_message => 'No message added.';

  @override
  String get cp_appeal_see_all => 'See all appeals';

  @override
  String get cp_appeal_empty_default =>
      'You haven\'t filed any appeal yet.\nOn a correction, tap \"Appeal\" on a missed point.';

  @override
  String get cp_appeal_empty_filtered => 'No appeal matches this filter.';

  @override
  String get cp_case_no_slug => 'No case specified.';

  @override
  String get cp_case_point_missing_fallback => 'Missed point';

  @override
  String get langSwitcherTitle => 'App language';

  @override
  String get langSwitcherFr => 'Français';

  @override
  String get langSwitcherEn => 'English';

  @override
  String langSwitcherSubtitle(String lang) {
    return 'Active language: $lang';
  }

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String dateNDaysAgo(int n) {
    return '$n days ago';
  }

  @override
  String dateNMonthsAgo(int n) {
    return '$n months ago';
  }

  @override
  String dateNMinutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String get dateNSecondsAgo => 'Just now';
}
