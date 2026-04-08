import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class ContactUsPage extends StatelessComponent {
  const ContactUsPage._();

  static final path = '/contact-us';

  static final route = Route(
    path: path,
    title: 'Contact Us',
    builder: (context, state) => ContactUsPage._(),
  );

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      p([
        Component.text('via '),
        a(
          href: 'https://bsky.app/profile/tmtdslt.bsky.social',
          target: Target.blank,
          [Component.text('Bluesky')],
        ),
      ]),
      p([
        Component.text('via '),
        a(
          href: 'https://twitter.com/tmtdslt',
          target: Target.blank,
          [Component.text('Twitter/X')],
        ),
      ]),
    ]);
  }
}
