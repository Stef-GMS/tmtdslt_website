/// Theme configuration for FlexibleLayout
///
/// THEMING ARCHITECTURE:
/// - Jaspr ContentTheme (in main.server.dart): Handles primary colors, background, text, fonts
/// - FlexTheme (this file): Provides constants and CSS variables for custom layout components
///   - Color constants: Used by ContentTheme AND custom components
///   - Spacing, layout dimensions, breakpoints: Used by custom FlexibleLayout
///   - Additional color variations: content-bg, text-muted, borders, etc.
///
/// This dual approach allows:
/// 1. Jaspr ContentTheme to handle standard content theming and ThemeToggle
/// 2. Custom FlexibleLayout to use additional design system variables
class FlexTheme {
  // ============================================================================
  // COLOR SCHEME
  // ============================================================================

  // Colors (light, dark references are color modes)
  static const String pageBgLight = '#ffcccc'; // very pale red, websafe, rgb(255, 204, 204), CMYK(0, 20, 20, 0)
  static const String pageBgDark =
      '#1a1a1a'; // very dark grey (darker), NOT websafe, rgb(26, 26, 26), CMYK(0, 0, 0, 90)
  static const String contentBgLight = '#ffffff'; // White, websafe, rgb(255, 255, 255), CMYK(0, 0, 0, 0)
  static const String contentBgDark =
      '#2a2a2a'; // dark grey (lighter than page bg), NOT websafe, rgb(42, 42, 42), CMYK(0, 0, 0, 84)
  static const String textLight = '#333333'; // very dark grey, websafe, rgb(51, 51, 51), CMYK(0, 0, 0, 80)
  static const String textDark =
      '#f5f5f5'; // Very light grey, NOT websafe but don't want white, rgb(245, 245, 245), CMYK(0, 0, 0, 4)
  static const String textMutedLight = '#666666'; // mid dark grey, websafe, rgb(102, 102, 102), CMYK(0, 0, 0, 25)
  static const String textMutedDark = '#999999'; // dark grey, websafe, rgb(153, 153, 153), CMYK(0, 0, 0, 40)
  static const String linkLight = '#ff99cc'; // light pink, websafe, rgb(255, 153, 204), CMYK(0, 0, 0, 20)
  static const String linkDark = '#cc0066'; // dark pink, websafe, rgb(204, 0, 102), CMYK(0, 100, 0, 20)
  static const String linkHoverLight = '#cc0066'; // dark pink, websafe, rgb(204, 0, 102), CMYK(0, 100, 0, 20)
  static const String linkHoverDark = '#ff99cc'; // light pink, websafe, rgb(255, 153, 204), CMYK(0, 0, 0, 20)
  static const String borderLight = '#cccccc'; // light grey, websafe, rgb(204, 204, 204), CMYK(0, 0, 0, 20)
  static const String borderDark = '#333333'; // very dark grey, websafe, rgb(51, 51, 51), CMYK(0, 0, 0, 80)

  // Navigation colors (light, dark)
  static const String naviBackgroundLight = '#333333'; // very dark grey, websafe, rgb(51, 51, 51), CMYK(0, 0, 0, 80)
  static const String naviBackgroundDark = '#333333'; // very dark grey, websafe, rgb(51, 51, 51), CMYK(0, 0, 0, 80)
  static const String naviTextLight = '#ffffff'; // White, websafe, rgb(255, 255, 255), CMYK(0, 0, 0, 0)
  static const String naviTextDark = '#ffffff'; // White, websafe, rgb(255, 255, 255), CMYK(0, 0, 0, 0)
  static const String naviHoverLight = 'rgba(255, 255, 255, 0.2)'; // Navigation link hover overlay
  static const String naviHoverDark = 'rgba(255, 255, 255, 0.2)'; // Navigation link hover overlay (dark mode)
  static const String naviActiveLight = 'rgba(255, 255, 255, 0.3)'; // Navigation active/current page overlay
  static const String naviActiveDark = 'rgba(255, 255, 255, 0.3)'; // Navigation active/current page overlay (dark mode)

