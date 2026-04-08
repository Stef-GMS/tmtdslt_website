import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/main_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/main_footer.dart';
import 'package:tmtdslt/layout/flexible_layout/components/main_header.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_styles.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_theme.dart';

/// FlexibleLayout - A flexible, customizable layout for jaspr_content
///
/// Extends PageLayoutBase to provide a complete blog layout with:
/// - Header with site title and navigation
/// - Main content area
/// - Optional sidebar (left or right)
/// - Footer with copyright and Jaspr badge
/// - Light/dark theme support
class FlexibleLayout extends PageLayoutBase {
  const FlexibleLayout({
    required this.config,
  });

  final FlexLayoutConfig config;

  @override
  Pattern get name => 'flexible'; // To be used in frontmatter.

  @override
  Iterable<Component> buildHead(Page page) sync* {
    // Add common meta tags from PageLayoutBase
    yield* super.buildHead(page);

    // Add theme CSS variables (needed for our custom layout)
    yield RawText('<style>${FlexTheme.generateThemeCSS()}</style>');

    // Add layout styles (imported from flex_layout_styles.dart)
    yield RawText('<style>$flexLayoutStyles</style>');

    // Add Google Fonts
    yield link(
      rel: 'preconnect',
      href: 'https://fonts.googleapis.com',
    );
    yield link(
      rel: 'preconnect',
      href: 'https://fonts.gstatic.com',
      attributes: {'crossorigin': ''},
    );
    yield link(
      rel: 'stylesheet',
      href:
          'https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600;700&family=Raleway:wght@400;500;600&display=swap',
    );

    // Add hamburger menu JavaScript
    yield RawText('''
      <script>
        document.addEventListener('DOMContentLoaded', function() {
          const menuToggle = document.querySelector('.flex-menu-toggle');
          const menuBar = document.querySelector('.flex-menu-bar');

          if (menuToggle && menuBar) {
            menuToggle.addEventListener('click', function() {
              menuBar.classList.toggle('menu-open');
            });
          }
        });
      </script>
    ''');
  }

  /// Components are the central class hierarchy in the Jaspr framework and have the
  /// same structure and purpose as widgets do in Flutter. A component is an
  /// immutable description of part of a user interface. Components can be
  /// inflated into elements, which manage the underlying DOM.
  ///
  /// Page is a single page of the site. It contains the page's source path, url,
  /// content, and additional data. The page object is passed to the different
  /// modules of the content package and may be modified by them.

  /// Top-level layout structure
  ///
  /// This component provides the overall page structure including:
  /// - Header with site branding and social links
  /// - Top navigation menu
  /// - Main content area with sidebar
  /// - Footer

  @override
  Component buildBody(
    // `page` contains all page data, including frontmatter.
    // `child` is the rendered content of the page.
    Page page,
    Component child,
  ) {
    // Page frame is the top-level layout structure
    return div(
      classes: 'flex-layout',
      [
        // Header
        MainHeader(config: config),

        // Main content wrapper
        MainContent(
          config: config,
          page: page,
          child: child,
        ),
        // main_(
        //   classes: 'flex-main',
        //   [
        //     child,
        //   ],
        // ),

        // Footer
        MainFooter(config: config),
      ],
    );
  }
}
