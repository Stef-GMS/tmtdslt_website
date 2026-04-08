import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// A simple spacer component that creates vertical space
///
/// This replaces the Spacer component that was removed in Jaspr 0.22.x
class Spacer extends StatelessComponent {
  const Spacer({
    super.key,
    this.width,
    this.height,
    this.children,
  });

  final Unit? width;
  final Unit? height;
  final List<Component>? children;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        width: width,
        height: height,
      ),
      children ?? const [],
    );
  }
}