  // Post colors (light, dark)
  static const String postsCategoryLight = '#666666'; // mid dark grey, websafe, rgb(102, 102, 102), CMYK(0, 0, 0, 25)
  static const String postsCategoryDark = '#999999'; // dark grey, websafe, rgb(153, 153, 153), CMYK(0, 0, 0, 40)
  static const String postsCategoryHoverLight =
      '#333333'; // very dark grey, websafe, rgb(51, 51, 51), CMYK(0, 0, 0, 60)
  static const String postsCategoryHoverDark = '#999999'; // dark grey, websafe, rgb(153, 153, 153), CMYK(0, 0, 0, 40)
  static const String postsTagLight = '#cccccc'; // light grey, websafe, rgb(204, 204, 204), CMYK(0, 0, 0, 20)
  static const String postsTagDark = '#cccccc'; // light grey, websafe, rgb(204, 204, 204), CMYK(0, 0, 0, 20)
  static const String postsTagHoverLight = '#333333'; // very dark grey, websafe, rgb(51, 51, 51), CMYK(0, 0, 0, 60)
  static const String postsTagHoverDark = '#999999'; // dark grey, websafe, rgb(153, 153, 153), CMYK(0, 0, 0, 40)
  static const String postTitleLight = '#333333'; // very dark grey, websafe, rgb(51, 51, 51), CMYK(0, 0, 0, 80)
  static const String postTitleDark =
      '#f5f5f5'; // Very light grey, NOT websafe but don't want white, rgb(245, 245, 245), CMYK(0, 0, 0, 4)
  static const String postDateLight = '#666666'; // mid dark grey, websafe, rgb(102, 102, 102), CMYK(0, 0, 0, 25)
  static const String postDateDark = '#999999'; // dark grey, websafe, rgb(153, 153, 153), CMYK(0, 0, 0, 40)
  static const String postLineLight = 'rgba(0, 0, 0, 0.1)'; // Separator line with transparency
  static const String postLineDark = 'rgba(255, 255, 255, 0.1)'; // Separator line with transparency (dark mode)
  static const String postButtonBackgroundLight =
      '#cccccc'; // light grey, websafe, rgb(204, 204, 204), CMYK(0, 0, 0, 20)
  static const String postButtonBackgroundDark =
      '#7a7a7a'; // light grey, websafe, rgb(122, 122, 122), CMYK(0, 0, 0, 52)
  static const String postButtonTextLight = '#ffffff'; // White, websafe, rgb(255, 255, 255), CMYK(0, 0, 0, 0)
  static const String postButtonTextDark = '#ffffff'; // White, websafe, rgb(255, 255, 255), CMYK(0, 0, 0, 0)
  static const String postButtonBackgroundHoverLight =
      '#666666'; // Button hover background, mid dark grey, websafe, rgb(102, 102, 102), CMYK(0, 0, 0, 60)
  static const String postButtonBackgroundHoverDark =
      '#666666'; // Button hover background (dark mode), mid dark grey, websafe, rgb(102, 102, 102), CMYK(0, 0, 0, 60)
  static const String postButtonTextHoverLight =
      '#ffffff'; // Button text on hover, websafe, rgb(255, 255, 255), CMYK(0, 0, 0, 0)
  static const String postButtonTextHoverDark =
      '#ffffff'; // Button text on hover (dark mode), websafe, rgb(255, 255, 255), CMYK(0, 0, 0, 0)

  // Sidebar Recent Posts colors (light, dark)
  static const String sidebarRecentPostsLight =
      '#ff6699'; // Recent posts link color, websafe, rgb(255, 102, 153), CMYK(0, 60, 40, 0)
  static const String sidebarRecentPostsDark =
      '#ff99cc'; // Recent posts link color (dark mode), websafe, rgb(255, 153, 204), CMYK(0, 40, 20, 0)
  static const String sidebarRecentPostsUnderlineLight =
      '#ff99cc'; // Recent posts underline color, websafe, rgb(255, 102, 153), CMYK(0, 60, 40, 0)
  static const String sidebarRecentPostsUnderlineDark =
      '#ff99cc'; // Recent posts underline color (dark mode), websafe, rgb(255, 153, 204), CMYK(0, 40, 20, 0)

  // ============================================================================
  // TYPOGRAPHY
  // ============================================================================

  /// Title font family (headings, site title)
  static const String titleFont = 'Quicksand, sans-serif';

  /// Body font family (paragraphs, content)
  static const String bodyFont = 'Raleway, sans-serif';

