import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';

/// Recent Posts content component
///
/// Returns only the list content (ul) - no wrapper
/// Meant to be wrapped by SidebarWidget in sidebar.dart
///
/// Displays a list of the most recent posts with title and link.
/// The number of posts to display is configurable via the constant in constants.dart.
class RecentPosts extends StatelessComponent {
  const RecentPosts({super.key});

  @override
  Component build(BuildContext context) {
    // Get all published posts (excludes pagination pages)
    final allPages = context.pages;
    final posts = PostsFilter.publishedPosts(allPages);

    if (posts.isEmpty) {
      return p([Component.text('No posts available.')]);
    }

    // Sort by date (newest first)
    PostsFilter.sortByDate(posts);

    // Take only the most recent posts
    final recentPosts = posts.take(recentPostsToShow).toList();

    // Return only the content (ul) - wrapper provided by sidebar.dart
    return ul(
      recentPosts.map((post) {
        final pageData = post.data['page'];
        final title = (pageData is Map ? pageData['title'] as String? : null) ?? 'Untitled';
        return li([
          a(
            href: post.url,
            [Component.text(title)],
          ),
        ]);
      }).toList(),
    );
  }
}
