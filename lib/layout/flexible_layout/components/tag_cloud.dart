import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/posts_filter.dart';
import 'package:tmtdslt/layout/flexible_layout/utils/tag_counter.dart';

/// Tag Cloud content component
///
/// Returns only the tag cloud content (div) - no wrapper
/// Meant to be wrapped by SidebarWidget in sidebar.dart
///
/// Displays tags with font sizes based on post count (12-24px range)
/// Limited to maxTagsInCloud, alphabetically sorted
/// Dyslexia-friendly spacing
class TagCloud extends StatelessComponent {
  const TagCloud({super.key});

  @override
  Component build(BuildContext context) {
    // Get all pages and filter to published posts only
    final allPages = context.pages;
    final posts = PostsFilter.publishedPosts(allPages);

    // Count tags and calculate font sizes
    final tagData = TagCounter.countTags(posts, maxTags: maxTagsInCloud);

    // No tags to display
    if (tagData.isEmpty) {
      return p([Component.text('No tags found.')]);
    }

    // Return only the content (div) - wrapper provided by sidebar.dart
    return div(
      classes: 'tag-cloud-content',
      [
        for (final tag in tagData)
          a(
            href: '/tag/${tag.slug}',
            styles: Styles(
              raw: {
                'font-size': '${tag.fontSize.toStringAsFixed(0)}px',
              },
            ),
            [Component.text(tag.name)],
          ),
      ],
    );
  }
}
