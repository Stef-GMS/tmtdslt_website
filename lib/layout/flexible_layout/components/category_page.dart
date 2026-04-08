import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/dropdown_button.dart';
import 'package:tmtdslt/layout/flexible_layout/components/pagination.dart';
import 'package:tmtdslt/layout/flexible_layout/components/posts_grid.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/models/dropdown_type.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';

/// Category page component - Displays posts for a specific category
///
/// This component reads category_slug from frontmatter, filters posts
/// for that category, and passes them to PostsGrid for rendering.
class CategoryPage extends CustomComponent {
  const CategoryPage() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node case ElementNode(tag: 'CategoryPage')) {
      return const _CategoryPageComponent();
    }
    return null;
  }
}

/// Internal component that filters posts and renders the grid
class _CategoryPageComponent extends StatelessComponent {
  const _CategoryPageComponent();

  @override
  Component build(BuildContext context) {
    // Get current page to read category_slug from frontmatter OR query parameters
    final page = context.page;
    final pageData = page.data['page'] as Map?;

    if (pageData == null) {
      return div([Component.text('Error: Page data not found')]);
    }

    // Try to get category slugs from URL query parameter first (/categories?c=adorable,garden)
    // Otherwise fall back to frontmatter (category_slug for single category pages)
    final uri = Uri.parse(page.url);
    final categorySlugsParam = uri.queryParameters['c'];
    final List<String> categorySlugs;

    if (categorySlugsParam != null && categorySlugsParam.isNotEmpty) {
      // Multi-select mode: Parse comma-separated category slugs from query parameter
      categorySlugs = categorySlugsParam.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    } else {
      // Single-select mode: Get category_slug from frontmatter
      final categorySlug = pageData['category_slug'] as String?;
      if (categorySlug == null) {
        return div([
          Component.text('Error: category_slug not specified in frontmatter'),
        ]);
      }
      categorySlugs = [categorySlug];
    }

    if (categorySlugs.isEmpty) {
      return div([Component.text('Error: No categories specified')]);
    }

    // Get all pages and filter by category(ies)
    final allPages = context.pages;
    final allPosts = categorySlugs.length == 1
        ? PostsFilter.byCategory(allPages, categorySlugs.first)
        : PostsFilter.byCategories(allPages, categorySlugs);

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
    final baseUrl = categorySlugs.length == 1
        ? '/category/${categorySlugs.first}' // Single category: /category/adorable
        : '/categories?c=${categorySlugs.join(',')}'; // Multiple categories: /categories?c=adorable,garden

    // Build header text
    final headerText = categorySlugs.length == 1
        ? 'Posts in category:' // Single category (dropdown will show the category)
        : 'Posts in categories: ${categorySlugs.join(', ')}'; // Multiple categories

    // Render: Category header with dropdown + Posts grid + Pagination
    return div([
      // Category header with inline dropdown (styled like PostHeader)
      div(classes: 'flex-post-header', [
        if (categorySlugs.length > 1)
          // Multi-select: Show selected categories in header
          h1(classes: 'flex-post-title', [Component.text(headerText)]),
        // Always show dropdown for navigation
        DropdownButton(type: DropdownType.category, inline: true),
      ]),
      // Posts grid
      PostsGrid(
        posts: postsForPage,
        emptyMessage: 'No posts found in this category.',
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