  /// Font sizes
  static const String fontSizeBase = '18px';
  static const String fontSizeSmall = '14px';
  static const String fontSizeLarge = '20px';
  static const String fontSizeH1 = '1.75rem';
  static const String fontSizeH2 = '1.5rem';
  static const String fontSizeH3 = '1.25rem';
  static const String fontSizeH4 = '1.125rem';

  /// Tag cloud font sizes (changed from 8-22px to 12-24px for better readability)
  static const String tagCloudMinFontSize = '12px';
  static const String tagCloudMaxFontSize = '24px';

  /// Post/Archive page header title (separate from H1 in case we want different sizing)
  /// Matches sidebar widget titles (h3 styling)
  static const String fontSizePostTitle = '1.125rem';
  static const String fontWeightPostTitle = '600';

  /// Line heights
  static const double bodyLineHeight = 1.75;
  static const double headingLineHeight = 1.2;

  // ============================================================================
  // SPACING
  // ============================================================================

  static const String spacingXs = '0.25rem'; // 4px
  static const String spacingSm = '0.5rem'; // 8px
  static const String spacingMd = '1rem'; // 16px
  static const String spacingLg = '1.5rem'; // 24px
  static const String spacingXl = '2rem'; // 32px
  static const String spacingXxl = '3rem'; // 48px

  // ============================================================================
  // LAYOUT
  // ============================================================================

  /// Maximum content width (increased for large monitors)
  static const String maxContentWidth = '1600px';

  /// Sidebar width
  static const String sidebarWidth = '250px';

  /// Content padding (outer padding around the whole layout)
  static const String contentPadding = '1.5rem';
  static const String contentPaddingMobile = '1rem';

  /// Border radius for cards and widgets
  static const String borderRadius = '8px';

  /// Border radius for small elements (buttons, inputs, code blocks)
  static const String borderRadiusSmall = '4px';

  /// Border widths
  static const String borderWidthThin = '1px';
  static const String borderWidthMedium = '2px';
  static const String borderWidthThick = '4px';

  /// Sidebar widget h3 border (horizontal line under title)
  static const String sidebarWidgetBorderWidth = '1px';
  static const String sidebarWidgetBorderStyle = 'solid';
  static const String sidebarWidgetBorderColor = '#ddd';

  /// Box shadow for cards and widgets
  static const String boxShadow = '0 2px 4px';

  /// Transition duration
  static const String transitionDuration = '0.2s';

  /// Image dimensions
  static const String postCardImageSize = '150px';
  static const String signatureImageMaxWidth = '200px';
  static const String contentImageMaxWidth = '500px';
  static const String postsGridMinWidth = '300px';

  /// Hamburger menu dimensions
  static const String hamburgerWidth = '25px';
  static const String hamburgerHeight = '3px';
  static const String hamburgerSpacing = '8px';

  /// Dropdown arrow icon (SVG data URI)
  /// Used for all dropdown selects (archives, categories, tags)
  /// To change the arrow, modify this SVG data URI
  static const String dropdownArrowIcon =
      "url(\"data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e\")";

  // ============================================================================
  // RESPONSIVE BREAKPOINTS
  // ============================================================================

  static const int breakpointMobile = 768; // Mobile: < 768px
  static const int breakpointTablet = 1024; // Tablet: 768px - 1024px
  static const int breakpointDesktop = 1200; // Desktop: > 1024px

  // ============================================================================
  // CSS GENERATION FOR CUSTOM LAYOUT
  // ============================================================================
  // NOTE: Jaspr ContentTheme handles primary theming (colors, fonts for content)
  // This method generates CSS variables for our custom FlexibleLayout components
  // that need spacing, layout dimensions, and additional color variations

