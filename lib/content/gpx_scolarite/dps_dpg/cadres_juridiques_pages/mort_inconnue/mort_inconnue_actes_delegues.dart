// lib/gpx_scolarite_pages/cadres_juridiques/mort_inconnue/mort_inconnue_actes_delegues.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _lawColor = Color(0xFFE53935);

class MortInconnueActesDeleguesPage extends StatelessWidget {
  const MortInconnueActesDeleguesPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/mort_inconnue/actes_delegues';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Mort de cause inconnue',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================================================================
          //                          TITRE PAGE
          // ================================================================
          Text(
            'Les actes délégués par le procureur de la République',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: textMain,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph.rich([
            const TextSpan(
              text:
                  'L’article 74 du Code de procédure pénale dresse une liste précise des actes '
                  'que peuvent réaliser les officiers de police judiciaire (O.P.J.) ou, sous leur contrôle, '
                  'les agents de police judiciaire (A.P.J.), sur instructions du procureur de la République. '
                  'Outre les constatations et réquisitions à personnes qualifiées, les enquêteurs peuvent '
                  'également mettre en œuvre les actes prévus aux articles 56 à 62 du Code de procédure pénale, '
                  'afin de rechercher les causes du décès.',
            ),
          ]),
          const SizedBox(height: 18),

          // ================================================================
          //                          2.2.1.1 CONSTATATIONS
          // ================================================================
          _ConditionCard(
            title: '1. Les constatations',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _Paragraph(
                'L’officier ou l’agent de police judiciaire procède à toutes constatations '
                'utiles visant à déterminer les causes et les circonstances de la mort. '
                'Cela inclut l’examen du lieu, l’environnement, la position du corps, '
                'les traces visibles, les objets présents et tout élément susceptible '
                'd’éclairer la nature du décès.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //                          2.2.1.2 AUTOPSIE
          // ================================================================
          _ConditionCard(
            title: '2. L’autopsie',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’article 230-28 du Code de procédure pénale dispose qu’une autopsie peut être ordonnée '
                      'dans le cadre d’une enquête judiciaire mise en œuvre selon ',
                ),
                TextSpan(
                  text: 'l’article 74 du Code de procédure pénale',
                  style: const TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Les règles particulières figurent aux articles 230-28 à 230-31.',
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    'L’autopsie ne peut être confiée qu’à un médecin titulaire d’un diplôme en médecine légale '
                    'ou disposant d’une expertise reconnue.',
              ),
              const _BulletPoint(
                text:
                    'Le médecin procède aux prélèvements biologiques nécessaires et peut les placer sous scellés.',
              ),
              const _BulletPoint(
                text:
                    'La présence des enquêteurs n’est pas obligatoire, sauf si la nature de l’enquête justifie '
                    'leur présence pour guider le légiste ou être informés immédiatement.',
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        'Il est recommandé d’inclure explicitement dans la réquisition judiciaire la possibilité '
                        'de placer sous scellés les objets ou prélèvements effectués lors de l’autopsie '
                        '(circulaire JUSD1910288C du 8 avril 2019).',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Le médecin légiste doit veiller à la meilleure restauration possible du corps avant sa remise '
                'aux proches. Ceux-ci doivent être informés dans les meilleurs délais qu’une autopsie a été '
                'ordonnée et que des prélèvements ont été réalisés, sauf impératifs de santé publique.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //                        2.2.1.3 RÉQUISITIONS
          // ================================================================
          _ConditionCard(
            title: '3. Les réquisitions',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’officier ou l’agent de police judiciaire reçoit délégation du procureur de la République '
                      'pour requérir toute personne qualifiée afin ',
                ),
                const TextSpan(
                  text: '« d’apprécier la nature des circonstances du décès »',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Le médecin est prioritairement requis : constatation du décès et examen externe du corps.',
              ),
              const _BulletPoint(
                text:
                    'D’autres experts peuvent être requis selon la situation : armurier, serrurier, électricien, '
                    'mécanicien, expert incendie, etc.',
              ),
              const _BulletPoint(
                text:
                    'Les personnes requises doivent prêter serment par écrit, sauf si elles figurent sur l’une des listes prévues à l’article 157 du Code de procédure pénale.',
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Toute personne refusant de déférer à une réquisition s’expose aux sanctions de '
                        'l’article R 642-1 du Code pénal (contravention de 2ᵉ classe). S’agissant d’un médecin, '
                        'le refus constitue un délit puni par l’article L 4163-7 du Code de la santé publique.',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //                        2.2.1.4 à 2.2.1.8 LISTE SYNTHÉTIQUE
          // ================================================================
          _ConditionCard(
            title: '4. Autres actes délégués',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _SubTitle(
                'Liste des actes prévus par les articles 56 à 62 du Code de procédure pénale',
              ),
              _BulletPoint(text: 'Perquisitions'),
              _BulletPoint(text: 'Saisies'),
              _BulletPoint(
                text:
                    'Réquisitions à toute personne, établissement ou organisme privé, public ou administration',
              ),
              _BulletPoint(
                text:
                    'Empêcher toute personne de s’éloigner du lieu de découverte du corps jusqu’à la fin des opérations',
              ),
              _BulletPoint(
                text: 'Auditions des témoins, y compris par comparution forcée',
              ),
              _SizedGap(),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Dans ce cadre d’enquête, l’officier de police judiciaire ne peut pas placer une personne en garde à vue. '
                        'Le procureur de la République ne peut pas non plus délivrer de mandat de recherche.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizedGap extends StatelessWidget {
  const _SizedGap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 8);
}

////////////////////////////////////////////////////////////////////////////////
//                        WIDGETS PERSONNALISÉS
////////////////////////////////////////////////////////////////////////////////
// (identiques à tes widgets standard : _ConditionCard, _Paragraph, _BulletPoint, etc.)
// ------------------------------------------------------------------------------

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(.22), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 16.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final color = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    if (!isRich) {
      return Text(
        text!,
        style: GoogleFonts.fustat(
          height: 1.45,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        textAlign: TextAlign.justify,
      );
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: GoogleFonts.fustat(
          height: 1.45,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans!,
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 15.5,
          color: isDark ? Colors.white : const Color(0xFF0D47A1),
        ),
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .7 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withOpacity(.95),
          ),
          children: [
            TextSpan(
              text: 'NOTA : ',
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
