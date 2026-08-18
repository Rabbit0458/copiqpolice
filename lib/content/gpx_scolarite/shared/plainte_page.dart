// lib/pages/gpx/plainte_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

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
                    colors: [cs.primary.withValues(alpha: .10), cs.surface],
                  ),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: .35),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 14, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _IconBadge(icon: Icons.how_to_vote_rounded),
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
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                                "f00001",
                                'Recueil, mentions obligatoires, droits, trames PV',
                              ),
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const Spacer(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _TinyTag(
                                  icon: Icons.article_rounded,
                                  label: 'PV',
                                ),
                                _TinyTag(
                                  icon: Icons.info_rounded,
                                  label: ScolariteText.value(
                                    "lib/content/gpx_scolarite/shared/plainte_page.dart",
                                    "f00002",
                                    'Droits victime',
                                  ),
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
                  hintText: ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/plainte_page.dart",
                    "f00003",
                    'Rechercher (ex: mentions, droits, violences, ITT, témoin…)',
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: cs.surfaceContainerHighest.withValues(alpha: .55),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: .5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: .5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: cs.primary.withValues(alpha: .6),
                    ),
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
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/plainte_page.dart",
                    "f00004",
                    'Aucun résultat',
                  ),
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
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .35)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: .06),
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
          color: cs.surfaceContainerHighest.withValues(alpha: .6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .25)),
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
        border: Border.all(color: cs.outlineVariant.withValues(alpha: .35)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: cs.surfaceContainerHighest.withValues(alpha: .5),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/plainte_page.dart",
                    "f00005",
                    'Trame à copier',
                  ),
                  style: tt.labelLarge,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/shared/plainte_page.dart",
                            "f00006",
                            'Trame copiée dans le presse-papiers',
                          ),
                        ),
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
        color: cs.primary.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: .25)),
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
        color: cs.secondaryContainer.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: .3)),
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
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00007",
        'Accueil & sécurité',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00008",
        'Posture, confidentialité, besoins immédiats',
      ),
      icon: Icons.volunteer_activism_rounded,
      items: [
        _Item(
          title: 'Principes',
          tags: [
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00009",
              'écoute',
            ),
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00010",
              'neutralité',
            ),
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00011",
              'confidentialité',
            ),
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00012",
                '• Se présenter (nom, qualité), vérifier l’intimité du lieu.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00013",
                '• Évaluer la sécurité immédiate (besoin de soins, mise à l’abri, mise en relation 17/SAMU).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00014",
                '• Adapter le rythme, vérifier la langue (interprète si besoin), éviter les questions suggestives.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00015",
                '• Informer sur le déroulé : recueil des faits, mentions au PV, orientation et suites.',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'mentions',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00016",
        'Mentions obligatoires du PV de plainte',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00017",
        'Structure type et éléments à ne pas oublier',
      ),
      icon: Icons.fact_check_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00018",
            'Mentions clés',
          ),
          tags: ['CPP', 'PV', 'horodatage'],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00019",
                '• Lieu, date, heures de début/fin du PV.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00020",
                '• Identité et qualité du rédacteur (OPJ/APJ), matricule, service.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00021",
                '• Identité complète du plaignant (état civil, adresses, contacts), régime matrimonial si utile.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00022",
                '• Information sur droits (information victime, associations, indemnisation, orientation).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00023",
                '• Déroulé fidèle des déclarations (guillemets si propos rapportés).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00024",
                '• Références des pièces jointes (certificat médical, justificatifs, captures).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00025",
                '• Signature plaignant et agent (mention de refus/empêchement si non-signature).',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'recueil',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00026",
        'Recueil des faits — Checklist',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00027",
        'Ce qu’il faut documenter systématiquement',
      ),
      icon: Icons.checklist_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00028",
            'Checklist essentielle',
          ),
          tags: [
            'faits',
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00029",
              'témoins',
            ),
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00030",
              'préjudice',
            ),
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00031",
                '• Quand ? (date, heure de début/fin, fréquence si faits répétés)\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00032",
                '• Où ? (adresse, local, véhicule, en ligne : plateforme/lien)\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00033",
                '• Comment ? (modus operandi, menaces, armes, contraintes, numérique)\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00034",
                '• Qui ? (auteur(s) supposé(s)/inconnu(s), description, liens avec victime)\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00035",
                '• Témoins (identité/contact)\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00036",
                '• Préjudice (corporel : douleurs, ITT si connue ; matériel : objets/valeur ; moral)\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00037",
                '• Éléments conservatoires (captures écran, mails, vidéos, factures, IBAN)\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00038",
                '• Suites immédiates (soins, changement serrures, blocage CB, dépôt opposition).',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'qualification',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00039",
        'Qualification pénale — repères rapides',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00040",
        'Orienter la qualification dès le recueil',
      ),
      icon: Icons.gavel_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00041",
            'Atteintes aux personnes',
          ),
          tags: [
            'violences',
            'conjugales',
            'menaces',
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00042",
              'harcèlement',
            ),
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00043",
                '• Violences (ITT inconnue/≤8j/>8j), coups, strangulation, arme.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00044",
                '• Menaces (mort, crime) et chantage.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00045",
                '• Harcèlement (répétition, contexte conjugal/professionnel/numérique).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00046",
                '• Agressions sexuelles, viol (contrainte, menace, surprise, violence).',
              ),
        ),
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00047",
            'Atteintes aux biens',
          ),
          tags: [
            'vol',
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00048",
              'dégradation',
            ),
            'escroquerie',
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00049",
                '• Vol simple/aggravé (effraction, réunion, arme), vol à la tire.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00050",
                '• Dégradations (simple/volontaire en réunion/commune).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00051",
                '• Escroquerie/abus de confiance (manœuvres frauduleuses, remise volontaire).',
              ),
        ),
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00052",
            'Cyber & fraudes',
          ),
          tags: [
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00053",
              'hameçonnage',
            ),
            'CB',
            'usurpation',
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00054",
                '• Fraude carte bancaire, hameçonnage (site/app/numéro, flux financiers).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00055",
                '• Usurpation d’identité, accès frauduleux à un STAD, revenge porn.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00056",
                '• Rançongiciel/compte piraté : dépôt éléments techniques (adresses, logs).',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'pieces',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00057",
        'Pièces à joindre',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00058",
        'Consolider la plainte',
      ),
      icon: Icons.attach_file_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00059",
            'Liste type',
          ),
          tags: ['preuves', 'certificat', 'captures'],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00060",
                '• Justificatif identité du plaignant.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00061",
                '• Certificat médical/UMJ (violences) avec ITT si connue.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00062",
                '• Factures, devis, photos/vidéos (atteintes aux biens).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00063",
                '• Captures d’écran, échanges (SMS, messageries), historiques, liens URL.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00064",
                '• Relevés bancaires, oppositions, IBAN/trace virement.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00065",
                '• Tout élément d’identification d’auteur (pseudo, numéro, plaque).',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'droits',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00066",
        'Droits & informations à délivrer',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00067",
        'Information victime (orientation, aides, suites)',
      ),
      icon: Icons.info_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00068",
            'Informer clairement',
          ),
          tags: ['victime', 'associations', 'CIVI', 'AJ'],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00069",
                '• Possibilité d’assistance (avocat, association d’aide aux victimes, interprète).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00070",
                '• Indemnisation : CIVI selon cas, assurance, fonds.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00071",
                '• Aide juridictionnelle (selon ressources) et accompagnement social.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00072",
                '• Suites : transmission parquet, numéro de plainte, éventuels actes PJ.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00073",
                '• Pour violences intrafamiliales : ordonnance de protection, mise à l’abri, téléphone grave danger (selon dispositifs).',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'distinctions',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00074",
        'Plainte vs. Main courante',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00075",
        'Bien orienter la demande',
      ),
      icon: Icons.compare_arrows_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00076",
            'Différences',
          ),
          tags: [
            'orientation',
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00077",
              'procédure',
            ),
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00078",
                '• Plainte : déclenche poursuites/actes d’enquête, information parquet.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00079",
                '• Main courante : enregistrement de faits sans poursuite immédiate ; utile pour traces contextuelles mais pas d’enquête systématique.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00080",
                '• Expliquer les enjeux et laisser la personne choisir informée.',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'suites',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00081",
        'Suites procédurales',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00082",
        'Après l’enregistrement',
      ),
      icon: Icons.forward_to_inbox_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00083",
            'Chaîne',
          ),
          tags: [
            'parquet',
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00084",
              'enquête',
            ),
            'classement',
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00085",
                '• Envoi au parquet (RPPN/numéro de plainte).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00086",
                '• Possibles actes : auditions, réquisitions, expertises, gardes à vue.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00087",
                '• Décisions parquet : poursuites, alternative, médiation, classement.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00088",
                '• Information du plaignant des suites significatives.',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'trames',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00089",
        'Trames prêtes à l’emploi (copier/coller)',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00090",
        'Modèles rapides avec variables à compléter',
      ),
      icon: Icons.edit_note_rounded,
      items: [
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00091",
            'Trame — PV de plainte (générique)',
          ),
          tags: [
            'PV',
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00092",
              'modèle',
            ),
          ],
          trameText:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00093",
                'Je soussigné(e) <GRADE QUALITÉ> <NOM Prénom>, immatriculé(e) <MATRICULE>, affecté(e) à <SERVICE>,\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00094",
                'dresse le présent procès-verbal ce jour <DATE>, de <HEURE_DEBUT> à <HEURE_FIN>, à <LIEU>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00095",
                'Est présent(e) <IDENTITÉ_VICTIME> né(e) le <NAISSANCE> à <LIEU_NAISS>, demeurant <ADRESSE>,\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00096",
                'joignable au <TÉL> / <EMAIL>. Sur sa demande, je recueille sa plainte pour les faits suivants :\n\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00097",
                '— EXPOSÉ DES FAITS —\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00098",
                '<RELATER LES FAITS DANS L’ORDRE CHRONOLOGIQUE, TERMES SIMPLES, FACTUELS, ÉVENTUELLES CITATIONS ENTRE GUILLEMETS.>\n\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00099",
                '— ÉLÉMENTS COMPLÉMENTAIRES —\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00100",
                'Témoins : <NOMS/CONTACTS> ; Préjudices : <CORPOREL/MATÉRIEL/MORAL> ; Pièces remises : <LISTE>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00101",
                'Souhaite être tenu(e) informé(e) des suites : <OUI/NON>.\n\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00102",
                'Le(la) plaignant(e) reconnaît exacte la présente déclaration, lecture faite, et signe avec nous.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00103",
                'Signatures : <SIGNATURES>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00104",
                'Clôturé à <HEURE_FIN>.\n',
              ),
        ),
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00105",
            'Trame — Violences intrafamiliales (victime)',
          ),
          tags: ['violences', 'conjugales', 'VIF'],
          trameText:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00106",
                'La victime déclare vivre avec <IDENTITÉ_AUTEUR / LIEN>. Faits survenus le <DATE> à <LIEU>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00107",
                'Modes opératoires (ex : coups, strangulation, menaces) : <DÉTAILS>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00108",
                'Antériorité des faits (répétition, escalade) : <OUI/NON + PRÉCISIONS>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00109",
                'Enfants exposés : <OUI/NON + IDENTITÉS>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00110",
                'Préjudices (douleurs, lésions visibles) : <DÉTAILS>. Orientation médicale/UMJ : <OUI/NON>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00111",
                'Mesures de protection évoquées : <OP, éviction, TGD…>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00112",
                'Pièces remises (photos, certificats, messages) : <LISTE>.\n',
              ),
        ),
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00113",
            'Trame — Escroquerie/fraude CB',
          ),
          tags: ['cyber', 'escroquerie', 'CB'],
          trameText:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00114",
                'Le plaignant relate la découverte de débits frauduleux le <DATE> pour un montant total de <MONTANT> €.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00115",
                'Banque : <NOM>, carte <RÉF>, opposition faite le <DATE> (réf. <NUM_OPP>). Plateforme/app suspecte : <NOM/LINK>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00116",
                'Communications reçues (mail/SMS/appels) : <COPIER LES CONTENUS/LIENS>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00117",
                'Signalement banque/plateforme : <RÉF> ; dépôt Cybermalveillance/Pharos : <OUI/NON>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00118",
                'Pièces jointes : relevés, captures d’écran, IBAN destinataire(s) si connus.\n',
              ),
        ),
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00119",
            'Trame — Vol simple avec effraction',
          ),
          tags: ['vol', 'effraction', 'biens'],
          trameText:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00120",
                'Faits découverts le <DATE/HEURE> à <ADRESSE>. Serrure/ouvrants fracturés : <DÉTAILS>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00121",
                'Objets manquants : <LISTE + VALEUR ESTIMATIVE>. Traces/indices préservés : <OUI/NON + PRÉCISIONS>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00122",
                'Système vidéo / alarme : <OUI/NON + RÉCUPÉRATION EN COURS>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00123",
                'Voisinage/témoins : <IDENTITÉS/COORDONNÉES>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00124",
                'Assurance : <COMPAGNIE + NUM CONTRAT>.\n',
              ),
        ),
        _Item(
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/plainte_page.dart",
            "f00125",
            'Trame — Menaces/harcèlement numérique',
          ),
          tags: [
            'menaces',
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00126",
              'harcèlement',
            ),
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00127",
              'numérique',
            ),
          ],
          trameText:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00128",
                'Depuis le <DATE>, le plaignant reçoit des messages <MENACES/INSULTES> via <RÉSEAUX/APP> de la part de <IDENTITÉ/PSEUDO/INCONNU>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00129",
                'Fréquence : <NOMBRE/JOUR/SEMAINE> ; Heure : <PLAGES> ; Contenu type : <EXEMPLES>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00130",
                'Captures conservées et remises : <OUI/NON + LISTE>. Signalement plateforme : <RÉF>.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00131",
                'Impact (anxiété, sommeil, travail) : <DÉCRIRE>.\n',
              ),
        ),
      ],
    ),
    _Bloc(
      id: 'bonnespratiques',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00132",
        'Bonnes pratiques de rédaction',
      ),
      subtitle: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/plainte_page.dart",
        "f00133",
        'Lisibilité & solidité procédurale',
      ),
      icon: Icons.tips_and_updates_rounded,
      items: [
        _Item(
          title: 'Conseils',
          tags: [
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00134",
              'rédaction',
            ),
            ScolariteText.value(
              "lib/content/gpx_scolarite/shared/plainte_page.dart",
              "f00135",
              'qualité',
            ),
          ],
          body:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00136",
                '• Phrases courtes, ordre chronologique, mots simples.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00137",
                '• Éviter jargon non compris ; expliciter abréviations.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00138",
                '• Citer les propos sensibles entre guillemets ; pas d’interprétation.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00139",
                '• Rattacher chaque pièce jointe dans le corps du PV (référence claire).\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/plainte_page.dart",
                "f00140",
                '• Relire avec la personne, corriger si besoin, faire signer.',
              ),
        ),
      ],
    ),
  ];
}
