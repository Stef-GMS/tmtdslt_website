import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/main_content.dart';
import 'package:tmtdslt/layout/flexible_layout/components/main_footer.dart';
import 'package:tmtdslt/layout/flexible_layout/components/main_header.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';

/// Page frame - Top-level layout structure
///
/// This component provides the overall page structure including:
/// - Header with site branding and social links
/// - Top navigation menu
/// - Main content area with sidebar
/// - Footer
class PageFrame extends StatelessComponent {
  final FlexLayoutConfig config;
  final Page page;
  final Component child;

  const PageFrame({
    required this.config,
    required this.page,
    required this.child,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex-layout', [
      // Header
      MainHeader(config: config),

      // Main content wrapper
      MainContent(config: config, page: page, child: child),

      // Footer
      MainFooter(config: config),
    ]);
  }
}
