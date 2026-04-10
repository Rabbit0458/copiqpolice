import 'package:flutter/material.dart';

class AnnulationConditionsPage extends StatelessWidget {
  const AnnulationConditionsPage({super.key});

  static const routeName = '/annulation-conditions';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    final stroke = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.08);

    final subtle = t.colorScheme.onSurface.withOpacity(isDark ? .75 : .70);

    final danger = const Color(0xFFD94841);
    final warning = const Color(0xFFF08C00);
    final success = const Color(0xFF2F9E44);

    Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: t.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
        ),
      ),
    );

    Widget paragraph(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: t.textTheme.bodyMedium?.copyWith(
          height: 1.5,
          fontWeight: FontWeight.w600,
          color: t.colorScheme.onSurface.withOpacity(isDark ? .92 : .88),
        ),
      ),
    );

    Widget card({required Widget child, Color? borderColor}) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? stroke, width: 1.1),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(isDark ? .35 : .08),
          ),
        ],
      ),
      child: child,
    );

    Widget alertBox({
      required Color color,
      required IconData icon,
      required String title,
      required String body,
    }) => Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? .18 : .12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: t.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: t.textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                    color: t.colorScheme.onSurface.withOpacity(.95),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final today = DateTime.now();
    final updated =
        '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    return Scaffold(
      backgroundColor: t.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Annulation & conditions d’usage"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
        children: [
          card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cadre légal des abonnements COP’IQ",
                  style: t.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Cette page explique de manière claire et transparente les règles applicables "
                  "à l’annulation, la résiliation, l’accès aux services et les restrictions éventuelles. "
                  "Elle vise à protéger à la fois l’utilisateur et COP’IQ.",
                  style: t.textTheme.bodyMedium?.copyWith(
                    color: subtle,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          sectionTitle("1. Annulation de l’abonnement"),
          card(
            child: paragraph(
              "L’utilisateur peut annuler son abonnement à tout moment depuis le store utilisé "
              "(App Store, Google Play ou AppGallery). L’annulation empêche le renouvellement automatique "
              "mais n’interrompt pas immédiatement l’accès aux services.",
            ),
          ),

          const SizedBox(height: 12),

          sectionTitle("2. Effet de la résiliation"),
          card(
            child: paragraph(
              "Après annulation, l’utilisateur conserve l’accès aux fonctionnalités payantes "
              "jusqu’à la fin de la période déjà réglée. À l’expiration de cette période, "
              "le compte bascule automatiquement en version gratuite.",
            ),
          ),

          const SizedBox(height: 12),

          sectionTitle("3. Paiement & remboursements"),
          card(
            child: paragraph(
              "Les paiements et éventuels remboursements sont gérés exclusivement par le store "
              "utilisé lors de la souscription. COP’IQ ne peut ni garantir ni forcer un remboursement. "
              "Toute demande est soumise aux conditions et procédures du store concerné.",
            ),
          ),

          const SizedBox(height: 16),

          alertBox(
            color: danger,
            icon: Icons.block_rounded,
            title: "Interdiction du partage de compte",
            body:
                "Les abonnements COP’IQ sont strictement personnels. Le partage de compte, "
                "la mise à disposition des identifiants ou l’accès simultané par des tiers "
                "sont formellement interdits. En cas d’anomalies ou d’indices sérieux d’usage abusif, "
                "COP’IQ peut restreindre ou suspendre l’accès, conformément à la réglementation en vigueur.",
          ),

          const SizedBox(height: 12),

          alertBox(
            color: warning,
            icon: Icons.gavel_rounded,
            title: "Suspension exceptionnelle",
            body:
                "Une suspension d’accès peut intervenir uniquement en cas de fraude avérée, "
                "d’abus manifeste ou de violation grave des conditions. "
                "L’utilisateur est informé des motifs et dispose d’un droit de contestation, "
                "conformément au Digital Services Act (DSA).",
          ),

          const SizedBox(height: 12),

          alertBox(
            color: success,
            icon: Icons.verified_user_rounded,
            title: "Transparence & recours",
            body:
                "Toute décision de restriction ou suspension est tracée. "
                "L’utilisateur peut demander des explications ou exercer un recours "
                "via le support COP’IQ, dans un délai raisonnable.",
          ),

          const SizedBox(height: 18),
          Divider(color: stroke),
          const SizedBox(height: 10),

          Text(
            "Dernière mise à jour : $updated",
            style: t.textTheme.bodySmall?.copyWith(
              color: t.hintColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Cette page peut évoluer jusqu’à la sortie officielle de COP’IQ, puis être mise à jour "
            "afin de garantir une conformité continue avec la législation et les règles des stores.",
            style: t.textTheme.bodySmall?.copyWith(
              color: t.hintColor.withOpacity(.9),
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
