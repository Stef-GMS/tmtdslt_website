import 'package:tmtdslt/layout/flexible_layout/constants.dart';

/// Configuration for FlexibleLayout
class FlexLayoutConfig {
  const FlexLayoutConfig({
    required this.siteTitle,
    required this.siteDescription,
    required this.siteUrl,
    required this.enableDarkMode,
    required this.showSidebar,
    required this.sidebarPosition,
    required this.footerText,
    required this.showJasprBadge,
  });

  // Site metadata
  final String siteTitle;
  final String siteDescription;
  final String siteUrl;

  // Theme
  final bool enableDarkMode;

  // Layout
  final bool showSidebar;
  final FlexSidebarPosition sidebarPosition;

  // Footer
  final String footerText;
  final bool showJasprBadge;
}
