import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/image_extended_zoomable.dart';

/// An image component with optional zooming and caption support.
class ImageExtended extends CustomComponent {
  const ImageExtended({
    this.zoom = false,
    this.replaceImg = true,
  }) : super.base();

  static Component from({
    required String src,
    String? alt,
    String? caption,
    bool zoom = false,
    String? title,
    Key? key,
  }) {
    if (zoom) {
      return ZoomableImageExtended(
        src: src,
        alt: alt,
        caption: caption,
        title: title,
        //width: width,
        //height: height,
        key: key,
      );
    }
    return _ImageExtended(
      src: src,
      alt: alt,
      caption: caption,
      title: title,
      key: key,
    );
  }

  /// Whether to enable zooming on the image.
  final bool zoom;

  /// Whether to replace the default <img> tag with this component.
  final bool replaceImg;

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node
        case ElementNode(tag: 'img' || 'Image', :final attributes) ||
            ElementNode(
              tag: 'p',
              children: [
                ElementNode(
                  tag: 'img' || 'Image',
                  :final attributes,
                ),
              ],
            )) {
      assert(
        attributes.containsKey('src'),
        'Image must have a "src" argument. Found $attributes',
      );
      return from(
        src: attributes['src']!,
        alt: attributes['alt'],
        caption: attributes['caption'],
        title: attributes['title'],
        zoom: zoom || attributes['zoom'] != null,
      );
    }
    return null;
  }

  @css
  static List<StyleRule> get styles => [
    css('figure.image', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
      ),
    ]),
  ];
}

/// An image component with an optional caption.
class _ImageExtended extends StatelessComponent {
  const _ImageExtended({
    required this.src,
    this.alt,
    this.caption,
    this.title,

    super.key,
  });

  /// The image source URL.
  final String src;

  /// The image alt text.
  final String? alt;

  /// The image caption.
  final String? caption;

  /// The image title.
  final String? title;

  @override
  Component build(BuildContext context) {
    return figure(classes: 'image', [
      img(
        src: src,
        alt: alt ?? caption,
        attributes: {
          'title': ?title,
        },
      ),
      if (caption != null) figcaption([Component.text(caption!)]),
    ]);
  }
}
