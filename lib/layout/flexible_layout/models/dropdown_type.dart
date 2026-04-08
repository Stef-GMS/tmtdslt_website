/// Dropdown type enum for DropdownButton component
///
/// Defines the type of dropdown to display, which controls:
/// - Header text (sidebar mode)
/// - Label text (inline mode)
/// - Placeholder text
/// - URL pattern for navigation
/// - Data source for items
enum DropdownType {
  /// Archive dropdown (months/years)
  archive,

  /// Tag dropdown (post tags)
  tag,

  /// Category dropdown (post categories)
  category,
}

/// Extension for DropdownType to provide type-specific strings
extension DropdownTypeExtension on DropdownType {
  /// Header text for sidebar mode
  String get header {
    switch (this) {
      case DropdownType.archive:
        return 'Archives';
      case DropdownType.tag:
        return 'Tags';
      case DropdownType.category:
        return 'Categories';
    }
  }

  /// Label text for inline mode
  String get label {
    switch (this) {
      case DropdownType.archive:
        return 'Posts from:';
      case DropdownType.tag:
        return 'Posts tagged:';
      case DropdownType.category:
        return 'Category:';
    }
  }

  /// Placeholder text when no selection
  String get placeholder {
    switch (this) {
      case DropdownType.archive:
        return 'Select Month...';
      case DropdownType.tag:
        return 'Select a tag...';
      case DropdownType.category:
        return 'Select a category...';
    }
  }

  /// Query parameter key for multi-select URLs
  String get queryParamKey {
    switch (this) {
      case DropdownType.archive:
        return 'm'; // /posts?m=2020-08,2020-09
      case DropdownType.tag:
        return 't'; // /tags?t=cucumber,garden
      case DropdownType.category:
        return 'c'; // /categories?c=adorable,garden
    }
  }

  /// Base path for multi-select URLs
  String get multiSelectBasePath {
    switch (this) {
      case DropdownType.archive:
        return '/posts';
      case DropdownType.tag:
        return '/tags';
      case DropdownType.category:
        return '/categories';
    }
  }

  /// Generate URL for multi-select (list of slugs)
  String buildMultiSelectUrl(List<String> slugs) {
    if (slugs.isEmpty) {
      return '/'; // "All" - redirect to home
    }
    if (slugs.length == 1) {
      // Single selection - use original URL pattern
      return buildSingleSelectUrl(slugs.first);
    }
    // Multiple selections - use query parameter
    final slugsParam = slugs.join(',');
    return '$multiSelectBasePath?$queryParamKey=$slugsParam';
  }

  /// Generate URL for single selection
  String buildSingleSelectUrl(String slug) {
    switch (this) {
      case DropdownType.archive:
        // Extract year and month from slug (e.g., "2020-08")
        final parts = slug.split('-');
        if (parts.length >= 2) {
          final year = parts[0];
          final yearMonth = slug;
          return '/posts/$year/$yearMonth';
        }
        return '/posts';
      case DropdownType.tag:
        return '/tag/$slug';
      case DropdownType.category:
        return '/category/$slug';
    }
  }
}
