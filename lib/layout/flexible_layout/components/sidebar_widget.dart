import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Sidebar widget wrapper component
///
/// Provides consistent styling for all sidebar widgets:
/// - White background box
/// - Padding
/// - Bottom margin
///
/// Usage:
/// ```dart
/// SidebarWidget(
///   title: 'Recent Posts',
///   children: [
///     // widget content
///   ],
/// )
/// ```
class SidebarWidget extends StatelessComponent {
  const SidebarWidget({
    super.key,
    required this.title,
    required this.children,
    this.additionalClasses,
    this.showHorizontalLine = false,
    this.titleUrl,
  });

  /// Widget title (displayed as h3)
  final String title;

  /// Widget content
  final List<Component> children;

  /// Additional CSS classes (optional)
  final String? additionalClasses;

  /// Whether to show horizontal line under title
  final bool showHorizontalLine;

  /// Optional URL to make title clickable
  final String? titleUrl;

  @override
  Component build(BuildContext context) {
    // Build CSS classes
    var classes = 'flex-widget';
    if (showHorizontalLine) {
      classes += ' sidebar-widget-with-line';
    }
    if (additionalClasses != null) {
      classes += ' $additionalClasses';
    }

    // Build h3 content (with or without link)
    final h3Content = titleUrl != null
        ? [
            a(href: titleUrl!, [Component.text(title)]),
          ]
        : [Component.text(title)];

    return div(classes: classes, [
      h3(h3Content),
      ...children,
    ]);
  }
}
