/// Tag data model for tag cloud visualization
class TagData {
  const TagData({
    required this.name,
    required this.slug,
    required this.postCount,
    required this.fontSize,
  });

  final String name; // Display name (e.g., "Cucumber")
  final String slug; // URL slug (e.g., "cucumber")
  final int postCount; // Number of posts with this tag
  final double fontSize; // Calculated font size (8-22px)

  /// Create slug from tag name (case-insensitive, spaces to hyphens)
  static String slugify(String name) {
    return name.toLowerCase().trim().replaceAll(RegExp(r'\s+'), '-');
  }

  @override
  String toString() =>
      'TagData($name, $slug, count: $postCount, size: ${fontSize}px)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagData &&
          runtimeType == other.runtimeType &&
          slug == other.slug;

  @override
  int get hashCode => slug.hashCode;
}

