// lib/pages/gpx/plainte_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlaintePage extends StatefulWidget {
  static const routeName = '/plainte';
  const PlaintePage({super.key});

  @override
  State<PlaintePage> createState() => _PlaintePageState();
}

class _PlaintePageState extends State<PlaintePage> {
  final _search = TextEditingController();
  String _q = '';
  final Map<String, bool> _open = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final blocs = _blocsPlainte();
    final filtered = blocs.where((b) {
      if (_q.isEmpty) return true;
      final q = _q.toLowerCase();
      if (b.title.toLowerCase().contains(q)) return true;
      if (b.subtitle?.toLowerCase().contains(q) == true) return true;
      for (final it in b.items) {
        if (it.title.toLowerCase().contains(q)) return true;
        if (it.body.toLowerCase().contains(q)) return true;
        if (it.tags.any((t) => t.toLowerCase().contains(q))) return true;
      }
      return false;
    }).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // HERO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primary.withOpacity(.10), cs.surface],
                  ),
                  border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 14, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _IconBadge(icon: Icons.how_to_vote_rounded),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Plainte',
                              style: tt.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Recueil, mentions obligatoires, droits, trames PV',
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const Spacer(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const [
                                _TinyTag(
                                  icon: Icons.article_rounded,
                                  label: 'PV',
                                ),
                                _TinyTag(
                                  icon: Icons.info_rounded,
                                  label: 'Droits victime',
                                ),
                                _TinyTag(
                                  icon: Icons.checklist_rounded,
                                  label: 'Checklists',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // RECHERCHE
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _q = v.trim()),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText:
                      'Rechercher (ex: mentions, droits, violences, ITT, témoin…)',
                  isDense: true,
                  filled: true,
                  fillColor: cs.surfaceContainerHighest.withOpacity(.55),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withOpacity(.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withOpacity(.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: cs.primary.withOpacity(.6)),
                  ),
                ),
              ),
            ),
          ),

          // CONTENU
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Aucun résultat',
                  style: tt.titleMedium?.copyWith(color: cs.outline),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final b = filtered[i];
                  final isOpen = _open[b.id] ?? false;
                  return _BlocTile(
                    bloc: b,
                    open: isOpen,
                    onToggle: (v) => setState(() => _open[b.id] = v),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/* ------------------------------- UI widgets ------------------------------- */

class _BlocTile extends StatelessWidget {
  final _Bloc bloc;
  final bool open;
  final ValueChanged<bool> onToggle;
  const _BlocTile({
    required this.bloc,
    required this.open,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: open,
            onExpansionChanged: onToggle,
            tilePadding: const EdgeInsets.fromLTRB(14, 6, 12, 6),
            childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
            leading: _IconBadge(icon: bloc.icon),
            title: Text(
              bloc.title,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            subtitle: bloc.subtitle == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      bloc.subtitle!,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ),
            trailing: const Icon(Icons.keyboard_arrow_down_rounded),
            children: [
              const SizedBox(height: 8),
              ...bloc.items.map(
                (it) => Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                  child: _ItemCard(item: it),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final _Item item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final isTrame = item.trameText != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withOpacity(.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withOpacity(.25)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags
                      .map((t) => _TinyTag(icon: Icons.sell_rounded, label: t))
                      .toList(),
                ),
              ],
              const SizedBox(height: 8),
              if (isTrame)
                _CopyBox(text: item.trameText!)
              else
                Text(item.body, style: tt.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _CopyBox extends StatelessWidget {
  final String text;
  const _CopyBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: cs.surfaceContainerHighest.withOpacity(.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_rounded, size: 18),
                const SizedBox(width: 8),
                Text('Trame à copier', style: tt.labelLarge),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Trame copiée dans le presse-papiers'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_all_rounded),
                  label: const Text('Copier'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(text, style: tt.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withOpacity(.25)),
      ),
      child: Icon(icon, color: cs.primary),
    );
  }
}

class _TinyTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TinyTag({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withOpacity(.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withOpacity(.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSecondaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: tt.labelSmall?.copyWith(color: cs.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}

/* ------------------------------- Data model ------------------------------- */

class _Bloc {
  final String id;
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<_Item> items;
  const _Bloc({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.items,
  });
}

class _Item {
  final String title;
  final String body;
  final List<String> tags;
  final String? trameText;
  const _Item({
    required this.title,
    this.body = '',
    this.tags = const [],
    this.trameText,
  });
}

/* ------------------------------ Content (FR) ------------------------------ */

List<_Bloc> _blocsPlainte() {
  return [
    _Bloc(
      id: 'accueil',
      title: 'Accueil & sécurité',
      subtitle: 'Posture, confidentialité, besoins immédiats',
      icon: Icons.volunteer_activism_rounded,
      items: [
        _Item(
          title: 'Principes',
          tags: ['écoute', 'neutralité', 'confidentialité'],
          body:
              '• Se présenter (nom, qualité), vérifier l’intimité du lieu.\n'
              '• Évaluer la sécurité immédiate (besoin de soins, mise à l’abri, mise en relation 17/SAMU).\n'
              '• Adapter le rythme, vérifier la langue (interprète si besoin), éviter les questions suggestives.\n'
              '• Informer sur le déroulé : recueil des faits, mentions au PV, orientation et suites.',
        ),
      ],
    ),
    _Bloc(
      id: 'mentions',
      title: 'Mentions obligatoires du PV de plainte',
      subtitle: 'Structure type et éléments à ne pas oublier',
      icon: Icons.fact_check_rounded,
      items: [
        _Item(
          title: 'Mentions clés',
          tags: ['CPP', 'PV', 'horodatage'],
          body:
              '• Lieu, date, heures de début/fin du PV.\n'
              '• Identité et qualité du rédacteur (OPJ/APJ), matricule, service.\n'
              '• Identité complète du plaignant (état civil, adresses, contacts), régime matrimonial si utile.\n'
              '• Information sur droits (information victime, associations, indemnisation, orientation).\n'
              '• Déroulé fidèle des déclarations (guillemets si propos rapportés).\n'
              '• Références des pièces jointes (certificat médical, justificatifs, captures).\n'
              '• Signature plaignant et agent (mention de refus/empêchement si non-signature).',
        ),
      ],
    ),
    _Bloc(
      id: 'recueil',
      title: 'Recueil des faits — Checklist',
      subtitle: 'Ce qu’il faut documenter systématiquement',
      icon: Icons.checklist_rounded,
      items: [
        _Item(
          title: 'Checklist essentielle',
          tags: ['faits', 'témoins', 'préjudice'],
          body:
              '• Quand ? (date, heure de début/fin, fréquence si faits répétés)\n'
              '• Où ? (adresse, local, véhicule, en ligne : plateforme/lien)\n'
              '• Comment ? (modus operandi, menaces, armes, contraintes, numérique)\n'
              '• Qui ? (auteur(s) supposé(s)/inconnu(s), description, liens avec victime)\n'
              '• Témoins (identité/contact)\n'
              '• Préjudice (corporel : douleurs, ITT si connue ; matériel : objets/valeur ; moral)\n'
              '• Éléments conservatoires (captures écran, mails, vidéos, factures, IBAN)\n'
              '• Suites immédiates (soins, changement serrures, blocage CB, dépôt opposition).',
        ),
      ],
    ),
    _Bloc(
      id: 'qualification',
      title: 'Qualification pénale — repères rapides',
      subtitle: 'Orienter la qualification dès le recueil',
      icon: Icons.gavel_rounded,
      items: [
        _Item(
          title: 'Atteintes aux personnes',
          tags: ['violences', 'conjugales', 'menaces', 'harcèlement'],
          body:
              '• Violences (ITT inconnue/≤8j/>8j), coups, strangulation, arme.\n'
              '• Menaces (mort, crime) et chantage.\n'
              '• Harcèlement (répétition, contexte conjugal/professionnel/numérique).\n'
              '• Agressions sexuelles, viol (contrainte, menace, surprise, violence).',
        ),
        _Item(
          title: 'Atteintes aux biens',
          tags: ['vol', 'dégradation', 'escroquerie'],
          body:
              '• Vol simple/aggravé (effraction, réunion, arme), vol à la tire.\n'
              '• Dégradations (simple/volontaire en réunion/commune).\n'
              '• Escroquerie/abus de confiance (manœuvres frauduleuses, remise volontaire).',
        ),
        _Item(
          title: 'Cyber & fraudes',
          tags: ['hameçonnage', 'CB', 'usurpation'],
          body:
              '• Fraude carte bancaire, hameçonnage (site/app/numéro, flux financiers).\n'
              '• Usurpation d’identité, accès frauduleux à un STAD, revenge porn.\n'
              '• Rançongiciel/compte piraté : dépôt éléments techniques (adresses, logs).',
        ),
      ],
    ),
    _Bloc(
      id: 'pieces',
      title: 'Pièces à joindre',
      subtitle: 'Consolider la plainte',
      icon: Icons.attach_file_rounded,
      items: [
        _Item(
          title: 'Liste type',
          tags: ['preuves', 'certificat', 'captures'],
          body:
              '• Justificatif identité du plaignant.\n'
              '• Certificat médical/UMJ (violences) avec ITT si connue.\n'
              '• Factures, devis, photos/vidéos (atteintes aux biens).\n'
              '• Captures d’écran, échanges (SMS, messageries), historiques, liens URL.\n'
              '• Relevés bancaires, oppositions, IBAN/trace virement.\n'
              '• Tout élément d’identification d’auteur (pseudo, numéro, plaque).',
        ),
      ],
    ),
    _Bloc(
      id: 'droits',
      title: 'Droits & informations à délivrer',
      subtitle: 'Information victime (orientation, aides, suites)',
      icon: Icons.info_rounded,
      items: [
        _Item(
          title: 'Informer clairement',
          tags: ['victime', 'associations', 'CIVI', 'AJ'],
          body:
              '• Possibilité d’assistance (avocat, association d’aide aux victimes, interprète).\n'
              '• Indemnisation : CIVI selon cas, assurance, fonds.\n'
              '• Aide juridictionnelle (selon ressources) et accompagnement social.\n'
              '• Suites : transmission parquet, numéro de plainte, éventuels actes PJ.\n'
              '• Pour violences intrafamiliales : ordonnance de protection, mise à l’abri, téléphone grave danger (selon dispositifs).',
        ),
      ],
    ),
    _Bloc(
      id: 'distinctions',
      title: 'Plainte vs. Main courante',
      subtitle: 'Bien orienter la demande',
      icon: Icons.compare_arrows_rounded,
      items: [
        _Item(
          title: 'Différences',
          tags: ['orientation', 'procédure'],
          body:
              '• Plainte : déclenche poursuites/actes d’enquête, information parquet.\n'
              '• Main courante : enregistrement de faits sans poursuite immédiate ; utile pour traces contextuelles mais pas d’enquête systématique.\n'
              '• Expliquer les enjeux et laisser la personne choisir informée.',
        ),
      ],
    ),
    _Bloc(
      id: 'suites',
      title: 'Suites procédurales',
      subtitle: 'Après l’enregistrement',
      icon: Icons.forward_to_inbox_rounded,
      items: [
        _Item(
          title: 'Chaîne',
          tags: ['parquet', 'enquête', 'classement'],
          body:
              '• Envoi au parquet (RPPN/numéro de plainte).\n'
              '• Possibles actes : auditions, réquisitions, expertises, gardes à vue.\n'
              '• Décisions parquet : poursuites, alternative, médiation, classement.\n'
              '• Information du plaignant des suites significatives.',
        ),
      ],
    ),
    _Bloc(
      id: 'trames',
      title: 'Trames prêtes à l’emploi (copier/coller)',
      subtitle: 'Modèles rapides avec variables à compléter',
      icon: Icons.edit_note_rounded,
      items: [
        _Item(
          title: 'Trame — PV de plainte (générique)',
          tags: ['PV', 'modèle'],
          trameText:
              'Je soussigné(e) <GRADE QUALITÉ> <NOM Prénom>, immatriculé(e) <MATRICULE>, affecté(e) à <SERVICE>,\n'
              'dresse le présent procès-verbal ce jour <DATE>, de <HEURE_DEBUT> à <HEURE_FIN>, à <LIEU>.\n'
              'Est présent(e) <IDENTITÉ_VICTIME> né(e) le <NAISSANCE> à <LIEU_NAISS>, demeurant <ADRESSE>,\n'
              'joignable au <TÉL> / <EMAIL>. Sur sa demande, je recueille sa plainte pour les faits suivants :\n\n'
              '— EXPOSÉ DES FAITS —\n'
              '<RELATER LES FAITS DANS L’ORDRE CHRONOLOGIQUE, TERMES SIMPLES, FACTUELS, ÉVENTUELLES CITATIONS ENTRE GUILLEMETS.>\n\n'
              '— ÉLÉMENTS COMPLÉMENTAIRES —\n'
              'Témoins : <NOMS/CONTACTS> ; Préjudices : <CORPOREL/MATÉRIEL/MORAL> ; Pièces remises : <LISTE>.\n'
              'Souhaite être tenu(e) informé(e) des suites : <OUI/NON>.\n\n'
              'Le(la) plaignant(e) reconnaît exacte la présente déclaration, lecture faite, et signe avec nous.\n'
              'Signatures : <SIGNATURES>.\n'
              'Clôturé à <HEURE_FIN>.\n',
        ),
        _Item(
          title: 'Trame — Violences intrafamiliales (victime)',
          tags: ['violences', 'conjugales', 'VIF'],
          trameText:
              'La victime déclare vivre avec <IDENTITÉ_AUTEUR / LIEN>. Faits survenus le <DATE> à <LIEU>.\n'
              'Modes opératoires (ex : coups, strangulation, menaces) : <DÉTAILS>.\n'
              'Antériorité des faits (répétition, escalade) : <OUI/NON + PRÉCISIONS>.\n'
              'Enfants exposés : <OUI/NON + IDENTITÉS>.\n'
              'Préjudices (douleurs, lésions visibles) : <DÉTAILS>. Orientation médicale/UMJ : <OUI/NON>.\n'
              'Mesures de protection évoquées : <OP, éviction, TGD…>.\n'
              'Pièces remises (photos, certificats, messages) : <LISTE>.\n',
        ),
        _Item(
          title: 'Trame — Escroquerie/fraude CB',
          tags: ['cyber', 'escroquerie', 'CB'],
          trameText:
              'Le plaignant relate la découverte de débits frauduleux le <DATE> pour un montant total de <MONTANT> €.\n'
              'Banque : <NOM>, carte <RÉF>, opposition faite le <DATE> (réf. <NUM_OPP>). Plateforme/app suspecte : <NOM/LINK>.\n'
              'Communications reçues (mail/SMS/appels) : <COPIER LES CONTENUS/LIENS>.\n'
              'Signalement banque/plateforme : <RÉF> ; dépôt Cybermalveillance/Pharos : <OUI/NON>.\n'
              'Pièces jointes : relevés, captures d’écran, IBAN destinataire(s) si connus.\n',
        ),
        _Item(
          title: 'Trame — Vol simple avec effraction',
          tags: ['vol', 'effraction', 'biens'],
          trameText:
              'Faits découverts le <DATE/HEURE> à <ADRESSE>. Serrure/ouvrants fracturés : <DÉTAILS>.\n'
              'Objets manquants : <LISTE + VALEUR ESTIMATIVE>. Traces/indices préservés : <OUI/NON + PRÉCISIONS>.\n'
              'Système vidéo / alarme : <OUI/NON + RÉCUPÉRATION EN COURS>.\n'
              'Voisinage/témoins : <IDENTITÉS/COORDONNÉES>.\n'
              'Assurance : <COMPAGNIE + NUM CONTRAT>.\n',
        ),
        _Item(
          title: 'Trame — Menaces/harcèlement numérique',
          tags: ['menaces', 'harcèlement', 'numérique'],
          trameText:
              'Depuis le <DATE>, le plaignant reçoit des messages <MENACES/INSULTES> via <RÉSEAUX/APP> de la part de <IDENTITÉ/PSEUDO/INCONNU>.\n'
              'Fréquence : <NOMBRE/JOUR/SEMAINE> ; Heure : <PLAGES> ; Contenu type : <EXEMPLES>.\n'
              'Captures conservées et remises : <OUI/NON + LISTE>. Signalement plateforme : <RÉF>.\n'
              'Impact (anxiété, sommeil, travail) : <DÉCRIRE>.\n',
        ),
      ],
    ),
    _Bloc(
      id: 'bonnespratiques',
      title: 'Bonnes pratiques de rédaction',
      subtitle: 'Lisibilité & solidité procédurale',
      icon: Icons.tips_and_updates_rounded,
      items: [
        _Item(
          title: 'Conseils',
          tags: ['rédaction', 'qualité'],
          body:
              '• Phrases courtes, ordre chronologique, mots simples.\n'
              '• Éviter jargon non compris ; expliciter abréviations.\n'
              '• Citer les propos sensibles entre guillemets ; pas d’interprétation.\n'
              '• Rattacher chaque pièce jointe dans le corps du PV (référence claire).\n'
              '• Relire avec la personne, corriger si besoin, faire signer.',
        ),
      ],
    ),
  ];
}
