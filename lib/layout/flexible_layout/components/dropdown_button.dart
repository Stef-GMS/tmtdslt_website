import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/models/dropdown_item.dart';
import 'package:tmtdslt/layout/flexible_layout/models/dropdown_type.dart';
import 'package:tmtdslt/layout/flexible_layout/models/menu_bar_tab_types.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/tag_counter.dart';

/// Unified dropdown component for archives, tags, and categories
///
/// This component consolidates the functionality of:
/// - ArchiveDropdown
/// - TagDropdown
/// - CategoryDropdown
///
/// Usage:
/// ```dart
/// // Sidebar mode
/// DropdownButton(type: DropdownType.archive)
/// DropdownButton(type: DropdownType.tag)
/// DropdownButton(type: DropdownType.category)
///
/// // Inline mode (on archive/tag/category pages)
/// DropdownButton(type: DropdownType.archive, inline: true)
/// DropdownButton(type: DropdownType.tag, inline: true)
/// DropdownButton(type: DropdownType.category, inline: true)
///
/// // Multi-select mode (with checkboxes)
/// DropdownButton(type: DropdownType.tag, multiSelect: true)
/// ```
class DropdownButton extends StatefulComponent {
  const DropdownButton({
    super.key,
    required this.type,
    this.inline = false,
    this.multiSelect = false,
  });

  /// Type of dropdown (archive, tag, or category)
  final DropdownType type;

  /// Whether to display in inline mode (with label) or sidebar mode (with header)
  final bool inline;

  /// Whether to enable multi-select mode with checkboxes
  final bool multiSelect;

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  // Selected items for multi-select mode
  Set<String> selectedItems = {};
  bool isDropdownOpen = false;

  @override
  Component build(BuildContext context) {
    // Get all pages
    final allPages = context.pages;

    // Fetch items and current selection based on type
    final items = _getItems(allPages, component.type);
    final currentSelection = _getCurrentSelection(context.page.url, component.type);

    // Handle empty state
    if (items.isEmpty) {
      return div(
        classes: component.inline ? 'dropdown-inline' : 'dropdown-sidebar',
        [
          if (component.inline) span(classes: 'dropdown-label', [Component.text(component.type.label)]),
          p([Component.text('No items available.')]),
        ],
      );
    }

    // Choose rendering mode based on multiSelect parameter
    if (component.multiSelect) {
      return _buildCheckboxDropdown(context, items);
    } else {
      return _buildSelectDropdown(items, currentSelection);
    }
  }

  /// Build traditional <select> dropdown (single-select mode)
  Component _buildSelectDropdown(
    List<DropdownItem> items,
    String? currentSelection,
  ) {
    return div(
      classes: component.inline ? 'dropdown-inline' : 'dropdown-sidebar',
      [
        if (component.inline) span(classes: 'dropdown-label', [Component.text(component.type.label)]),
        select(
          classes: 'dropdown-select',
          attributes: {
            'onchange': 'window.location.href=this.value',
          },
          [
            // Placeholder option (only if no current selection)
            if (currentSelection == null)
              option(
                value: '',
                attributes: {
                  'selected': 'selected',
                  'disabled': 'disabled',
                },
                [Component.text(component.type.placeholder)],
              ),
            // Dropdown items
            for (var item in items)
              option(
                value: item.url,
                attributes: {
                  if (item.value == currentSelection) 'selected': 'selected',
                },
                [Component.text(item.displayText)],
              ),
          ],
        ),
      ],
    );
  }

  /// Build checkbox dropdown (multi-select mode)
  Component _buildCheckboxDropdown(
    BuildContext context,
    List<DropdownItem> items,
  ) {
    return div(
      classes: component.inline ? 'dropdown-inline-multi' : 'dropdown-sidebar-multi',
      [
        // Header (sidebar mode) or Label (inline mode)
        if (!component.inline)
          div(classes: 'dropdown-header', [
            Component.text(component.type.header),
          ]),
        if (component.inline) span(classes: 'dropdown-label', [Component.text(component.type.label)]),

        // Checkbox dropdown container
        div(
          classes: 'checkbox-dropdown',
          [
            // "All" checkbox
            label(
              classes: 'checkbox-item',
              [
                input(
                  type: InputType.checkbox,
                  id: 'checkbox-all',
                  checked: selectedItems.isEmpty,
                  onChange: (_) {
                    setState(() {
                      selectedItems.clear();
                    });
                  },
                ),
                Component.text(' All'),
              ],
            ),

            // Individual item checkboxes
            for (var item in items)
              label(
                classes: 'checkbox-item',
                [
                  input(
                    type: InputType.checkbox,
                    id: 'checkbox-${item.value}',
                    checked: selectedItems.contains(item.value),
                    onChange: (_) {
                      setState(() {
                        if (selectedItems.contains(item.value)) {
                          selectedItems.remove(item.value);
                        } else {
                          selectedItems.add(item.value);
                        }
                      });
                    },
                  ),
                  Component.text(' ${item.displayText}'),
                ],
              ),

            // Apply button
            a(
              href: component.type.buildMultiSelectUrl(selectedItems.toList()),
              classes: 'apply-button',
              [Component.text('Apply')],
            ),
          ],
        ),
      ],
    );
  }

