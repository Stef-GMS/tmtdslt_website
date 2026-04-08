import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Post tags component (widget in Flutter)
class PostTags extends StatelessComponent {
  const PostTags({
    required this.tags,
    super.key,
  });

  final List tags;

  @override
  Component build(BuildContext context) {
    return // post tags
    div(
      classes: 'flex-post-tags',
      [
        span(
          classes: 'flex-tag-icon',
          [Component.text('🏷️ ')],
        ),
        for (var i = 0; i < tags.length; i++)
          a(
            href: '/tag/${(tags[i] as String).toLowerCase().replaceAll(' ', '-')}',
            [
              Component.text('${i > 0 ? ', ' : ''}${tags[i] as String}'),
            ],
          ),
      ],
    );
  }
}
