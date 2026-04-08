import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/models/menu_bar_tab_types.dart';

/// Top navigation menu with category and page links
class TopMenu extends StatelessComponent {
  const TopMenu({super.key});

  @override
  Component build(BuildContext context) {
    // Get current page URL to determine active menu item
    final currentUrl = context.page.url;

    // Determine if home is active (root path or /index)
    final isHomeActive = currentUrl == '/' || currentUrl == '/index';

    return div(classes: 'flex-menu-bar', [
      // Hamburger menu when browser window is narrow
      button(
        classes: 'flex-menu-toggle',
        attributes: {'aria-label': 'Toggle menu'},
        [
          span(classes: 'hamburger', []),
        ],
      ),

      // Category and page navigation
      nav(classes: 'flex-nav', [
        ul(classes: 'flex-category-menu', [
          // Home link
          li(
            [
              a(
                href: '/',
                classes: isHomeActive ? 'active' : null,
                [Component.text('Home')],
              ),
            ],
          ),
          // Dynamic menu tabs (categories and pages - only displayed top-level items)
          for (final tab in MenuBarTab.displayedTopLevel)
            li([
              a(
                href: tab.path,
                classes: _isTabActive(currentUrl, tab) ? 'active' : null,
                [Component.text(tab.name)],
              ),
            ]),
        ]),
      ]),
    ]);
  }

  /// Determine if a menu tab is active based on current URL
  bool _isTabActive(String currentUrl, MenuBarTab tab) {
    // Check if current URL starts with the tab's path
    // This handles both exact matches and child pages
    // e.g., /category/adorable matches /category/adorable
    // and /category/adorable/page/2 also matches
    return currentUrl.startsWith(tab.path);
  }
}
