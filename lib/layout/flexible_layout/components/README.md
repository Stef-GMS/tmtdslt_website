# FlexibleLayout Components

This directory contains all reusable components for the FlexibleLayout system used in TooMuchToDoSoLittleTime blog.

## Overview

Components are organized into several categories:
- **Custom Page Components** - Components that render entire pages
- **Sidebar Widgets** - Components displayed in the sidebar
- **Navigation Components** - Top menu and dropdowns
- **Layout Components** - Main structural components
- **Utility Components** - Helper components for images, spacing, etc.

---

## Custom Page Components

### `home_page.dart`
**Purpose:** Renders the home page with recent posts grid
**Usage:** `<HomePage />` in content/index.md
**Features:**
- Displays 10 most recent published posts
- Uses PostsGrid for responsive layout
- Pagination support

### `archive_page.dart`
**Purpose:** Renders monthly archive pages
**Usage:** `<ArchivePage />` in content/posts/YYYY/YYYY-MM/index.md
**Features:**
- Reads `year` and `month` from frontmatter
- Filters posts by month
- Inline dropdown: "Posts from: [dropdown]"
- Pagination (10 posts per page)

### `category_page.dart`
**Purpose:** Renders category archive pages
**Usage:** `<CategoryPage />` in content/category/{slug}.md
**Features:**
- Reads `category_slug` from frontmatter
- Filters posts by category
- Inline dropdown: "Category: [dropdown]"
- Pagination (10 posts per page)

### `tag_page.dart`
**Purpose:** Renders tag archive pages
**Usage:** `<TagPage />` in content/tag/{slug}.md
**Features:**
- Reads `tag_slug` from frontmatter
- Filters posts by tag (case-insensitive)
- Inline dropdown: "Posts tagged: [dropdown]"
- Pagination (10 posts per page)

---

## Sidebar Widgets

### `archive_dropdown.dart`
**Purpose:** Dropdown menu for selecting archive months
**Modes:**
- **Sidebar mode:** Shows "Archives" header above dropdown
- **Inline mode:** Shows "Posts from:" label inline with dropdown (used on archive pages)
**Features:**
- Lists all months with post counts
- Sorted newest first
- Format: "YYYY-MM (count)"
- Navigates immediately on selection

### `recent_posts.dart`
**Purpose:** Displays list of recent posts
**Features:**
- Shows 5 most recent published posts
- Post titles as links
- Simple list layout

### `tag_cloud.dart`
**Purpose:** Tag cloud visualization with size-based font sizing
**Features:**
- Font sizes: 12-24px based on post count
- Maximum tags: 45 (configurable via `maxTagsInCloud`)
- Alphabetically sorted
- Dyslexia-friendly spacing (gap: 12px 16px, line-height: 2)
- Tags link to `/tag/{slug}`
- Header "Tags" links to `/tags/` overview page

### `tag_dropdown.dart`
**Purpose:** Dropdown menu for selecting tags
**Modes:**
- **Sidebar mode:** Shows "Tags" header above dropdown (not currently used)
- **Inline mode:** Shows "Posts tagged:" label inline with dropdown (used on tag pages)
**Features:**
- Lists ALL tags alphabetically with counts
- Format: "Tag Name (count)"
- Highlights currently selected tag
- Navigates immediately on selection

### `category_dropdown.dart`
**Purpose:** Dropdown menu for selecting categories
**Modes:**
- **Sidebar mode:** Shows "Categories" header above dropdown (not currently used)
- **Inline mode:** Shows "Category:" label inline with dropdown (used on category pages)
**Features:**
- Lists all displayed categories from MenuBarTab
- Shows post counts: "Category Name (count)"
- Highlights currently selected category
- Navigates immediately on selection

---

## Navigation Components

### `top_menu.dart`
**Purpose:** Top navigation menu bar
**Features:**
- Home link
- Category links (11 categories)
- Page links (About, Disclosures)
- Active state highlighting (current page)
- Responsive hamburger menu for mobile

---

## Layout Components

### `sidebar.dart`
**Purpose:** Right sidebar container
**Widgets (in order):**
1. ArchiveDropdown (sidebar mode)
2. RecentPosts
3. TagCloud