  /// Get dropdown items based on type
  List<DropdownItem> _getItems(List<Page> allPages, DropdownType type) {
    switch (type) {
      case DropdownType.archive:
        return _getArchiveItems(allPages);
      case DropdownType.tag:
        return _getTagItems(allPages);
      case DropdownType.category:
        return _getCategoryItems(allPages);
    }
  }

  /// Get current selection from URL based on type
  String? _getCurrentSelection(String url, DropdownType type) {
    switch (type) {
      case DropdownType.archive:
        return _getCurrentMonth(url);
      case DropdownType.tag:
        return _getCurrentTag(url);
      case DropdownType.category:
        return _getCurrentCategory(url);
    }
  }

  /// Get archive items (months with post counts)
  List<DropdownItem> _getArchiveItems(List<Page> allPages) {
    final posts = PostsFilter.publishedPosts(allPages);

    // Count posts per month
    final monthCounts = <String, int>{};
    for (final post in posts) {
      final postData = post.data['page'] as Map?;
      if (postData == null) continue;

      final date = postData['date'] as String?;
      if (date == null) continue;

      try {
        final dateTime = DateTime.parse(date);
        final yearMonth = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}';
        monthCounts[yearMonth] = (monthCounts[yearMonth] ?? 0) + 1;
      } catch (e) {
        // Skip invalid dates
        continue;
      }
    }

    // Convert to DropdownItem list
    final items = monthCounts.entries.map((entry) {
      final yearMonth = entry.key;
      final count = entry.value;
      final parts = yearMonth.split('-');
      final year = parts[0];

      return DropdownItem(
        value: yearMonth,
        label: yearMonth,
        count: count,
        url: '/posts/$year/$yearMonth/',
      );
    }).toList();

    // Sort by date (newest first)
    items.sort((item1, item2) => item2.value.compareTo(item1.value));

    return items;
  }

  /// Get tag items (tags with post counts)
  List<DropdownItem> _getTagItems(List<Page> allPages) {
    final posts = PostsFilter.publishedPosts(allPages);

    // Get all tags with counts (no limit)
    final tagData = TagCounter.countTags(posts, maxTags: 999);

    // Filter by minimum post count and convert to DropdownItem list
    return tagData.where((tag) => tag.postCount >= minPostsPerTag).map((tag) {
      return DropdownItem(
        value: tag.slug,
        label: tag.name,
        count: tag.postCount,
        url: '/tag/${tag.slug}',
      );
    }).toList();
  }

  /// Get category items (categories with post counts)
  List<DropdownItem> _getCategoryItems(List<Page> allPages) {
    // Get all displayed categories from MenuBarTab
    final categories = MenuBarTab.displayedTopLevel.where((tab) => tab.type == MenuBarTabType.category).toList();

    // Count posts per category
    final items = <DropdownItem>[];
    for (final category in categories) {
      final posts = PostsFilter.byCategory(allPages, category.slug);
      items.add(
        DropdownItem(
          value: category.slug,
          label: category.name,
          count: posts.length,
          url: category.path,
        ),
      );
    }

    return items;
  }

  /// Extract current month from archive URL
  /// URL pattern: /posts/YYYY/YYYY-MM/ or /posts/YYYY/YYYY-MM/page/N/
  String? _getCurrentMonth(String url) {
    final match = RegExp(r'^/posts/\d{4}/(\d{4}-\d{2})(?:/.*)?$').firstMatch(url);
    return match?.group(1);
  }

  /// Extract current tag slug from tag URL
  /// URL pattern: /tag/slug or /tag/slug/page/N/
  String? _getCurrentTag(String url) {
    final match = RegExp(r'^/tag/([^/]+)(?:/.*)?$').firstMatch(url);
    return match?.group(1);
  }

  /// Extract current category slug from category URL
  /// URL pattern: /category/slug or /category/slug/page/N/
  String? _getCurrentCategory(String url) {
    final match = RegExp(r'^/category/([^/]+)(?:/.*)?$').firstMatch(url);
    return match?.group(1);
  }
}
