import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';

/// Main footer component for the blog layout
class MainFooter extends StatelessComponent {
  const MainFooter({
    required this.config,
    super.key,
  });

  final FlexLayoutConfig config;

  @override
  Component build(BuildContext context) {
    return // Footer
    footer(classes: 'flex-footer', [
      div(classes: 'flex-footer-content', [
        // Copyright
        p(classes: 'flex-copyright', [
          Component.text(config.footerText),
        ]),

        // Jaspr badge (respects dark/light mode via CSS)
        if (config.showJasprBadge)
          div(classes: 'flex-jaspr-badge', [
            // Light mode badge
            a(
              href: 'https://jaspr.site',
              target: Target.blank,
              classes: 'jaspr-badge-light',
              [
                JasprBadge.lightTwoTone(),
              ],
            ),
            // Dark mode badge
            a(
              href: 'https://jaspr.site',
              target: Target.blank,
              classes: 'jaspr-badge-dark',
              [JasprBadge.darkTwoTone()],
            ),
          ]),
      ]),
    ]);
  }
}
