import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Top navigation menu with category links
class SocialMedia extends StatelessComponent {
  const SocialMedia({
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return // Social media icons
    nav(classes: 'flex-social-nav', [
      ul(classes: 'flex-social-menu', [
        li([
          a(
            href: 'https://bsky.app/profile/tmtdslt.com',
            target: Target.blank,
            attributes: {'aria-label': 'Bluesky'},
            [Component.text('🦋')],
          ),
        ]),
      ]),
    ]);
  }
}
