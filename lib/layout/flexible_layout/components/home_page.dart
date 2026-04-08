import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/pagination.dart';
import 'package:tmtdslt/layout/flexible_layout/components/posts_grid.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';

/// Home page component - Displays recent posts
///
/// This component filters all published posts, sorts them by date,
/// and passes the most recent ones to PostsGrid for rendering.
class HomePage extends CustomComponent {
  const HomePage({
    this.rows = 10,
  }) : super.base();

  final int rows;

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'HomePage', :final attributes)) {
      final rowsAttr = attributes['rows'];
      final rowsCount = rowsAttr != null ? int.tryParse(rowsAttr) ?? rows : rows;
      return _HomePageComponent(rows: rowsCount);
    }

    return null;
  }
}

/// Internal component that filters posts and renders the grid
class _HomePageComponent extends StatelessComponent {
  const _HomePageComponent({
    required this.rows,
  });

  final int rows;

  @override
  Component build(BuildContext context) {
    final allPages = context.pages;

    // Filter for published posts
    final posts = PostsFilter.publishedPosts(allPages);

    // Sort by date (newest first)
    PostsFilter.sortByDate(posts);

    // Get current page number from frontmatter (default: 1)
    final pageData = context.page.data['page'] as Map?;
    final currentPage = (pageData?['page_num'] as int?) ?? 1;

    // Calculate pagination
    final totalPosts = posts.length;
    final totalPages = (totalPosts / postsPerPage).ceil();

    // Slice posts for current page
    final startIndex = (currentPage - 1) * postsPerPage;
    final endIndex = (startIndex + postsPerPage).clamp(0, totalPosts);
    final postsForPage = posts.sublist(startIndex, endIndex);

    // Build base URL for pagination
    // Page 1: / (baseUrl with no trailing slash)
    // Page 2+: /page/2, /page/3, etc. (Pagination adds '/page/N/')
    final baseUrl = '';

    // Render using PostsGrid with Pagination
    return div([
      PostsGrid(
        posts: postsForPage,
        emptyMessage: 'No posts available yet.',
      ),
      // Pagination (only show if more than 1 page)
      if (totalPages > 1)
        Pagination(
          currentPage: currentPage,
          totalPages: totalPages,
          baseUrl: baseUrl,
        ),
    ]);
  }
}
