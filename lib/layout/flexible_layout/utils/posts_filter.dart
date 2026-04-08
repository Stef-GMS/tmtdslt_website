import 'package:jaspr_content/jaspr_content.dart';

/// Utility class for filtering and sorting posts
///
/// This provides shared filtering logic used by PostsGrid, ArchivePage,
/// CategoryPage, TagPage, etc.
class PostsFilter {
  /// Filter for published posts only
  static List<Page> publishedPosts(List<Page> allPages) {
    return allPages.where((page) {
      if (!page.url.startsWith('/posts/')) return false;
      final pageData = page.data['page'];
      if (pageData is! Map) return false;
      final published = pageData['published'];
      return published ==
              true //
              ||
          published == 'true';
    }).toList();
  }

  /// Filter posts by year and month
  static List<Page> byMonth(List<Page> allPages, String year, String month) {
    final published = publishedPosts(allPages);

    return published.where((p) {
      final pageData = p.data['page'];
      if (pageData is! Map) return false;

      final dateStr = pageData['date'] as String?;
      if (dateStr == null) return false;

      try {
        final date = DateTime.parse(dateStr);
        final postYear = date.year.toString();
        final postMonth = '${date.year}-${date.month.toString().padLeft(2, '0')}';

        // Match both year and month
        return postYear == year && postMonth == month;
      } catch (e) {
        // Skip posts with invalid dates
        return false;
      }
    }).toList();
  }

  /// Filter posts by category
  static List<Page> byCategory(List<Page> allPages, String category) {
    final published = publishedPosts(allPages);

    return published.where((p) {
      final pageData = p.data['page'];
      if (pageData is! Map) return false;

      final categories = (pageData['categories'] as List?)?.cast<String>() ?? [];
      return categories.any((c) => c.toLowerCase().replaceAll(' ', '-') == category.toLowerCase());
    }).toList();
  }

  /// Filter posts by tag
  static List<Page> byTag(List<Page> allPages, String tag) {
    final published = publishedPosts(allPages);

    return published.where((p) {
      final pageData = p.data['page'];
      if (pageData is! Map) return false;

      final tags = (pageData['tags'] as List?)?.cast<String>() ?? [];
      return tags.any((t) => t.toLowerCase().replaceAll(' ', '-') == tag.toLowerCase());
    }).toList();
  }

  /// Filter posts by multiple months (OR logic)
  /// Returns posts from ANY of the specified months
  static List<Page> byMonths(List<Page> allPages, List<String> monthSlugs) {
    if (monthSlugs.isEmpty) return publishedPosts(allPages);
    if (monthSlugs.length == 1) {
      // Single month - use original byMonth method
      final parts = monthSlugs.first.split('-');
      if (parts.length >= 2) {
        final year = parts[0];
        final month = monthSlugs.first;
        return byMonth(allPages, year, month);
      }
    }

    final published = publishedPosts(allPages);

    return published.where((p) {
      final pageData = p.data['page'];
      if (pageData is! Map) return false;

      final dateStr = pageData['date'] as String?;
      if (dateStr == null) return false;

      try {
        final date = DateTime.parse(dateStr);
        final postMonth = '${date.year}-${date.month.toString().padLeft(2, '0')}';

        // Match ANY of the specified months (OR logic)
        return monthSlugs.contains(postMonth);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Filter posts by multiple tags (OR logic)
  /// Returns posts with ANY of the specified tags
  static List<Page> byTags(List<Page> allPages, List<String> tagSlugs) {
    if (tagSlugs.isEmpty) return publishedPosts(allPages);
    if (tagSlugs.length == 1) {
      // Single tag - use original byTag method
      return byTag(allPages, tagSlugs.first);
    }

    final published = publishedPosts(allPages);

    return published.where((p) {
      final pageData = p.data['page'];
      if (pageData is! Map) return false;

      final tags = (pageData['tags'] as List?)?.cast<String>() ?? [];

      // Convert tags to slugs and check if ANY match (OR logic)
      return tags.any((t) {
        final tagSlug = t.toLowerCase().replaceAll(' ', '-');
        return tagSlugs.contains(tagSlug);
      });
    }).toList();
  }

  /// Filter posts by multiple categories (OR logic)
  /// Returns posts with ANY of the specified categories
  static List<Page> byCategories(List<Page> allPages, List<String> categorySlugs) {
    if (categorySlugs.isEmpty) return publishedPosts(allPages);
    if (categorySlugs.length == 1) {
      // Single category - use original byCategory method
      return byCategory(allPages, categorySlugs.first);
    }

    final published = publishedPosts(allPages);

    return published.where((p) {
      final pageData = p.data['page'];
      if (pageData is! Map) return false;

      final categories = (pageData['categories'] as List?)?.cast<String>() ?? [];

      // Convert categories to slugs and check if ANY match (OR logic)
      return categories.any((c) {
        final categorySlug = c.toLowerCase().replaceAll(' ', '-');
        return categorySlugs.contains(categorySlug);
      });
    }).toList();
  }

  /// Sort posts by date (newest first)
  static void sortByDate(List<Page> posts) {
    posts.sort((pageA, pageB) {
      try {
        final pageDataA = pageA.data['page'] as Map?;
        final pageDataB = pageB.data['page'] as Map?;
        final dateA = pageDataA?['date'] as String?;
        final dateB = pageDataB?['date'] as String?;
        if (dateA == null || dateB == null) return 0;
        return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
      } catch (e) {
        return 0;
      }
    });
  }
}
