import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Post category component (widget in Flutter)
class PostCategories extends StatelessComponent {
  const PostCategories({
    required this.categories,
    super.key,
  });

  final List categories;

  @override
  Component build(BuildContext context) {
    return // post categories
    div(
      classes: 'flex-post-categories',
      [
        span(
          classes: 'flex-category-icon',
          [Component.text('📁 ')],
        ),
        for (var i = 0; i < categories.length; i++)
          a(
            href: '/category/${(categories[i]).toLowerCase().replaceAll(' ', '-')}',
            [
              Component.text('${i > 0 ? ', ' : ''}${categories[i] as String}'),
            ],
          ),
      ],
    );
  }
}
