import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/post_categories.dart';
import 'package:tmtdslt/layout/flexible_layout/components/post_tags.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';

/// Post footer with categories and tags
class PostFooter extends StatelessComponent {
  const PostFooter({
    required this.config,
    required this.page,
    required this.child,
    super.key,
  });

  final FlexLayoutConfig config;
  final Page page;
  final Component child;

  @override
  Component build(BuildContext context) {
    return // Post footer with categories and tags
    div(
      classes: 'flex-post-footer',
      [
        // Separator line
        hr(),

        // Categories
        if ((page.data['page'] as Map?)?['categories'] //
            case List categories when categories.isNotEmpty)
          PostCategories(categories: categories),

        // Tags
        if ((page.data['page'] as Map?)?['tags'] //
            case List tags when tags.isNotEmpty)
          PostTags(tags: tags),
      ],
    );
  }
}
