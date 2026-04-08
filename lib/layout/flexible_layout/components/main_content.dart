import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/post_footer.dart';
import 'package:tmtdslt/layout/flexible_layout/components/post_header.dart';
import 'package:tmtdslt/layout/flexible_layout/components/post_navigation.dart';
import 'package:tmtdslt/layout/flexible_layout/components/sidebar.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';

/// Main content area with post header, content, and sidebar
class MainContent extends StatelessComponent {
  const MainContent({
    required this.config,
    required this.page,
    //required this.title,
    required this.child,
    super.key,
  });

  final FlexLayoutConfig config;
  final Page page;
  final Component child;

  @override
  Component build(BuildContext context) {
    // Add page type to main content class for styling
    var classes = <String>['flex-main'];

    // Get page type from frontmatter, default to 'post'
    final pageType = (page.data['page'] as Map?)?['page-type'] ?? 'post';

    // Add page type class for styling
    classes.add('$pageType-page');

    // Main content wrapper
    return div(classes: 'flex-content-wrapper', [
      // Main content
      main_(
        classes: classes.join(' '),
        [
          // Post header with title, date, author
          if ((page.data['page'] as Map?) //
              ?['title']
              case String title)
            PostHeader(
              config: config,
              page: page,
              child: child,
              title: title,
            ),

          // Post content
          child,

          // Post footer with categories and tags
          PostFooter(
            config: config,
            page: page,
            child: child,
          ),

          // Post navigation (Previous/Next) - only for blog posts
          if (pageType == 'post')
            PostNavigation(
              currentPage: page,
              allPages: context.pages,
            ),
        ],
      ),

      // Sidebar (if enabled)
      if (config.showSidebar)
        aside(
          classes: 'flex-sidebar',
          [
            Sidebar(),
          ],
        ),
    ]);
  }
}