### `main_content.dart`
**Purpose:** Main content area wrapper
**Features:**
- Renders post header (title, date, author)
- Renders page content
- Renders post footer (categories, tags)
- White background for posts and static pages

### `post_header.dart`
**Purpose:** Post header with title and metadata
**Features:**
- Post title (styled with title font)
- Post date and author
- White background container

### `post_footer.dart`
**Purpose:** Post footer with taxonomy links
**Features:**
- Categories list with folder emoji (📁)
- Tags list with tag emoji (🏷️)
- Horizontal separator line above

### `pagination.dart`
**Purpose:** Pagination controls for archive pages
**Features:**
- Previous/Next navigation
- Page number links
- Disabled state for first/last pages

### `posts_grid.dart`
**Purpose:** Responsive grid layout for displaying posts
**Features:**
- Grid layout: `repeat(auto-fill, minmax(300px, 1fr))`
- Post cards with image, title, excerpt
- Categories and tags display
- "Continue reading" link
- White card backgrounds on transparent page

---

## Utility Components

### `column.dart`
**Purpose:** Responsive column layout wrapper
**Features:**
- Mobile: full width
- Desktop: configured width (e.g., 1/2, 1/3)
- Configurable gap between columns

### `spacer.dart`
**Purpose:** Vertical spacing component
**Usage:** `<Spacer height="20px" />` or `<Spacer height="2em" />`
**Features:**
- Configurable height
- Default: 1em

### `image_extended.dart`
**Purpose:** Enhanced image component with positioning
**Features:**
- Size control (width, height)
- Positioning (left, right, center)
- Margins for text wrapping
- Caption support

### `image_extended_zoomable.dart`
**Purpose:** Zoomable image with lightbox functionality
**Features:**
- Click to zoom/enlarge
- Overlay modal
- Close on click outside
- Responsive sizing

---

## Component Registration

All custom page components must be registered in `lib/main.server.dart`:

```dart
components: [
  HomePage(),
  ArchivePage(),
  CategoryPage(),
  TagPage(),
],
```

---

## Usage Examples

### Archive Page
```markdown
---
layout: flexible
page-type: archive
year: 2020
month: 2020-08
---

<ArchivePage />
```

### Category Page
```markdown
---
layout: flexible
page-type: archive
category_slug: adorable
---

<CategoryPage />
```

### Tag Page
```markdown
---
layout: flexible
page-type: archive
tag_slug: cucumber
---

<TagPage />
```

### Home Page
```markdown
---
layout: flexible
page-type: home
---

<HomePage />
```

---

## Styling

All components use the FlexibleLayout theming system:
- **Theme:** `lib/layout/flexible_layout/flex_theme.dart`
- **Styles:** `lib/layout/flexible_layout/flex_layout_styles.dart`
- **Constants:** `lib/layout/flexible_layout/constants.dart`

CSS variables are defined in FlexTheme and used throughout components for consistent styling.

---

## Scripts

### Generate Archive Pages
```bash
dart bin/generate_archive_pages.dart
```
Generates monthly archive pages with pagination.

### Generate Category Pages
```bash
dart bin/generate_category_pages.dart
```
Generates category pages with pagination (run after adding/changing categories).

### Generate Tag Pages
```bash
dart bin/generate_tag_pages.dart
```
Generates tag pages with pagination (run after adding/changing tags).

**When to run:** After adding new posts, changing tags/categories, or when pagination breaks.

---

## Component Count

**Total Components:** 18

- **Custom Page Components:** 4 (HomePage, ArchivePage, CategoryPage, TagPage)
- **Sidebar Widgets:** 5 (ArchiveDropdown, RecentPosts, TagCloud, TagDropdown, CategoryDropdown)
- **Navigation:** 1 (TopMenu)
- **Layout:** 5 (Sidebar, MainContent, PostHeader, PostFooter, Pagination)
- **Utility:** 3 (Column, Spacer, ImageExtended, ImageExtendedZoomable)
- **Grid:** 1 (PostsGrid)

