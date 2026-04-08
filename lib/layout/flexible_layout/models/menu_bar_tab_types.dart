/// Menu bar tab types
enum MenuBarTabType {
  category, // Post category (filters posts)
  page, // Static page
  tag, // Post tag (filters posts)
}

/// Menu bar tab model with display settings and hierarchy
/// Supports categories, pages, and tags in the top navigation menu
class MenuBarTab {
  const MenuBarTab({
    required this.name,
    required this.slug,
    required this.display,
    this.type = MenuBarTabType.category,
    this.parentSlug,
  });

  final String name;
  final String slug;
  final bool display;
  final MenuBarTabType type;
  final String? parentSlug;

  /// Get the URL path based on tab type
  String get path {
    switch (type) {
      case MenuBarTabType.category:
        return '/category/$slug';
      case MenuBarTabType.page:
        return '/pages/$slug';
      case MenuBarTabType.tag:
        return '/tag/$slug';
    }
  }

  /// Check if this is a top-level tab (no parent)
  bool get isTopLevel => parentSlug == null || parentSlug!.isEmpty;

  /// Get all menu bar tabs
  static const List<MenuBarTab> all = [
    MenuBarTab(
      name: 'Adorable',
      slug: 'adorable',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'BabySteps',
      slug: 'babysteps',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Behind the Camera',
      slug: 'behind-the-camera',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Books',
      slug: 'books',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: '— Pride and Prejudice',
      slug: 'pride-and-prejudice',
      display: true,
      type: MenuBarTabType.category,
      parentSlug: 'books',
    ),
    MenuBarTab(
      name: 'Bucket List',
      slug: 'bucket-list',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Do It Yourself',
      slug: 'diy',
      display: false,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Home Remodel',
      slug: 'home-remodel',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Kitchen Remodel',
      slug: 'kitchen-remodel',
      display: false,
      type: MenuBarTabType.category,
      parentSlug: 'home-remodel',
    ),
    MenuBarTab(
      name: 'In the Garden',
      slug: 'in-the-garden',
      display: false,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'In the Kitchen',
      slug: 'in-the-kitchen',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Cocktails',
      slug: 'cocktails',
      display: true,
      type: MenuBarTabType.category,
      parentSlug: 'in-the-kitchen',
    ),
    MenuBarTab(
      name: 'Smoothies',
      slug: 'smoothies',
      display: false,
      type: MenuBarTabType.category,
      parentSlug: 'in-the-kitchen',
    ),
    MenuBarTab(
      name: 'Laughter',
      slug: 'laughter',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Life',
      slug: 'life',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Media Center',
      slug: 'media-center',
      display: false,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Mingling',
      slug: 'mingling',
      display: false,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Movie Reviews',
      slug: 'movie-reviews',
      display: false,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Softball',
      slug: 'softball',
      display: false,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Technology Corner',
      slug: 'tech_corner',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'Trivia',
      slug: 'trivia',
      display: true,
      type: MenuBarTabType.category,
    ),
    MenuBarTab(
      name: 'About',
      slug: 'about',
      display: true,
      type: MenuBarTabType.page,
    ),
    MenuBarTab(
      name: 'Disclosures',
      slug: 'disclosures',
      display: true,
      type: MenuBarTabType.page,
    ),
    MenuBarTab(
      name: 'Archives',
      slug: 'archives',
      display: false,
      type: MenuBarTabType.category,
    ),
  ];

  /// Get only tabs that should be displayed
  static List<MenuBarTab> get displayed => //
      all.where((c) => c.display).toList();

  /// Get only top-level tabs that should be displayed
  static List<MenuBarTab> get displayedTopLevel => //
      displayed.where((c) => c.isTopLevel).toList();

  /// Get only categories (for filtering posts)
  static List<MenuBarTab> get categories => //
      all.where((c) => c.type == MenuBarTabType.category).toList();

  /// Get only pages
  static List<MenuBarTab> get pages => //
      all.where((c) => c.type == MenuBarTabType.page).toList();

  /// Get only tags
  static List<MenuBarTab> get tags => //
      all.where((c) => c.type == MenuBarTabType.tag).toList();

  /// Get child tabs for a given parent slug
  static List<MenuBarTab> getChildren(String parentSlug) => //
      displayed.where((c) => c.parentSlug == parentSlug).toList();

  /// Find a tab by slug
  static MenuBarTab? findBySlug(String slug) {
    try {
      return all.firstWhere((c) => c.slug == slug);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => 'MenuBarTab($name, $slug, type: $type, display: $display, parent: $parentSlug)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || //
      other is MenuBarTab && //
          runtimeType == other.runtimeType && //
          slug == other.slug;

  @override
  int get hashCode => slug.hashCode;
}

/// Backward compatibility alias
@Deprecated('Use MenuBarTab instead')
typedef BlogCategory = MenuBarTab;
