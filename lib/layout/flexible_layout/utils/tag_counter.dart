import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/models/tag_data.dart';
import 'package:yaml/yaml.dart';

/// Utility for counting tags across posts and calculating font sizes
class TagCounter {
  /// Count all tags from posts and return TagData list
  ///
  /// - Case-insensitive tag counting
  /// - Alphabetically sorted
  /// - Font sizes calculated based on post count (8-22px)
  /// - Limited to [maxTags] (default: 45)
  static List<TagData> countTags(
    List<Page> posts, {
    int maxTags = 45,
  }) {
    // Count tags (case-insensitive)
    final tagCounts = <String, int>{};

    for (final post in posts) {
      final frontmatter = post.data['page'] as Map?;
      if (frontmatter == null) continue;

      final tags = frontmatter['tags'];
      if (tags is! YamlList && tags is! List) continue;

      for (final tag in tags) {
        final tagName = tag.toString();
        final slug = TagData.slugify(tagName);
        tagCounts[slug] = (tagCounts[slug] ?? 0) + 1;
      }
    }

    // No tags found
    if (tagCounts.isEmpty) return [];

    // Find min/max counts for font size calculation
    final counts = tagCounts.values.toList();
    final minCount = counts.reduce((a, b) => a < b ? a : b);
    final maxCount = counts.reduce((a, b) => a > b ? a : b);

    // Create TagData list with calculated font sizes
    final tagDataList = tagCounts.entries.map((entry) {
      final slug = entry.key;
      final count = entry.value;
      final fontSize = _calculateFontSize(count, minCount, maxCount);

      // Capitalize first letter for display name
      final name = slug
          .split('-')
          .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
          .join(' ');

      return TagData(
        name: name,
        slug: slug,
        postCount: count,
        fontSize: fontSize,
      );
    }).toList();

    // Sort alphabetically by name
    tagDataList.sort((a, b) => a.name.compareTo(b.name));

    // Sort by post count (descending) to get top N tags
    tagDataList.sort((a, b) => b.postCount.compareTo(a.postCount));

    // Limit to maxTags (top N by popularity)
    final topTags = tagDataList.take(maxTags).toList();

    // Re-sort alphabetically for display
    topTags.sort((a, b) => a.name.compareTo(b.name));

    return topTags;
  }

  /// Calculate font size based on post count
  ///
  /// Linear interpolation between 12px (min) and 24px (max)
  /// Font sizes defined in FlexTheme: tagCloudMinFontSize, tagCloudMaxFontSize
  static double _calculateFontSize(
    int count,
    int minCount,
    int maxCount,
  ) {
    const minSize = 12.0;
    const maxSize = 24.0;

    // If all tags have same count, use minimum size
    if (maxCount == minCount) return minSize;

    // Linear interpolation
    return minSize + ((count - minCount) / (maxCount - minCount)) * (maxSize - minSize);
  }
}
