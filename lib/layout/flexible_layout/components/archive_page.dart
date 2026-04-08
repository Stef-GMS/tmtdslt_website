import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/dropdown_button.dart';
import 'package:tmtdslt/layout/flexible_layout/components/pagination.dart';
import 'package:tmtdslt/layout/flexible_layout/components/posts_grid.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/models/dropdown_type.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';

/// Archive page component - Displays posts for a specific month
///
/// This component reads year/month from frontmatter, filters posts
/// for that month, and passes them to PostsGrid for rendering.
class ArchivePage extends CustomComponent {
  const ArchivePage() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'ArchivePage')) {
      return const _ArchivePageComponent();
    }
    return null;
  }
}

/// Internal component that filters posts and renders the grid
class _ArchivePageComponent extends StatelessComponent {
  const _ArchivePageComponent();

  @override
  Component build(BuildContext context) {
    // Get current page to read year/month from frontmatter OR query parameters
    final page = context.page;
    final pageData = page.data['page'] as Map?;

    if (pageData == null) {
      return div([Component.text('Error: Page data not found')]);
    }

    // Try to get month slugs from URL query parameter first (/posts?m=2020-08,2020-09)
    // Otherwise fall back to frontmatter (year/month for single month pages)
    final uri = Uri.parse(page.url);
    final monthSlugsParam = uri.queryParameters['m'];
    final List<String> monthSlugs;

    if (monthSlugsParam != null && monthSlugsParam.isNotEmpty) {
      // Multi-select mode: Parse comma-separated month slugs from query parameter
      monthSlugs = monthSlugsParam.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    } else {
      // Single-select mode: Get year/month from frontmatter
      final yearValue = pageData['year'];
      final monthValue = pageData['month'];

      final year = yearValue is int ? yearValue.toString() : yearValue as String?;
      final month = monthValue is int ? monthValue.toString() : monthValue as String?;

      if (year == null || month == null) {
        return div([
          Component.text('Error: Year or month not specified in frontmatter'),
        ]);
      }
      monthSlugs = [month]; // month is already in YYYY-MM format from frontmatter
    }

    if (monthSlugs.isEmpty) {
      return div([Component.text('Error: No months specified')]);
    }

    // Get all pages and filter by month(s)
    final allPages = context.pages;
    final allPosts = monthSlugs.length == 1
        ? () {
            // Single month: Parse year and month from slug
            final parts = monthSlugs.first.split('-');
            if (parts.length >= 2) {
              final year = parts[0];
              final month = monthSlugs.first;
              return PostsFilter.byMonth(allPages, year, month);
            }
            return <Page>[];
          }()
        : PostsFilter.byMonths(allPages, monthSlugs);

    // Sort by date (newest first)
    PostsFilter.sortByDate(allPosts);

    // Get current page number from frontmatter (default to 1)
    final pageNumValue = pageData['page_num'];
    final currentPage = pageNumValue is int ? pageNumValue : 1;

    // Calculate pagination
    final totalPosts = allPosts.length;
    final totalPages = (totalPosts / postsPerPage).ceil();

    // Validate current page
    if (currentPage < 1 || (currentPage > totalPages && totalPages > 0)) {
      return div([
        Component.text('Error: Invalid page number'),
      ]);
    }

    // Slice posts for current page
    final startIndex = (currentPage - 1) * postsPerPage;
    final endIndex = (startIndex + postsPerPage).clamp(0, totalPosts);
    final postsForPage = allPosts.sublist(startIndex, endIndex);

    // Build base URL for pagination
    final baseUrl = monthSlugs.length == 1
        ? () {
            // Single month: /posts/2020/2020-08
            final parts = monthSlugs.first.split('-');
            if (parts.length >= 2) {
              final year = parts[0];
              final month = monthSlugs.first;
              return '/posts/$year/$month';
            }
            return '/posts';
          }()
        : '/posts?m=${monthSlugs.join(',')}'; // Multiple months: /posts?m=2020-08,2020-09

    // Build header text
    final headerText = monthSlugs.length == 1
        ? 'Posts from:' // Single month (dropdown will show the month)
        : 'Posts from: ${monthSlugs.join(', ')}'; // Multiple months

    // Render: Archive header with dropdown + Posts grid + Pagination
    return div([
      // Archive header with inline dropdown (styled like PostHeader)
      div(classes: 'flex-post-header', [
        if (monthSlugs.length > 1)
          // Multi-select: Show selected months in header
          h1(classes: 'flex-post-title', [Component.text(headerText)]),
        // Always show dropdown for navigation
        DropdownButton(type: DropdownType.archive, inline: true),
      ]),
      // Posts grid
      PostsGrid(
        posts: postsForPage,
        emptyMessage: 'No posts found for this month.',
      ),
      if (totalPages > 1)
        Pagination(
          currentPage: currentPage,
          totalPages: totalPages,
          baseUrl: baseUrl,
        ),
    ]);
  }
}