  /// Generate CSS variables for FlexibleLayout custom components
  /// ContentTheme handles: primary colors, background, text, fonts
  /// This handles: spacing, layout dimensions, muted colors, borders, navigation
  static String generateThemeCSS() {
    return '''
      /* Light mode (default) - Custom layout variables */
      :root {
        /* Additional color variations (not covered by ContentTheme) */
        --content-bg: $contentBgLight;
        --text-muted: $textMutedLight;
        --link-hover: $linkHoverLight;
        --border-color: $borderLight;

        /* Navigation colors */
        --navi-background: $naviBackgroundLight;
        --navi-text: $naviTextLight;
        --navi-hover: $naviHoverLight;
        --navi-active: $naviActiveLight;

        /* Post-specific colors */
        --post-category: $postsCategoryLight;
        --post-category-hover: $postsCategoryHoverLight;
        --post-tag: $postsTagLight;
        --post-tag-hover: $postsTagHoverLight;
        --post-title: $postTitleLight;
        --post-date: $postDateLight;
        --post-line: $postLineLight;
        --post-button-background: $postButtonBackgroundLight;
        --post-button-text: $postButtonTextLight;
        --post-button-background-hover: $postButtonBackgroundHoverLight;
        --post-button-text-hover: $postButtonTextHoverLight;

        /* Sidebar colors */
        --sidebar-recent-posts: $sidebarRecentPostsLight;
        --sidebar-recent-posts-underline: $sidebarRecentPostsUnderlineLight;

        /* Typography (sizes and line heights) */
        --font-title: $titleFont;
        --font-body: $bodyFont;
        --font-size-base: $fontSizeBase;
        --font-size-small: $fontSizeSmall;
        --font-size-large: $fontSizeLarge;
        --font-size-h1: $fontSizeH1;
        --font-size-h2: $fontSizeH2;
        --font-size-h3: $fontSizeH3;
        --font-size-h4: $fontSizeH4;
        --font-size-post-title: $fontSizePostTitle;
        --font-weight-post-title: $fontWeightPostTitle;
        --tag-cloud-min-font-size: $tagCloudMinFontSize;
        --tag-cloud-max-font-size: $tagCloudMaxFontSize;
        --line-height-body: $bodyLineHeight;
        --line-height-heading: $headingLineHeight;

        /* Spacing system */
        --spacing-xs: $spacingXs;
        --spacing-sm: $spacingSm;
        --spacing-md: $spacingMd;
        --spacing-lg: $spacingLg;
        --spacing-xl: $spacingXl;
        --spacing-xxl: $spacingXxl;

        /* Layout dimensions */
        --max-content-width: $maxContentWidth;
        --sidebar-width: $sidebarWidth;
        --content-padding: $contentPadding;
        --border-radius: $borderRadius;
        --border-radius-sm: $borderRadiusSmall;
        --border-width-thin: $borderWidthThin;
        --border-width-medium: $borderWidthMedium;
        --border-width-thick: $borderWidthThick;
        --sidebar-widget-border-width: $sidebarWidgetBorderWidth;
        --sidebar-widget-border-style: $sidebarWidgetBorderStyle;
        --sidebar-widget-border-color: $sidebarWidgetBorderColor;
        --box-shadow: $boxShadow;
        --transition-duration: $transitionDuration;
        --post-card-image-size: $postCardImageSize;
        --signature-image-max-width: $signatureImageMaxWidth;
        --content-image-max-width: $contentImageMaxWidth;
        --posts-grid-min-width: $postsGridMinWidth;
        --hamburger-width: $hamburgerWidth;
        --hamburger-height: $hamburgerHeight;
        --hamburger-spacing: $hamburgerSpacing;
        --dropdown-arrow-icon: $dropdownArrowIcon;
      }

      /* Dark mode - Manual toggle */
      [data-theme="dark"] {
        --content-bg: $contentBgDark;
        --text-muted: $textMutedDark;
        --link-hover: $linkHoverDark;
        --border-color: $borderDark;

        /* Navigation colors */
        --navi-background: $naviBackgroundDark;
        --navi-text: $naviTextDark;
        --navi-hover: $naviHoverDark;
        --navi-active: $naviActiveDark;

        /* Post-specific colors */
        --post-category: $postsCategoryDark;
        --post-category-hover: $postsCategoryHoverDark;
        --post-tag: $postsTagDark;
        --post-tag-hover: $postsTagHoverDark;
        --post-title: $postTitleDark;
        --post-date: $postDateDark;
        --post-line: $postLineDark;
        --post-button-background: $postButtonBackgroundDark;
        --post-button-text: $postButtonTextDark;
        --post-button-background-hover: $postButtonBackgroundHoverDark;
        --post-button-text-hover: $postButtonTextHoverDark;

        /* Sidebar colors */
        --sidebar-recent-posts: $sidebarRecentPostsDark;
        --sidebar-recent-posts-underline: $sidebarRecentPostsUnderlineDark;
      }

      /* Mobile responsive adjustments */
      @media screen and (max-width: ${breakpointMobile}px) {
        :root {
          --content-padding: $contentPaddingMobile;
        }
      }
    ''';
  }
}
