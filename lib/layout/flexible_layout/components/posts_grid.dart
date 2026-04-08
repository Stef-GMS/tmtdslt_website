import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// Posts grid component - Pure rendering component for displaying posts
///
/// This component accepts a pre-filtered list of posts and renders them
/// in a responsive grid layout. It does NOT do any filtering itself.
///
/// Used by:
/// - Home page (shows recent posts)
/// - Archive pages (shows posts from a specific month)
/// - Category pages (shows posts in a category)
/// - Tag pages (shows posts with a tag)
class PostsGrid extends StatelessComponent {
  const PostsGrid({
    required this.posts,
    this.emptyMessage = 'No posts available.',
    super.key,
  });

  final List<Page> posts;
  final String emptyMessage;

  @override
  Component build(BuildContext context) {
    if (posts.isEmpty) {
      return div(classes: 'posts-grid-empty', [
        p([Component.text(emptyMessage)]),
      ]);
    }

    return div(
      classes: 'posts-grid',
      posts.map((post) => _buildPostCard(post)).toList(),
    );
  }

  /// Build a single post card
  Component _buildPostCard(Page post) {
    final pageData = post.data['page'] as Map?;
    if (pageData == null) return div([]);

    final title = pageData['title'] as String? ?? 'Untitled';
    final date = pageData['date'] as String?;
    final author = pageData['author'] as String? ?? 'Stef';
    final excerpt = _truncateExcerpt(pageData['excerpt'] as String? ?? '', 55);
    final image = pageData['image'] as String?;
    final categories = (pageData['categories'] as List?)?.cast<String>() ?? [];
    final tags = (pageData['tags'] as List?)?.cast<String>() ?? [];

    return article(
      classes: 'post-card',
      [
        // Featured image (if available) - clickable
        if (image != null && image.isNotEmpty)
          a(
            href: post.url,
            classes: 'post-card-image-link',
            [
              img(
                src: image,
                alt: title,
                classes: 'post-card-image',
              ),
            ],
          ),

        // Post content
        div(classes: 'post-card-content', [
          // Title - clickable
          h2(
            classes: 'post-card-title',
            [
              a(
                href: post.url,
                [Component.text(title)],
              ),
            ],
          ),

          // Date and author
          if (date != null)
            p(
              classes: 'post-card-meta',
              [
                Component.text('Posted on $date by $author'),
              ],
            ),

          // Excerpt
          if (excerpt.isNotEmpty)
            p(
              classes: 'post-card-excerpt',
              [Component.text(excerpt)],
            ),

          // Categories and tags
          if (categories.isNotEmpty || tags.isNotEmpty)
            div(classes: 'post-card-taxonomy', [
              if (categories.isNotEmpty)
                div(classes: 'post-card-categories', [
                  span(classes: 'taxonomy-icon', [Component.text('📁 ')]),
                  ...categories.asMap().entries.map((entry) {
                    final isLast = entry.key == categories.length - 1;
                    return span([
                      a(
                        href: '/category/${entry.value.toLowerCase().replaceAll(' ', '-')}',
                        [Component.text(entry.value)],
                      ),
                      if (!isLast) Component.text(', '),
                    ]);
                  }),
                ]),
              if (tags.isNotEmpty)
                div(classes: 'post-card-tags', [
                  span(classes: 'taxonomy-icon', [Component.text('🏷️ ')]),
                  ...tags.asMap().entries.map((entry) {
                    final isLast = entry.key == tags.length - 1;
                    return span([
                      a(
                        href: '/tag/${entry.value.toLowerCase().replaceAll(' ', '-')}',
                        [Component.text(entry.value)],
                      ),
                      if (!isLast) Component.text(', '),
                    ]);
                  }),
                ]),
            ]),

          // Continue reading button - clickable
          a(
            href: post.url,
            classes: 'post-card-button',
            [Component.text('Continue reading')],
          ),
        ]),
      ],
    );
  }

  /// Truncate excerpt to specified word count
  String _truncateExcerpt(String text, int wordCount) {
    final words = text.split(RegExp(r'\s+'));
    if (words.length <= wordCount) return text;
    return '${words.take(wordCount).join(' ')}...';
  }
}
