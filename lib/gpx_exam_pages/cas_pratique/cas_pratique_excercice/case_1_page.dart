// lib/gpx_exam/concours/cas_pratique/cases/case_1_page.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:copiqpolice/ui/app_notifier.dart'
    show AppSettingsController, AppNotifier;

class GpxCasPratiqueCase1Page extends StatefulWidget {
  const GpxCasPratiqueCase1Page({super.key});

  static const String routeName = '/gpx_exam/concours/cas_pratique/case_1';

  @override
  State<GpxCasPratiqueCase1Page> createState() =>
      _GpxCasPratiqueCase1PageState();
}

class _GpxCasPratiqueCase1PageState extends State<GpxCasPratiqueCase1Page> {
  static const Color _kBlue = Color(0xFF1147D9);
  static const String _caseId = 'case_1';

  // Pages:
  // 0 = Intro
  // 1 = Texte du cas
  // 2..4 = Q1..Q3
  // 5 = Correction (intégrée)
  static const int _qCount = 3;
  static const int _correctionPageIndex = 2 + _qCount; // 5

  late final String _attemptId;

  final PageController _pc = PageController();
  int _index = 0;

  late final List<TextEditingController> _answerCtrls = List.generate(
    _qCount,
    (_) => TextEditingController(),
  );

  /// validé = l'utilisateur a appuyé sur "Valider" ET save ok
  final List<bool> _validated = List.generate(_qCount, (_) => false);

  bool _saving = false;

  /// lock back : dès qu’on avance, on ne peut plus revenir en dessous de cette page
  int _minBackIndex = 0;

  // ✅ anti double navigation / anti Navigator locked
  bool _routePopBusy = false;
  bool _sheetCloseBusy = false;

  // ─────────────────────────────────────────────
  // CORRECTION (intégrée à la page)
  // ─────────────────────────────────────────────
  bool _corrLoading = false;
  String? _corrError;
  bool _corrLoadedOnce = false;

  int _total15 = 0;
  final Map<int, String> _userAnswers = {};
  final List<_CorrectionItem> _corrItems = [];

