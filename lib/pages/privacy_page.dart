import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:tmtdslt/layout/flexible_layout/components/spacer.dart';

class PrivacyPolicyPage extends StatelessComponent {
  const PrivacyPolicyPage._();

  static final path = '/privacy-policy';

  static final route = Route(
    path: path,
    title: 'Privacy Policy',
    builder: (context, state) => PrivacyPolicyPage._(),
  );

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      p([Component.text('Effective Date: 06-July-2019')]),
      h2([Component.text('Who we are')]),
      div(
        styles: Styles.combine([
          Styles(padding: Spacing.all(Unit.em(1))),
          Styles(color: Colors.white),
          Styles(backgroundColor: Color.value(0x555555)),
        ]),
        [Component.text('Our website address is: https://TooMuchToDoSoLittleTime.com')],
      ),
      Spacer(height: 1.em),
      h2([Component.text('App Data')]),
      p([
        Component.text(
          'Our published apps do NOT currently collect any data. '
          'If in the future we create apps which collect data, '
          'we will update this Privacy Policy.',
        ),
      ]),
      p([
        Component.text(
          'Our published apps do NOT transmit to or store '
          'any data to our website or server(s).',
        ),
      ]),
      p([
        Component.text(
          'Any apps in testing may collect usage and/or crash '
          'data, if you choose to share this data it will be '
          'transmitted to us.',
        ),
      ]),
      Spacer(height: 1.em),
      h2([Component.text('Website Data')]),
      p([
        Component.text(
          'Data transmitted via our Contact Us page links '
          'are managed by the respective sites.',
        ),
        div(
          styles: Styles.combine([
            Styles(flexDirection: FlexDirection.column),
            Styles(lineHeight: Unit.em(2.5)),
            Styles(margin: Spacing.only(left: Unit.em(2.0))),
          ]),
          [
            // a(
            //   href: 'https://www.facebook.com/privacy/explanation',
            //   target: Target.blank,
            //   [text('Facebook/Meta')],
            // ),
            a(
              href: 'https://bsky.social/about/support/privacy-policy',
              target: Target.blank,
              [Component.text('Bluesky')],
            ),
            br(),
            a(
              href: 'https://twitter.com/en/privacy',
              target: Target.blank,
              [Component.text('Twitter/X')],
            ),
          ],
        ),
      ]),
      p([
        Component.text('We use '),
        a(
          href: 'https://analytics.google.com/',
          target: Target.blank,
          [Component.text('basic Google Analytics')],
        ),
        Component.text(' on our website to understand how our site is used. You can see '),
        a(
          href: 'https://policies.google.com/privacy',
          target: Target.blank,
          [Component.text('Google’s privacy policy')],
        ),
        Component.text(
          ' for more details. The lowest level of detail we see is, '
          'if the data is available:',
        ),
      ]),
      ul([
        li([Component.text('Acquisition: How you reached our site (ex. direct or search)')]),
        li([Component.text('Demographics: Language, Country, and City (NOT your specific location)')]),
        li([Component.text('Mobile: Device brand, model, marketing name, and screen resolution')]),
        li([Component.text('Technology: Browser & operating system and Internet service provider')]),
      ]),
      Spacer(height: 3.em),
    ]);
  }
}
