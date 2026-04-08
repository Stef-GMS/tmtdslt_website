import 'package:jaspr/jaspr.dart';
import 'package:tmtdslt/layout/flexible_layout/components/dropdown_button.dart';
import 'package:tmtdslt/layout/flexible_layout/components/recent_posts.dart';
import 'package:tmtdslt/layout/flexible_layout/components/sidebar_widget.dart';
import 'package:tmtdslt/layout/flexible_layout/components/tag_cloud.dart';
import 'package:tmtdslt/layout/flexible_layout/models/dropdown_type.dart';

/// Sidebar - Parent component for all sidebar widgets
///
/// This component renders all sidebar widgets in order.
/// To add, remove, or reorder widgets, simply modify the list below.
///
/// Example:
///   - To add a new widget: Import it and add it to the list
///   - To remove a widget: Comment out or delete the line
///   - To reorder: Move the lines up or down
class Sidebar extends StatelessComponent {
  const Sidebar({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      // Recent Posts widget
      SidebarWidget(
        title: 'Recent Posts',
        additionalClasses: 'flex-recent-posts',
        showHorizontalLine: false,
        children: [
          RecentPosts(),
        ],
      ),

      // Archives dropdown widget
      SidebarWidget(
        title: 'Archives',
        additionalClasses: 'flex-archive',
        showHorizontalLine: false,
        children: [
          DropdownButton(type: DropdownType.archive),
        ],
      ),

      // Categories dropdown widget
      SidebarWidget(
        title: 'Categories',
        additionalClasses: 'flex-category-dropdown',
        showHorizontalLine: false,
        children: [
          DropdownButton(type: DropdownType.category),
        ],
      ),

      // Tags dropdown widget
      SidebarWidget(
        title: 'Tags',
        additionalClasses: 'flex-tag-dropdown',
        showHorizontalLine: false,
        children: [
          DropdownButton(type: DropdownType.tag),
        ],
      ),

      // Tag Cloud widget (with clickable title linking to /tags/)
      SidebarWidget(
        title: 'Tags',
        titleUrl: '/tags/',
        additionalClasses: 'flex-tag-cloud',
        showHorizontalLine: false,
        children: [
          TagCloud(),
        ],
      ),
    ]);
  }
}