  late final List<_PerfectAnswer> _perfect = _buildPerfectAnswers();

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final disableByOS = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    return (mq?.disableAnimations ?? false) || disableByOS;
  }

  // ---------------- LIFECYCLE ----------------
  @override
  void initState() {
    super.initState();

    _attemptId = const Uuid().v4();

    for (final c in _answerCtrls) {
      c.addListener(_onAnswerChanged);
    }
  }

  void _onAnswerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _pc.dispose();
    for (final c in _answerCtrls) {
      c.removeListener(_onAnswerChanged);
      c.dispose();
    }
    super.dispose();
  }

  // ---------------- HELPERS ----------------
  bool get _isQuestionPage => _index >= 2 && _index <= (2 + _qCount - 1);
  int get _currentQuestionIndex => _index - 2; // 0..2
  bool get _isCorrectionPage => _index == _correctionPageIndex;

  bool get _canGoNext {
    // Intro + texte cas => next ok
    if (_index <= 1) return true;

    // Question => next seulement si validée
    if (_isQuestionPage) {
      return _validated[_currentQuestionIndex] == true;
    }

    // Correction => ok (mais on remplace le bouton par "Retour liste")
    return true;
  }

  bool get _backEnabled {
    if (_index == 0) return true;
    final target = _index - 1;
    return target >= _minBackIndex;
  }

  bool _canValidateQ(int qi) {
    if (qi < 0 || qi >= _qCount) return false;
    if (_saving) return false;
    if (_validated[qi]) return false;

    // gère espaces insécables
    final txt = _answerCtrls[qi].text.replaceAll('\u00A0', ' ').trim();
    return txt.isNotEmpty;
  }

  // ---------------- SAFE NAV ----------------
  /// ✅ Pop de la ROUTE (quitter la page) sans tomber dans !_debugLocked
  void _safePopRoute() {
    if (_routePopBusy) return;
    _routePopBusy = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _routePopBusy = false;
        return;
      }

      final nav = Navigator.of(context);
      if (nav.canPop()) {
        nav.pop();
      }

      _routePopBusy = false;
    });
  }

  void _goToList() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/gpx_exam/concours/cas_pratique/list',
      (r) => false,
    );
  }

  // ---------------- SAVE (Supabase) ----------------
  Future<void> _validateAndSaveQuestion(int questionIndex) async {
    if (_saving) return;

    if (questionIndex < 0 || questionIndex >= _qCount) {
      AppNotifier.error(
        context,
        title: "Erreur interne",
        message: "Index de question invalide.",
      );
      return;
    }

    if (_validated[questionIndex]) {
      AppNotifier.info(
        context,
        title: "Déjà validée",
        message: "Cette réponse est déjà enregistrée.",
      );
      return;
    }

    final sb = Supabase.instance.client;
    final user = sb.auth.currentUser;

    if (user == null) {
      AppNotifier.error(
        context,
        title: "Connexion requise",
        message: "Connecte-toi pour enregistrer tes réponses.",
      );
      return;
    }

    final txt = _answerCtrls[questionIndex].text
        .replaceAll('\u00A0', ' ')
        .trim();

    if (txt.isEmpty) {
      AppNotifier.warning(
        context,
        title: "Réponse vide",
        message: "Écris une réponse avant de valider.",
      );
      return;
    }

    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();
    setState(() => _saving = true);

    try {
      final payload = <String, dynamic>{
        'user_id': user.id,
        'case_id': _caseId,
        'attempt_id': _attemptId,
        'question_index': questionIndex,
        'answer': txt,
      };

      await sb.from('cas_pratique_answers').insert(payload);

      if (!mounted) return;

      setState(() {
        _validated[questionIndex] = true;
        _corrLoadedOnce = false; // correction à recharger
      });

      AppNotifier.success(
        context,
        title: "Réponse enregistrée",
        message: "✅ Ta réponse a bien été sauvegardée.",
      );
    } catch (e) {
      debugPrint(
        '[CAS_PRATIQUE][save_error] case=$_caseId q=$questionIndex err=$e',
      );

      if (!mounted) return;

      AppNotifier.error(
        context,
        title: "Erreur d’enregistrement",
        message:
            "Impossible d’enregistrer ta réponse.\n"
            "Si le problème persiste, vérifie la table / RLS / colonnes côté Supabase.",
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ---------------- CORRECTION LOAD (Supabase) ----------------
  Future<void> _loadCorrection() async {
    if (_corrLoading) return;

    final sb = Supabase.instance.client;
    final user = sb.auth.currentUser;

    if (!mounted) return;
    setState(() {
      _corrLoading = true;
      _corrError = null;
      _corrItems.clear();
      _userAnswers.clear();
      _total15 = 0;
    });

    if (user == null) {
      if (!mounted) return;
      setState(() {
        _corrLoading = false;
        _corrError = "Connexion requise.";
      });
      AppNotifier.error(
        context,
        title: "Connexion requise",
        message: "Connecte-toi pour voir ta correction.",
      );
      return;
    }

    try {
      final rows = await sb
          .from('cas_pratique_answers')
          .select('question_index, answer')
          .eq('user_id', user.id)
          .eq('case_id', _caseId)
          .eq('attempt_id', _attemptId);

      for (final r in (rows as List)) {
        final qiRaw = r['question_index'];
        final ans = (r['answer'] ?? '').toString();

        int? qi;
        if (qiRaw is int) {
          qi = qiRaw;
        } else if (qiRaw is num) {
          qi = qiRaw.toInt();
        } else {
          qi = int.tryParse(qiRaw.toString());
        }

        if (qi != null) _userAnswers[qi] = ans;
      }

      int total = 0;
      for (int qi = 0; qi < _qCount; qi++) {
        final pa = _perfect[qi];
        final ua = (_userAnswers[qi] ?? '').trim();

        final eval = _evaluateAnswer(userAnswer: ua, rubric: pa.rubric);
        total += eval.score5;

        _corrItems.add(
          _CorrectionItem(
            questionIndex: qi,
            questionTitle: "Question ${qi + 1}",
            userAnswer: ua,
            perfectAnswer: pa.answer,
            covered: eval.covered,
            missing: eval.missing,
            score5: eval.score5,
            warning: ua.isEmpty ? "Aucune réponse enregistrée." : null,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _total15 = total;
        _corrLoading = false;
        _corrLoadedOnce = true;
      });
    } catch (e) {
      debugPrint('[CASE_1_CORR][load_error] $e');
      if (!mounted) return;
      setState(() {
        _corrLoading = false;
        _corrError =
            "Impossible de charger la correction.\nVérifie ta connexion et ta table Supabase.";
      });
    }
  }

  // ─────────────────────────────────────────────
  // CORRECTION “PRO” SANS IA : grille de points attendus
  // ─────────────────────────────────────────────
  _EvalResult _evaluateAnswer({
    required String userAnswer,
    required List<_ExpectedPoint> rubric,
  }) {
    final ua = _normalize(userAnswer);

    final covered = <String>[];
    final missing = <String>[];

    for (final p in rubric) {
      final ok = _matchPoint(ua, p);
      if (ok) {
        covered.add(p.label);
      } else {
        missing.add(p.label);
      }
    }

    final total = rubric.isEmpty ? 0 : rubric.length;
    final ratio = total == 0 ? 0.0 : (covered.length / total);
    final score5 = (ratio * 5).round().clamp(0, 5);

    return _EvalResult(covered: covered, missing: missing, score5: score5);
  }

  bool _matchPoint(String normalizedUserAnswer, _ExpectedPoint point) {
    for (final group in point.groups) {
      final groupOk = group.any((kw) => normalizedUserAnswer.contains(kw));
      if (!groupOk) return false;
    }
    return true;
  }

  String _normalize(String s) {
    var out = s.toLowerCase();
    out = out.replaceAll('\u00A0', ' ');

    const from = 'àáâäçèéêëìíîïñòóôöùúûüýÿœæ';
    const to = 'aaaaceeeeiiiinoooouuuuyyoeae';
    for (int i = 0; i < from.length; i++) {
      out = out.replaceAll(from[i], to[i]);
    }

    out = out.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    out = out.replaceAll(RegExp(r'\s+'), ' ').trim();
    return out;
  }

  // ─────────────────────────────────────────────
  // DONNÉES : réponses parfaites + rubrics
  // ─────────────────────────────────────────────
  List<_PerfectAnswer> _buildPerfectAnswers() {
    const q1Perfect =
        "Les faits décrits par M. BRAVO constituent une dégradation volontaire de bien appartenant à autrui, infraction prévue et réprimée par l’article 322-1 du Code pénal.\n\n"
        "Je l’informe qu’il n’est pas obligatoirement tenu de se déplacer immédiatement au commissariat pour déposer plainte. En effet, s’agissant d’une infraction sans auteur identifié, il peut effectuer une pré-plainte en ligne, ce qui lui permettra de gagner du temps. Cette démarche lui offrira la possibilité de compléter sa plainte ultérieurement sur rendez-vous au commissariat.\n\n"
        "Je lui précise néanmoins que, s’il le souhaite, il peut également se présenter directement à l’accueil du commissariat de Xville afin de déposer plainte, l’accueil du public étant une obligation pour les services de police.\n"
        "Je lui rappelle enfin l’importance du dépôt de plainte, notamment pour les démarches auprès de son assurance.";

    const q2Perfect =
        "Face à la crainte exprimée par M. BRAVO concernant un éventuel cambriolage durant son absence, je lui conseille de s’inscrire à l’opération « tranquillité vacances », proposée gratuitement par les services de police.\n\n"
        "Je lui explique que ce dispositif permet aux forces de l’ordre d’effectuer des passages réguliers à proximité de son domicile pendant son absence, afin de dissuader toute tentative d’effraction et de renforcer la sécurité de son logement.\n\n"
        "Je complète ces conseils par des recommandations de bon sens, telles que :\n"
        "- ne pas laisser d’objets de valeur visibles depuis l’extérieur,\n"
        "- fermer correctement portes et fenêtres,\n"
        "- éviter d’indiquer son absence sur les réseaux sociaux,\n"
        "- demander à une personne de confiance de relever son courrier.\n\n"
        "Ces mesures contribuent à réduire les risques de cambriolage.";

    const q3Perfect =
        "Je conserve une attitude calme, professionnelle et respectueuse, conformément aux règles de déontologie de la police nationale.\n"
        "Je ne réponds pas sur le même ton que M. BRAVO et ne me laisse pas provoquer par ses propos.\n\n"
        "Je l’invite à s’exprimer dans le calme et lui explique, de manière posée, que le commissariat accueille de nombreuses personnes et que les délais d’attente peuvent varier en fonction de l’urgence des situations et des priorités opérationnelles.\n\n"
        "Je lui rappelle que toutes les personnes sont reçues selon l’ordre d’arrivée, sauf urgence particulière, et que son dépôt de plainte sera pris en compte dès que possible.\n"
        "Je veille à désamorcer la situation, à maintenir l’ordre dans la salle d’attente et à préserver la qualité du service public.\n\n"
        "Si son comportement venait à perturber le fonctionnement du service ou l’accueil des autres usagers, je l’inviterais à se rasseoir et, si nécessaire, rendrais compte à ma hiérarchie.";

    final q1Rubric = <_ExpectedPoint>[
      // ─────────────────────────────────────────────
      // Q1 — 1) Qualification juridique (le fond)
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Qualifier l’infraction : dégradation volontaire d’un bien appartenant à autrui (véhicule) / vandalisme",
        groups: [
          // Dégradation / vandalisme / détérioration (mots “parfaits” + variantes)
          [
            'degradation',
            'degrader',
            'degradations',
            'degrade',
            'deterioration',
            'deteriorer',
            'deteriore',
            'deteriorations',
            'vandalisme',
            'vandal',
            'vandaliser',
            'vandalise',
            'abimer',
            'abime',
            'abimé',
            'saccage',
            'saccager',
            'dommage',
            'dommages',
            'casse',
            'casser',
            'briser',
            'bris',
            'vitre brisee',
            'vitre casse',
            'vitre',
            'pneus creves',
            'pneu creve',
            'crevaison',
            'creve',
            'crever',
            'atteinte aux biens',
            'atteinte au bien',
          ],

          // Bien d’autrui (élément “parfait”)
          [
            'autrui',
            'bien d autrui',
            'bien appartenant a autrui',
            'bien appartenant à autrui',
            'propriete d autrui',
            'propriété d autrui',
            'bien de la victime',
            'vehicule de la victime',
            'voiture de la victime',
          ],

          // Volontaire / intentionnel (dégradation volontaire)
          [
            'volontaire',
            'intentionnelle',
            'intentionnel',
            'delibere',
            'délibéré',
            'exprès',
            'express',
            'sciemment',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q1 — 2) Base légale (bonus) : 322-1 CP
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label: "Mentionner la base légale : article 322-1 / Code pénal (CP)",
        groups: [
          [
            '322 1',
            '322-1',
            '3221',
            'article 322 1',
            'art 322 1',
            'art. 322 1',
            'article 322-1',
            'art 322-1',
            'art. 322-1',
            'code penal',
            'code pénal',
            'cp',
            'infraction prevue',
            'infraction prévue',
            'reprimee',
            'réprimée',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q1 — 3) Déplacement non obligatoire + pré-plainte en ligne
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Expliquer que le déplacement immédiat n’est pas obligatoire + proposer la pré-plainte en ligne (gain de temps)",
        groups: [
          // Pas obligé de venir tout de suite (mots parfaits + variantes)
          [
            'pas obligatoir',
            'non obligatoir',
            'pas oblige',
            'non oblige',
            'pas tenu',
            'non tenu',
            'pas necessaire',
            'pas nécessaire',
            'pas besoin',
            'pas indispensable',
            'deplacement non obligatoire',
            'venir immediatement pas obligatoire',
            'se deplacer immediatement',
            'se déplacer immédiatement',
            'pas besoin de venir tout de suite',
          ],

          // Pré-plainte / en ligne / internet (mots parfaits + variantes)
          [
            'pre plainte',
            'pré plainte',
            'preplainte',
            'préplainte',
            'en ligne',
            'internet',
            'site',
            'plateforme',
            'plainte en ligne',
            'depot en ligne',
            'dépôt en ligne',
          ],

          // Gain de temps / démarche / sans auteur identifié (mots du texte parfait)
          [
            'gagner du temps',
            'gain de temps',
            'démarche',
            'demarche',
            'sans auteur',
            'auteur non identifie',
            'auteur non identifié',
            'infraction sans auteur',
            'sans auteur identifie',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q1 — 4) Compléter au commissariat sur RDV + accueil du public (obligation)
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Préciser qu’on peut compléter / finaliser au commissariat sur rendez-vous + rappeler l’obligation d’accueil du public",
        groups: [
          // RDV / compléter / ultérieurement / au commissariat (texte parfait + variantes)
          [
            'rendez vous',
            'rdv',
            'sur rendez vous',
            'sur rdv',
            'completer',
            'compléter',
            'finaliser',
            'signer',
            'confirmer',
            'ulterieurement',
            'ultérieurement',
            'plus tard',
            'au commissariat',
            'au poste',
            'au service',
          ],

          // Accueil du public = obligation (texte parfait + variantes)
          [
            'accueil',
            'accueillir',
            'public',
            'usagers',
            'obligation',
            'obligation d accueil',
            'obligation d’accueil',
            'obligation pour les services',
            'service public',
            'prendre plainte',
            'prise de plainte',
            'enregistrer la plainte',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q1 — 5) Assurance
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Rappeler l’importance du dépôt de plainte pour les démarches assurance",
        groups: [
          [
            'assurance',
            'assureur',
            'indemnisation',
            'remboursement',
            'prise en charge',
            'sinistre',
            'dossier',
            'garantie',
            'demarches',
            'démarches',
            'declaration',
            'déclaration',
          ],
        ],
      ),
    ];

    final q2Rubric = <_ExpectedPoint>[
      // ─────────────────────────────────────────────
      // Q2 — 1) Dispositif Tranquillité Vacances
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Conseiller l’opération / dispositif « Tranquillité Vacances » (gratuit, police/gendarmerie)",
        groups: [
          [
            'tranquillite vacances',
            'tranquilite vacances',
            'tranquillité vacances',
            'operation tranquillite',
            'opération tranquillité',
            'otv',
            'operation tranquillite vacances',
            'opération tranquillité vacances',
            'surveillance vacances',
            'patrouilles vacances',
            'dispositif tranquillite',
            'dispositif tranquillité',
          ],
          [
            'police',
            'services de police',
            'forces de l ordre',
            'forces de l’ordre',
            'gendarmerie',
            'forces de securite',
            'forces de sécurité',
          ],
          [
            'gratuit',
            'gratuite',
            'sans frais',
            'a titre gratuit',
            'à titre gratuit',
            'propose gratuitement',
            'proposé gratuitement',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q2 — 2) Principe : passages réguliers pendant l’absence + dissuasion effraction
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Expliquer le principe : passages réguliers / surveillance à proximité du domicile pendant l’absence",
        groups: [
          [
            'passages reguliers',
            'passage regulier',
            'passages',
            'passage',
            'patrouilles',
            'patrouille',
            'rondes',
            'ronde',
            'surveillance',
            'surveiller',
            'controle',
            'contrôle',
            'visites',
            'passage de police',
            'passage des forces de l ordre',
          ],
          [
            'pendant l absence',
            'durant l absence',
            'en mon absence',
            'son absence',
            'pendant les vacances',
            'durant les vacances',
            'quand il est absent',
            'lors de son absence',
          ],
          [
            'a proximite',
            'à proximité',
            'proximite',
            'proche',
            'aux abords',
            'domicile',
            'maison',
            'logement',
            'habitation',
            'residence',
            'résidence',
          ],
        ],
      ),

      _ExpectedPoint(
        label:
            "But : dissuader / prévenir l’effraction et renforcer la sécurité (réduire le risque de cambriolage)",
        groups: [
          [
            'dissuader',
            'dissuasion',
            'dissuade',
            'dissuasion des auteurs',
            'prevenir',
            'prévenir',
            'prevention',
            'prévention',
            'eviter',
            'éviter',
            'limiter',
            'reduire',
            'réduire',
          ],
          [
            'effraction',
            'tentative d effraction',
            'tentative d’effraction',
            'intrusion',
            'forcage',
            'forçage',
            'cambriolage',
            'cambrioleur',
            'vol',
            'vol par effraction',
            'vol avec effraction',
          ],
          [
            'securite',
            'sécurité',
            'renforcer la securite',
            'renforcer la sécurité',
            'proteger',
            'protéger',
            'protection',
            'sécuriser',
            'securiser',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q2 — 3) Conseils de bon sens / prévention (4 axes)
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label: "Conseil : fermer/verrouiller correctement portes et fenêtres",
        groups: [
          [
            'fermer',
            'fermez',
            'bien fermer',
            'fermer correctement',
            'verrouiller',
            'verrouille',
            'verrouillage',
            'securiser',
            'sécuriser',
            'fermeture',
          ],
          [
            'porte',
            'portes',
            'fenetre',
            'fenetres',
            'fenêtre',
            'fenêtres',
            'volets',
            'portail',
            'garage',
          ],
        ],
      ),

      _ExpectedPoint(
        label:
            "Conseil : ne pas laisser d’objets de valeur visibles depuis l’extérieur",
        groups: [
          [
            'ne pas laisser',
            'ne laissez pas',
            'eviter de laisser',
            'éviter de laisser',
            'ne rien laisser',
            'ne pas exposer',
            'cacher',
            'mettre a l abri',
            'ranger',
            'hors de vue',
            'pas visible',
          ],
          [
            'objets de valeur',
            'valeurs',
            'bijoux',
            'argent',
            'materiel',
            'matériel',
            'ordinateur',
            'pc',
            'telephone',
            'téléphone',
            'sac',
            'portefeuille',
          ],
          [
            'visible de l exterieur',
            'visible depuis l exterieur',
            'depuis l exterieur',
            'de l exterieur',
            'vue de l exterieur',
            'depuis la rue',
            'par la fenetre',
            'par la fenêtre',
          ],
        ],
      ),

      _ExpectedPoint(
        label: "Conseil : ne pas annoncer son absence sur les réseaux sociaux",
        groups: [
          [
            'reseaux sociaux',
            'réseaux sociaux',
            'facebook',
            'instagram',
            'snapchat',
            'tiktok',
            'twitter',
            'x',
            'stories',
            'publication',
            'publier',
            'post',
            'poster',
          ],
          [
            'absence',
            'vacances',
            'depart',
            'départ',
            'partir',
            'en voyage',
            'annoncer',
            'indiquer',
            'mentionner',
            'signaler',
            'ne pas dire',
            'ne pas annoncer',
            'eviter d indiquer',
            'éviter d’indiquer',
          ],
        ],
      ),

      _ExpectedPoint(
        label:
            "Conseil : faire relever le courrier par une personne de confiance",
        groups: [
          [
            'relever le courrier',
            'releve du courrier',
            'relève du courrier',
            'ramasser le courrier',
            'vider la boite aux lettres',
            'boite aux lettres',
            'boîte aux lettres',
            'courrier',
          ],
          [
            'personne de confiance',
            'voisin',
            'voisine',
            'famille',
            'proche',
            'ami',
            'amie',
            'quelqu un',
            'quelqu’un',
            'demander',
            'faire demander',
            'confier',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q2 — 4) Conclusion (bonus) : réduire les risques
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Conclure : ces mesures réduisent/limitent le risque de cambriolage",
        groups: [
          [
            'reduire les risques',
            'réduire les risques',
            'limiter les risques',
            'diminuer les risques',
            'eviter le cambriolage',
            'éviter le cambriolage',
            'prevenir le cambriolage',
            'prévenir le cambriolage',
            'baisser le risque',
            'réduire le risque',
          ],
          ['cambriolage', 'effraction', 'intrusion', 'vol'],
        ],
      ),
    ];

    final q3Rubric = <_ExpectedPoint>[
      // ─────────────────────────────────────────────
      // Q3 — 1) Attitude pro + déontologie + ne pas répondre au même ton
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Rester calme / professionnel / respectueux (déontologie police) et ne pas répondre sur le même ton (ne pas se laisser provoquer)",
        groups: [
          [
            'calme',
            'calmement',
            'poser',
            'posée',
            'de maniere posee',
            'de manière posée',
            'professionnel',
            'professionnelle',
            'respectueux',
            'respectueuse',
            'courtois',
            'courtoisie',
            'politesse',
            'deontologie',
            'déontologie',
            'regles de deontologie',
            'règles de déontologie',
            'police nationale',
            'service public',
            'attitude',
            'posture',
            'maitrise',
            'maîtrise',
          ],
          [
            'ne pas repondre',
            'ne reponds pas',
            'ne pas répondre',
            'pas le meme ton',
            'pas le même ton',
            'sur le meme ton',
            'sur le même ton',
            'ne pas entrer dans le conflit',
            'ne pas envenimer',
            'provocation',
            'provoquer',
            'ne me laisse pas provoquer',
            'ne pas se laisser provoquer',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q3 — 2) Expliquer attente/délais + urgences/priorités + nombreux usagers
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Expliquer les délais d’attente (accueil de nombreuses personnes) + priorités/urgences opérationnelles",
        groups: [
          [
            'delai',
            'délais',
            'attente',
            'temps d attente',
            'temps d’attente',
            'patiente',
            'patientez',
            'patienter',
            'file',
            'queue',
            'varier',
            'peuvent varier',
            'variable',
            'beaucoup de monde',
            'de nombreuses personnes',
            'nombreuses personnes',
            'plusieurs usagers',
            'autres usagers',
            'accueille',
            'commissariat',
            'accueil',
          ],
          [
            'urgence',
            'urgences',
            'urgence particuliere',
            'urgence particulière',
            'priorites',
            'priorités',
            'priorite',
            'priorité',
            'priorites operationnelles',
            'priorités opérationnelles',
            'missions',
            'interventions',
            'situations urgentes',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q3 — 3) Ordre d’arrivée + sauf urgence + prise en compte + désamorcer / maintenir l’ordre
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Rappeler l’ordre d’arrivée (sauf urgence) + dépôt de plainte pris en compte + désamorcer / maintenir l’ordre / préserver l’accueil",
        groups: [
          [
            'ordre d arrivee',
            'ordre d’arrivée',
            'selon l ordre',
            'selon l’ordre',
            'dans l ordre',
            'dans l’ordre',
            'ordre',
            'arrivee',
            'arrivée',
            'toutes les personnes',
            'tous les usagers',
            'reçues',
            'recues',
            'sauf urgence',
            'sauf urgence particuliere',
            'sauf urgence particulière',
          ],
          [
            'depot de plainte',
            'dépôt de plainte',
            'plainte',
            'pris en compte',
            'prise en compte',
            'sera pris en compte',
            'des que possible',
            'dès que possible',
            'au plus vite',
          ],
          [
            'desamorcer',
            'désamorcer',
            'apaiser',
            'calmer',
            'desescalader',
            'désescalader',
            'maintenir l ordre',
            'maintenir l’ordre',
            'maintien de l ordre',
            'maintien de l’ordre',
            'preserver',
            'préserver',
            'qualite du service public',
            'qualité du service public',
            'salle d attente',
            'salle d’attente',
            'accueil',
            'ordre dans la salle',
          ],
        ],
      ),

      // ─────────────────────────────────────────────
      // Q3 — 4) Si perturbation : se rasseoir + rendre compte hiérarchie (si nécessaire)
      // ─────────────────────────────────────────────
      _ExpectedPoint(
        label:
            "Si perturbation : l’inviter à se rasseoir / cesser + rendre compte à la hiérarchie (si nécessaire)",
        groups: [
          [
            'perturber',
            'perturbation',
            'perturbations',
            'trouble',
            'trouble a l ordre',
            'trouble à l’ordre',
            'fonctionnement du service',
            'fonctionnement',
            'perturbe le service',
            'perturber l accueil',
            'perturber l’accueil',
            'comportement',
            'agressif',
            'agressivite',
            'agressivité',
          ],
          [
            'se rasseoir',
            'rasseoir',
            's assoir',
            's’asseoir',
            'asseoir',
            'l inviter a se rasseoir',
            'l’inviter à se rasseoir',
            'inviter',
            'demander de se calmer',
            'cesser',
          ],
          [
            'hierarchie',
            'hiérarchie',
            'rendre compte',
            'rendrai compte',
            'chef',
            'superieur',
            'supérieur',
            'responsable',
            'faire appel',
            'appeler',
            'renfort',
            'collegue',
            'collègue',
          ],
        ],
      ),
    ];

    return [
      _PerfectAnswer(answer: q1Perfect, rubric: q1Rubric),
      _PerfectAnswer(answer: q2Perfect, rubric: q2Rubric),
      _PerfectAnswer(answer: q3Perfect, rubric: q3Rubric),
    ];
  }

  // ---------------- NAV ----------------
  void _next() {
    HapticFeedback.selectionClick();

    // 🔒 verrouillage uniquement quand on quitte Q1 (index 2)
    if (_index == 2) {
      _minBackIndex = 3; // Q2
    }

    _pc.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _prev() {
    HapticFeedback.selectionClick();

    if (_index == 0) {
      _safePopRoute();
      return;
    }

    final target = _index - 1;
    if (target < _minBackIndex) {
      AppNotifier.warning(
        context,
        title: "Retour verrouillé",
        message: "Tu ne peux plus revenir en arrière après validation.",
      );
      return;
    }

    _pc.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  // ---------------- CASE TEXT SHEET (no glass) ----------------
  void _showCaseText(BuildContext context) {
    HapticFeedback.selectionClick();

    final appCtrl = AppSettingsController.I;
    final theme = Theme.of(context);
    final platformDark = theme.brightness == Brightness.dark;

    final mode = appCtrl.themeMode.value;
    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformDark,
    };

    final sheetBg = isDark ? const Color(0xFF0B102A) : Colors.white;
    final sheetTitle = isDark ? Colors.white.withOpacity(0.92) : Colors.black87;
    final sheetText = isDark
        ? Colors.white.withOpacity(0.78)
        : Colors.black.withOpacity(0.75);

    final handle = isDark
        ? Colors.white.withOpacity(0.18)
        : Colors.black.withOpacity(0.15);

    final closeFg = isDark ? Colors.white.withOpacity(0.86) : Colors.black87;

    const btnBg = Colors.white;
    const btnFg = Color(0xFF000B36);

    _sheetCloseBusy = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        final h = MediaQuery.of(sheetCtx).size.height;

        void safeCloseSheet() {
          if (_sheetCloseBusy) return;
          _sheetCloseBusy = true;
          Navigator.of(sheetCtx).pop();
        }

        return SafeArea(
          child: Container(
            height: h * 0.78,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.10)
                    : Colors.black.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                  color: Colors.black.withOpacity(isDark ? 0.40 : 0.22),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: handle,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const SizedBox(width: 32),
                      Expanded(
                        child: Text(
                          "Texte du cas",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.5,
                            color: sheetTitle,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: safeCloseSheet,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.close_rounded, color: closeFg),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        _caseText,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          color: sheetText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.2,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: safeCloseSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnBg,
                        foregroundColor: btnFg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Fermer",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w900,
                          fontSize: 15.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion(context);
    final appCtrl = AppSettingsController.I;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appCtrl.themeMode,
      builder: (_, mode, __) {
        final theme = Theme.of(context);

        final platformDark = theme.brightness == Brightness.dark;
        final bool isDark = switch (mode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => platformDark,
        };

        final bgTop = isDark
            ? const Color(0xFF000B36)
            : const Color(0xFF1147D9);
        final bgMid = isDark
            ? const Color(0xFF000A33)
            : const Color(0xFF1A55E6);
        final bgBot = isDark
            ? const Color(0xFF00082D)
            : const Color(0xFF0E2F9E);

        final haloA = Colors.white.withOpacity(isDark ? 0.10 : 0.07);
        final haloB = Colors.white.withOpacity(isDark ? 0.04 : 0.03);

        final overlayTop = Colors.black.withOpacity(isDark ? 0.32 : 0.22);
        final overlayBot = Colors.black.withOpacity(isDark ? 0.42 : 0.32);

        final blobA = Colors.white.withOpacity(isDark ? 0.10 : 0.08);
        final blobB = Colors.white.withOpacity(isDark ? 0.06 : 0.05);

        const ctaFg = Color(0xFF000B36);

        return PopScope(
          canPop: false,
          onPopInvoked: (_) {
            if (_backEnabled) {
              _prev();
            } else {
              AppNotifier.warning(
                context,
                title: "Retour verrouillé",
                message: "Tu ne peux plus revenir en arrière après validation.",
              );
            }
          },
          child: Scaffold(
            backgroundColor: bgTop,
            body: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [bgTop, bgMid, bgBot],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -0.18),
                          radius: 1.18,
                          colors: [haloA, haloB, Colors.transparent],
                          stops: const [0.0, 0.62, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: _DynamicBlobsBackground(
                    enabled: !reduceMotion,
                    blobColorA: blobA,
                    blobColorB: blobB,
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [overlayTop, Colors.transparent, overlayBot],
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                        child: Row(
                          children: [
                            _BackPill(onTap: _prev, enabled: _backEnabled),
                            const SizedBox(width: 12),
                            const Expanded(child: SizedBox()),
                            const Spacer(),
                            const SizedBox(width: 10),
                            Text(
                              "Cas 1",
                              style: GoogleFonts.montserrat(
                                color: Colors.white.withOpacity(0.92),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pc,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (i) {
                            setState(() => _index = i);

                            if (i == _correctionPageIndex && !_corrLoadedOnce) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) _loadCorrection();
                              });
                            }
                          },
                          children: [
                            const _IntroSlide(
                              title: "Cas pratique n°1",
                              subtitle:
                                  "Lis attentivement, puis réponds comme en service.",
                            ),
                            const _CaseTextSlide(
                              title: "Situation",
                              text: _caseText,
                            ),
                            _QuestionSlide(
                              title: "Question 1",
                              question:
                                  "Après avoir identifié l’infraction dont M. BRAVO est victime, que lui conseillez-vous pour son dépôt de plainte ? Justifiez.",
                              controller: _answerCtrls[0],
                              onOpenCaseText: () => _showCaseText(context),
                            ),
                            _QuestionSlide(
                              title: "Question 2",
                              question:
                                  "Avant de raccrocher, M. BRAVO craint un cambriolage pendant son absence.\n\nQuel(s) conseil(s) pouvez-vous lui donner ?",
                              controller: _answerCtrls[1],
                              onOpenCaseText: () => _showCaseText(context),
                            ),
                            _QuestionSlide(
                              title: "Question 3",
                              question:
                                  "À l’accueil, M. BRAVO s’énerve et exige d’être reçu immédiatement.\n\nQue faites-vous ? Justifiez.",
                              controller: _answerCtrls[2],
                              onOpenCaseText: () => _showCaseText(context),
                            ),
                            _CorrectionSlide(
                              isDark: isDark,
                              onOpenCaseText: () => _showCaseText(context),
                              loading: _corrLoading,
                              error: _corrError,
                              total15: _total15,
                              items: _corrItems,
                              onRefresh: _loadCorrection,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isQuestionPage) ...[
                              _PrimaryButton(
                                label: _saving
                                    ? "Enregistrement..."
                                    : "Valider",
                                enabled: _canValidateQ(_currentQuestionIndex),
                                onPressed: () => _validateAndSaveQuestion(
                                  _currentQuestionIndex,
                                ),
                                foreground: ctaFg,
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (_isCorrectionPage) ...[
                              _PrimaryButton(
                                label: "Retour à la liste des cas",
                                enabled: true,
                                onPressed: _goToList,
                                foreground: ctaFg,
                              ),
                            ] else ...[
                              _LockedNextButton(
                                label: "Suivant",
                                enabled: _canGoNext,
                                foreground: ctaFg,
                                onPressed: _next,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

const String _caseText =
    "Vous êtes affecté(e), en qualité de gardien(ne) de la paix, au sein du commissariat de Xville, en unité de police secours.\n\n"
    "Ce jour, vous ne patrouillez pas, mais vous êtes employé(e) à renforcer l’accueil du commissariat.\n"
    "Vous commencez votre journée en assurant le standard téléphonique du commissariat.\n\n"
    "À 13h00, vous recevez un appel de M. BRAVO, 34 ans, demeurant à Xville, qui vous déclare que ce matin, alors qu’il voulait récupérer son véhicule personnel stationné devant chez lui pour se rendre au travail, il a constaté que la vitre arrière droite avait été brisée et que les quatre pneus avaient été crevés.\n\n"
    "Rien ne lui a été volé à l’intérieur de son véhicule, et il n’a aucune information concernant les circonstances ni sur l’auteur des faits.\n\n"
    "Il souhaite déposer plainte mais manque de temps et vous demande si un déplacement au commissariat est obligatoire.";

/* ───────────────────────────────────────────── */
/* CORRECTION VIEWS                              */
/* ───────────────────────────────────────────── */

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.onText});
  final Color onText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const SizedBox(
              height: 44,
              width: 44,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 16),
            Text(
              "Chargement…",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: onText,
                fontWeight: FontWeight.w800,
                fontSize: 14.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
    required this.onText,
    required this.onTitle,
  });

  final String error;
  final VoidCallback onRetry;
  final Color onText;
  final Color onTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Erreur",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: onTitle,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: onText,
                fontWeight: FontWeight.w700,
                fontSize: 14.2,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            _GhostButton(label: "Recharger", onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _CorrectionView extends StatelessWidget {
  const _CorrectionView({
    required this.total15,
    required this.items,
    required this.onRefresh,
    required this.isDark,
  });

  final int total15;
  final List<_CorrectionItem> items;
  final Future<void> Function() onRefresh;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color headerTitle = Colors.white.withOpacity(0.98);
    final Color headerSub = Colors.white.withOpacity(0.78);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          children: [
            _SurfaceCard(
              isDark: isDark,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  children: [
                    Text(
                      "Cas pratique n°1",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: headerTitle,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Score estimé : $total15 / 15",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: headerTitle,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Comparaison automatique basée sur les points attendus.\n(Tire vers le bas pour recharger)",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: headerSub,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.4,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            ...items.map((it) => _QuestionCard(item: it, isDark: isDark)),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatefulWidget {
  const _QuestionCard({required this.item, required this.isDark});
  final _CorrectionItem item;
  final bool isDark;

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _showPerfect = false;

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final isDark = widget.isDark;

    final Color title = Colors.white.withOpacity(0.98);
    final Color body = Colors.white.withOpacity(0.78);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _SurfaceCard(
        isDark: isDark,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                it.questionTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: title,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Score : ${it.score5} / 5",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: body,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.6,
                ),
              ),
              if (it.warning != null) ...[
                const SizedBox(height: 10),
                Text(
                  it.warning!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFE03131),
                    fontWeight: FontWeight.w800,
                    fontSize: 13.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              _SubTitle(text: "Ta réponse", isDark: isDark),
              const SizedBox(height: 8),
              _GreyBox(
                text: it.userAnswer.isEmpty
                    ? "Aucune réponse enregistrée."
                    : it.userAnswer,
                isDark: isDark,
              ),
              if (it.covered.isNotEmpty) ...[
                const SizedBox(height: 14),
                _SubTitle(text: "✅ Points couverts", isDark: isDark),
                const SizedBox(height: 8),
                ...it.covered.map(
                  (t) => _BulletRow(
                    icon: Icons.check_circle_rounded,
                    iconColor: const Color(0xFF2F9E44),
                    text: t,
                    isDark: isDark,
                  ),
                ),
              ],
              if (it.missing.isNotEmpty) ...[
                const SizedBox(height: 12),
                _SubTitle(text: "❌ Points à ajouter", isDark: isDark),
                const SizedBox(height: 8),
                ...it.missing.map(
                  (t) => _BulletRow(
                    icon: Icons.close_rounded,
                    iconColor: const Color(0xFFE03131),
                    text: t,
                    isDark: isDark,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              InkWell(
                onTap: () => setState(() => _showPerfect = !_showPerfect),
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Text(
                    _showPerfect
                        ? "Masquer la réponse parfaite"
                        : "Voir la réponse parfaite",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13.6,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withOpacity(0.65),
                    ),
                  ),
                ),
              ),
              if (_showPerfect) ...[
                const SizedBox(height: 6),
                _SubTitle(text: "Réponse parfaite", isDark: isDark),
                const SizedBox(height: 8),
                _GreyBox(text: it.perfectAnswer, isDark: isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────────────────────────── */
/* BACKGROUND BLOBS                             */
/* ───────────────────────────────────────────── */

class _DynamicBlobsBackground extends StatefulWidget {
  const _DynamicBlobsBackground({
    required this.enabled,
    required this.blobColorA,
    required this.blobColorB,
  });

  final bool enabled;
  final Color blobColorA;
  final Color blobColorB;

  @override
  State<_DynamicBlobsBackground> createState() =>
      _DynamicBlobsBackgroundState();
}

class _DynamicBlobsBackgroundState extends State<_DynamicBlobsBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _DynamicBlobsBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _c.repeat(reverse: true);
      } else {
        _c.stop();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return const SizedBox.expand();

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        return Stack(
          children: [
            Align(
              alignment: Alignment(-0.2 + t * 0.3, -0.1 + t * 0.2),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.blobColorA,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.2 - t * 0.3, 0.3 - t * 0.2),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 54, sigmaY: 54),
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.blobColorB,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/* ───────────────────────────────────────────── */
/* CARDS + BUTTONS                               */
/* ───────────────────────────────────────────── */

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, required this.isDark});
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color bg = Colors.white.withOpacity(isDark ? 0.10 : 0.10);
    final Color stroke = Colors.white.withOpacity(0.14);
    final double shadowOpacity = isDark ? 0.24 : 0.18;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(shadowOpacity),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GreyBox extends StatelessWidget {
  const _GreyBox({required this.text, required this.isDark});
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color bg = Colors.white.withOpacity(0.08);
    final Color border = Colors.white.withOpacity(0.12);
    final Color fg = Colors.white.withOpacity(0.78);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: GoogleFonts.montserrat(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 13.8,
          height: 1.45,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
    required this.foreground,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

class _LockedNextButton extends StatelessWidget {
  const _LockedNextButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
    required this.foreground,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final disabledBg = const Color(0xFFD9DDE7);
    final disabledFg = const Color(0xFF6B7280);

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? Colors.white : disabledBg,
          foregroundColor: enabled ? foreground : disabledFg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!enabled) ...[
              Icon(Icons.lock_rounded, size: 18, color: disabledFg),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: Colors.white,
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({required this.text, required this.isDark});
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withOpacity(0.92);

    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        color: fg,
        fontWeight: FontWeight.w900,
        fontSize: 13.8,
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.isDark,
  });

  final IconData icon;
  final Color iconColor;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color fg = Colors.white.withOpacity(0.78);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 13.6,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  const _BackPill({required this.onTap, required this.enabled});
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chevron_left_rounded,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                "Retour",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerfectAnswer {
  final String answer;
  final List<_ExpectedPoint> rubric;

  _PerfectAnswer({required this.answer, required this.rubric});
}

class _ExpectedPoint {
  final String label;
  final List<List<String>> groups;

  _ExpectedPoint({required this.label, required this.groups});
}

class _EvalResult {
  final List<String> covered;
  final List<String> missing;
  final int score5;

  _EvalResult({
    required this.covered,
    required this.missing,
    required this.score5,
  });
}

class _CorrectionItem {
  final int questionIndex;
  final String questionTitle;
  final String userAnswer;
  final String perfectAnswer;
  final List<String> covered;
  final List<String> missing;
  final int score5;
  final String? warning;

  _CorrectionItem({
    required this.questionIndex,
    required this.questionTitle,
    required this.userAnswer,
    required this.perfectAnswer,
    required this.covered,
    required this.missing,
    required this.score5,
    this.warning,
  });
}

class _IntroSlide extends StatelessWidget {
  const _IntroSlide({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    Color whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1.05,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14.6,
                height: 1.5,
                fontWeight: FontWeight.w700,
                color: whiteA(0.88),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 18,
                  color: Colors.white.withOpacity(0.90),
                ),
                const SizedBox(width: 10),
                Text(
                  "Sécurité • Légalité • Clarté",
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.88),
                    fontWeight: FontWeight.w900,
                    fontSize: 13.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseTextSlide extends StatelessWidget {
  const _CaseTextSlide({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.05,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Lis attentivement. Tu vas ensuite répondre comme si tu étais déjà en service.",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14.3,
                height: 1.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.88),
              ),
            ),
            const SizedBox(height: 18),
            _WhiteCard(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.46,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      text,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.2,
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionSlide extends StatelessWidget {
  const _QuestionSlide({
    required this.title,
    required this.question,
    required this.controller,
    required this.onOpenCaseText,
  });

  final String title;
  final String question;
  final TextEditingController controller;
  final VoidCallback onOpenCaseText;

  @override
  Widget build(BuildContext context) {
    Color whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.05,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onOpenCaseText,
              icon: Icon(
                Icons.article_outlined,
                size: 18,
                color: Colors.white.withOpacity(0.92),
              ),
              label: Text(
                "Relire le cas",
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(0.92),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: whiteA(0.90),
                fontWeight: FontWeight.w700,
                fontSize: 14.6,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            _WhiteCard(
              child: TextField(
                controller: controller,
                maxLines: 8,
                textInputAction: TextInputAction.newline,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.2,
                  height: 1.45,
                ),
                decoration: InputDecoration(
                  hintText:
                      "Rédige ta réponse ici…\n\n(Structure : Situation → Priorités → Actions → Suites)",
                  hintStyle: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectionSlide extends StatelessWidget {
  const _CorrectionSlide({
    required this.isDark,
    required this.onOpenCaseText,
    required this.loading,
    required this.error,
    required this.total15,
    required this.items,
    required this.onRefresh,
  });

  final bool isDark;
  final VoidCallback onOpenCaseText;
  final bool loading;
  final String? error;
  final int total15;
  final List<_CorrectionItem> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    Color whiteA(double o) => Color.fromRGBO(255, 255, 255, o);

    return Column(
      children: [
        const SizedBox(height: 6),
        Text(
          "Correction",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: onOpenCaseText,
          icon: Icon(
            Icons.article_outlined,
            size: 18,
            color: Colors.white.withOpacity(0.92),
          ),
          label: Text(
            "Relire le cas",
            style: GoogleFonts.montserrat(
              color: Colors.white.withOpacity(0.92),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: loading
              ? _LoadingState(onText: whiteA(0.88))
              : (error != null)
              ? _ErrorState(
                  error: error!,
                  onRetry: onRefresh,
                  onText: whiteA(0.88),
                  onTitle: Colors.white,
                )
              : _CorrectionView(
                  total15: total15,
                  items: items,
                  onRefresh: onRefresh,
                  isDark: isDark,
                ),
        ),
      ],
    );
  }
}
