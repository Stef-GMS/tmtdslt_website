import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/dropdown_button.dart';
import 'package:tmtdslt/layout/flexible_layout/components/pagination.dart';
import 'package:tmtdslt/layout/flexible_layout/components/posts_grid.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/models/dropdown_type.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';

/// Tag page component - Displays posts for a specific tag
///
/// This component reads tag_slug from frontmatter, filters posts
/// for that tag, and displays them with PostsGrid.
/// Includes TagDropdown at the top for switching between tags.
class TagPage extends CustomComponent {
  const TagPage() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'TagPage')) {
      return const _TagPageComponent();
    }
    return null;
  }
}

/// Internal component that filters posts and renders the grid
class _TagPageComponent extends StatelessComponent {
  const _TagPageComponent();

  @override
  Component build(BuildContext context) {
    // Get current page to read tag_slug from frontmatter OR query parameters
    final page = context.page;
    final pageData = page.data['page'] as Map?;

    if (pageData == null) {
      return div([Component.text('Error: Page data not found')]);
    }

    // Try to get tag slugs from URL query parameter first (/tags?t=cucumber,garden)
    // Otherwise fall back to frontmatter (tag_slug for single tag pages)
    final uri = Uri.parse(page.url);
    final tagSlugsParam = uri.queryParameters['t'];
    final List<String> tagSlugs;

    if (tagSlugsParam != null && tagSlugsParam.isNotEmpty) {
      // Multi-select mode: Parse comma-separated tag slugs from query parameter
      tagSlugs = tagSlugsParam.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    } else {
      // Single-select mode: Get tag_slug from frontmatter
      final tagSlug = pageData['tag_slug'] as String?;
      if (tagSlug == null) {
        return div([
          Component.text('Error: tag_slug not specified in frontmatter'),
        ]);
      }
      tagSlugs = [tagSlug];
    }

    if (tagSlugs.isEmpty) {
      return div([Component.text('Error: No tags specified')]);
    }

    // Get all pages and filter by tag(s)
    final allPages = context.pages;
    final allPosts = tagSlugs.length == 1
        ? PostsFilter.byTag(allPages, tagSlugs.first)
        : PostsFilter.byTags(allPages, tagSlugs);

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
    final baseUrl = tagSlugs.length == 1
        ? '/tag/${tagSlugs.first}' // Single tag: /tag/cucumber
        : '/tags?t=${tagSlugs.join(',')}'; // Multiple tags: /tags?t=cucumber,garden

    // Build header text
    final headerText = tagSlugs.length == 1
        ? 'Posts tagged with:' // Single tag (dropdown will show the tag)
        : 'Posts tagged with: ${tagSlugs.join(', ')}'; // Multiple tags

    // Render: Tag header with dropdown + Posts grid + Pagination
    return div([
      // Tag header with inline dropdown (styled like PostHeader)
      div(classes: 'flex-post-header', [
        if (tagSlugs.length > 1)
          // Multi-select: Show selected tags in header
          h1(classes: 'flex-post-title', [Component.text(headerText)]),
        // Always show dropdown for navigation
        DropdownButton(type: DropdownType.tag, inline: true),
      ]),
      // Posts grid
      PostsGrid(
        posts: postsForPage,
        emptyMessage: 'No posts found with this tag.',
      ),
      // Pagination
      if (totalPages > 1)
        Pagination(
          currentPage: currentPage,
          totalPages: totalPages,
          baseUrl: baseUrl,
        ),
    ]);
  }
}
