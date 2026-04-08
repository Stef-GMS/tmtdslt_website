import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';

/// Post header with title, date, author
class PostHeader extends StatelessComponent {
  const PostHeader({
    required this.config,
    required this.page,
    required this.child,
    required this.title,
    super.key,
  });

  final FlexLayoutConfig config;
  final Page page;
  final Component child;
  final String title;

  @override
  Component build(BuildContext context) {
    return // Post header with title, date, author
    div(classes: 'flex-post-header', [
      // Post title at top
      h1(
        classes: 'flex-post-title',
        [Component.text(title)],
      ),
      // Post metadata (date and author below title)
      div(classes: 'flex-post-meta', [
        // Handle date as either DateTime or String
        if ((page.data['page'] as Map?)?['date'] case var date when date != null) ...[
          span(
            classes: 'flex-post-date',
            [
              Component.text(
                date is DateTime ? formatDate(date) : date.toString(),
              ),
            ],
          ),
        ],
        if ((page.data['page'] as Map?)?['author'] case String author)
          span(
            classes: 'flex-post-author',
            [
              Component.text('by $author'),
            ],
          ),
      ]),
    ]);
  }
}
