import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Pagination component for archive, category, and tag pages
///
/// Displays numbered page links with Previous/Next navigation.
/// Follows WordPress pagination patterns.
class Pagination extends StatelessComponent {
  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.baseUrl,
    super.key,
  });

  final int currentPage;
  final int totalPages;
  final String baseUrl; // e.g., '/archive/2020-08' or '/category/technology'

  @override
  Component build(BuildContext context) {
    // Don't show pagination if only one page
    if (totalPages <= 1) {
      return div([]);
    }

    return nav(
      classes: 'pagination',
      attributes: {'aria-label': 'Pagination'},
      [
        div(classes: 'pagination-links', _buildPaginationLinks()),
      ],
    );
  }

  /// Build the list of pagination links
  List<Component> _buildPaginationLinks() {
    final links = <Component>[];

    // Previous link
    if (currentPage > 1) {
      links.add(
        _buildLink(
          url: _getPageUrl(currentPage - 1),
          text: '← Previous',
          classes: 'pagination-previous',
        ),
      );
    }

    // Page numbers
    final pageNumbers = _getPageNumbers();
    for (final pageNum in pageNumbers) {
      if (pageNum == -1) {
        // Ellipsis
        links.add(span(classes: 'pagination-ellipsis', [Component.text('…')]));
      } else if (pageNum == currentPage) {
        // Current page (not a link)
        links.add(
          span(
            classes: 'pagination-current',
            attributes: {'aria-current': 'page'},
            [Component.text(pageNum.toString())],
          ),
        );
      } else {
        // Page link
        links.add(
          _buildLink(
            url: _getPageUrl(pageNum),
            text: pageNum.toString(),
            classes: 'pagination-number',
          ),
        );
      }
    }

    // Next link
    if (currentPage < totalPages) {
      links.add(
        _buildLink(
          url: _getPageUrl(currentPage + 1),
          text: 'Next →',
          classes: 'pagination-next',
        ),
      );
    }

    return links;
  }

  /// Build a pagination link
  Component _buildLink({
    required String url,
    required String text,
    required String classes,
  }) {
    return a(
      href: url,
      classes: classes,
      [Component.text(text)],
    );
  }

  /// Get the URL for a specific page number
  String _getPageUrl(int pageNum) {
    if (pageNum == 1) {
      // First page doesn't have /page/1/ suffix
      return baseUrl;
    }
    //print('getPageUrl: $baseUrl/page/$pageNum/');
    return '$baseUrl/page/$pageNum/';
  }

  /// Get the list of page numbers to display
  /// Returns -1 for ellipsis
  List<int> _getPageNumbers() {
    // Always show first page, last page, current page, and 2 pages on each side of current
    // Example: 1 ... 4 5 [6] 7 8 ... 20

    final pages = <int>[];

    if (totalPages <= 7) {
      // Show all pages if 7 or fewer
      for (var i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      // Always show first page
      pages.add(1);

      // Calculate range around current page
      var start = currentPage - 2;
      var end = currentPage + 2;

      // Add ellipsis after first page if needed
      if (start > 2) {
        pages.add(-1); // Ellipsis
      }

      // Adjust range to always show 5 pages in the middle
      if (start < 2) {
        start = 2;
        end = 6;
      }
      if (end > totalPages - 1) {
        end = totalPages - 1;
        start = totalPages - 5;
      }

      // Add middle pages
      for (var i = start; i <= end; i++) {
        if (i > 1 && i < totalPages) {
          pages.add(i);
        }
      }

      // Add ellipsis before last page if needed
      if (end < totalPages - 1) {
        pages.add(-1); // Ellipsis
      }

      // Always show last page
      if (totalPages > 1) {
        pages.add(totalPages);
      }
    }

    return pages;
  }
}
