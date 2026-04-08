/// Dropdown item model for DropdownButton component
///
/// Represents a single item in the dropdown list with:
/// - value: Unique identifier (slug, month code, etc.)
/// - label: Display text (name)
/// - count: Number of posts
/// - url: Target URL for navigation
class DropdownItem {
  const DropdownItem({
    required this.value,
    required this.label,
    required this.count,
    required this.url,
  });

  /// Unique identifier (e.g., "cucumber", "2020-08", "adorable")
  final String value;

  /// Display text (e.g., "Cucumber", "August 2020", "Adorable")
  final String label;

  /// Number of posts with this item
  final int count;

  /// Target URL for navigation
  final String url;

  /// Display text with count in format "Label (count)"
  String get displayText => '$label ($count)';
}

