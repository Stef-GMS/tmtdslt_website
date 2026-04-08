import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';

/// Post navigation component (Previous/Next links)
class PostNavigation extends StatelessComponent {
  const PostNavigation({
    required this.currentPage,
    required this.allPages,
    super.key,
  });

  final Page currentPage;
  final List<Page> allPages;

  @override
  Component build(BuildContext context) {
    final posts = PostsFilter.publishedPosts(allPages);

    // Sort by date descending (newest first) using PostsFilter's sort method
    PostsFilter.sortByDate(posts);

    // Find current post index
    final currentIndex = posts.indexWhere((p) => p.url == currentPage.url);
    if (currentIndex == -1) {
      return div([]); // Return empty div if current post not found
    }

    // Posts are sorted newest first (descending)
    // Previous = older post (higher index, further down the list)
    // Next = newer post (lower index, closer to top of list)
    final previousPost = currentIndex < posts.length - 1 ? posts[currentIndex + 1] : null;
    final nextPost = currentIndex > 0 ? posts[currentIndex - 1] : null;

    if (previousPost == null && nextPost == null) {
      return div([]); // Return empty div if no navigation available
    }

    // Helper to get title from page
    String getTitle(Page page) {
      return (page.data['page'] as Map?)?['title'] as String? ?? 'Untitled';
    }

    return nav(classes: 'post-navigation', [
      if (previousPost != null)
        div(classes: 'nav-previous', [
          a(href: previousPost.url, [
            span(classes: 'nav-arrow', [Component.text('← ')]),
            span(classes: 'nav-label', [Component.text('Previous: ')]),
            span(classes: 'nav-title', [
              Component.text(_truncateTitle(getTitle(previousPost))),
            ]),
          ]),
        ]),
      if (nextPost != null)
        div(classes: 'nav-next', [
          a(href: nextPost.url, [
            span(classes: 'nav-label', [Component.text('Next: ')]),
            span(classes: 'nav-title', [
              Component.text(_truncateTitle(getTitle(nextPost))),
            ]),
            span(classes: 'nav-arrow', [Component.text(' →')]),
          ]),
        ]),
    ]);
  }

  String _truncateTitle(String title) {
    if (title.length <= postNavigationTitleLength) {
      return title;
    }
    return '${title.substring(0, postNavigationTitleLength)}...';
  }
}
