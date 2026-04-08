import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:tmtdslt/layout/flexible_layout/components/social_media.dart';
import 'package:tmtdslt/layout/flexible_layout/components/top_menu.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';

/// Top navigation menu with category links
class MainHeader extends StatelessComponent {
  const MainHeader({
    required this.config,
    super.key,
  });

  final FlexLayoutConfig config;

  @override
  Component build(BuildContext context) {
    return // Header
    header(classes: 'flex-header', [
      div(classes: 'flex-header-content', [
        // Site branding
        div(classes: 'flex-site-branding', [
          // Site title
          h1(classes: 'flex-site-title', [
            a(
              href: '/',
              [Component.text(config.siteTitle)],
            ),
          ]),
          // Site description, if available
          if (config.siteDescription.isNotEmpty)
            p(
              classes: 'flex-site-tagline',
              [
                Component.text(config.siteDescription),
              ],
            ),
        ]),

        // Social media icons and theme toggle
        div(classes: 'flex-header-actions', [
          SocialMedia(),
          // Theme toggle for light/dark mode
          ThemeToggle(),
        ]),
      ]),

      // Top navigation menu
      TopMenu(),
    ]);
  }
}
