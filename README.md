# TooMuchToDoSoLittleTime - Jaspr Migration

**WordPress to Jaspr migration** for [toomuchtodosolittletime.com](http://toomuchtodosolittletime.com)

A statically generated blog built with **Jaspr** (Dart), **jaspr_content** (markdown-based content management), and **Firebase Hosting**.

**No database required!** All content is stored as markdown files in Git.

---

## 📝 License

See [LICENSE file](https://github.com/Stef-GMS/tmtdslt_website/blob/main/LICENSE)

---

## 👤 Author

**Stephanie "Stef" Patterson**
- Website: [GeekMeSpeak.com](https://geekmespeak.com)
- GitHub: [@Stef-GMS](https://github.com/Stef-GMS)

---

## 📊 Project Status

- **Version:** 0.0.1
- **Branch:** `main`
- **Status:** Active development

### Completed
- ✅ WordPress content migration — 681 posts (2009–2020)
- ✅ Comments extracted to `content/comments.json`
- ✅ Pages migrated to `content/pages/`
- ✅ Tag pages generated (582 tags)
- ✅ Category pages generated (19 categories)
- ✅ Archive pages generated
- ✅ Full frontend layout system (`lib/layout/flexible_layout/`)
- ✅ Home page with pagination
- ✅ Post detail with previous/next navigation
- ✅ Sidebar: recent posts, tag cloud (min-count filter), social media
- ✅ Dropdown navigation: Archives, Tags, Categories
- ✅ Phase 1 — Dropdown consolidation (unified `DropdownButton` component)
- ✅ Phase 2c & 2d — URL routing and multi-filter OR logic

### In Progress
- 🔄 Deploy to web: Evaluate Firebase Hosting or GitHub Pages

### Planned
- 📋 Search functionality
- 📋 Phase 2 multi-select dropdowns (checkboxes on all three dropdowns)
- 📋 Comments display (from `content/comments.json`)
- 📋 Firebase Hosting deployment + GitHub Actions CI/CD

---

## 🚀 Quick Start

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) ^3.11.1
- [Jaspr CLI](https://docs.page/schultek/jaspr)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for deployment)

### Installation

```sh
# Install dependencies
dart pub get

# Install Jaspr CLI
dart pub global activate jaspr_cli
```

### Run Locally

```sh
jaspr serve
# Access at http://localhost:8080
```

### Build for Production

```bash
jaspr build
# Output: build/jaspr/
```

---

## 🏗️ Architecture

```
WordPress (Legacy)
    ↓
Migration Scripts (bin/)
    ↓
Markdown + Images in Git (content/)
    ↓
jaspr_content (loads markdown at build time)
    ↓
Jaspr SSG Build (static mode)
    ↓
Firebase Hosting or GitHub Pages
```

### Technology Stack

| Layer         | Technology                       |
|---------------|----------------------------------|
| Language      | Dart ^3.11.1                     |
| Web Framework | Jaspr ^0.22.4 (static mode)      |
| Content       | jaspr_content ^0.5.1             |
| Routing       | jaspr_router ^0.8.1              |
| Hosting       | Firebase Hosting or GitHub Pages |


---


## 🗂️ Source Structure (`lib/`)

```
lib/
├── app/
│   └── app.dart                                      # ContentApp bootstrap
├── layout/
│   ├── flexible_layout/
│   │   ├── constants.dart                            # Shared constants
│   │   ├── flex_layout.dart                          # Main layout entry
│   │   ├── flex_layout_config.dart                   # Layout configuration
│   │   ├── components/
│   │   │   ├── page_frame.dart                       # Outer page shell
│   │   │   ├── main_header.dart                      # Site header
│   │   │   ├── main_footer.dart                      # Site footer
│   │   │   ├── main_content.dart                     # Content area wrapper
│   │   │   ├── top_menu.dart                         # Navigation menu
│   │   │   ├── sidebar.dart                          # Sidebar container
│   │   │   ├── sidebar_widget.dart                   # Reusable sidebar widget wrapper
│   │   │   ├── column.dart                           # Layout column
│   │   │   ├── home_page.dart                        # Home page layout
│   │   │   ├── posts_grid.dart                       # Post card grid
│   │   │   ├── post_header.dart                      # Post title/date/author
│   │   │   ├── post_footer.dart                      # Post categories & tags footer
│   │   │   ├── post_categories.dart                  # Category chips
│   │   │   ├── post_tags.dart                        # Tag chips
│   │   │   ├── post_navigation.dart                  # Previous / Next post links
│   │   │   ├── pagination.dart                       # Page number controls
│   │   │   ├── archive_page.dart                     # Monthly archive listing
│   │   │   ├── category_page.dart                    # Category post listing
│   │   │   ├── tag_page.dart                         # Tag post listing
│   │   │   ├── tag_cloud.dart                        # Tag cloud (min-count filter)
│   │   │   ├── recent_posts.dart                     # Recent posts sidebar widget
│   │   │   ├── social_media.dart                     # Social media links widget
│   │   │   ├── dropdown_button.dart                  # Unified dropdown (single & multi-select)
│   │   │   ├── image_extended.dart                   # Image with float/signature handling
│   │   │   ├── image_extended_zoomable.dart          # Zoomable image variant
│   │   │   └── spacer.dart                           # Layout spacer
│   │   ├── loaders/
│   │   │   └── filtered_filesystem_loader.dart       # Custom content loader with filtering
│   │   ├── models/
│   │   │   ├── dropdown_item.dart                    # Dropdown option model
│   │   │   ├── dropdown_type.dart                    # Dropdown type enum
│   │   │   ├── menu_bar_tab_types.dart               # Menu tab type enum
│   │   │   └── tag_data.dart                         # Tag + post count model
│   │   ├── theme/
│   │   │   ├── flex_layout_styles.dart               # Global layout styles
│   │   │   └── flex_theme.dart                       # Theme (colors, fonts)
│   │   └── utils/
│   │       ├── posts_filter.dart                     # Multi-filter OR logic
│   │       └── tag_counter.dart                      # Tag frequency counter
├── pages/
│   ├── contact_us_page.dart                          # Contact page
│   ├── privacy_page.dart                             # Privacy policy page
│   └── not_found_page.dart                           # 404 page
├── main.server.dart                                  # Server entry points
├── main.server.options.dart                          # Generated file for Server entry points
├── main.client.dart                                  # Client entry points
└── main.client.options.dart                          # Generated file for Client entry points

```

---

## 📁 Content Structure

```
content/
├── posts/YYYY/YYYY-MM/YYYY-MM-DD-slug.md   # Blog posts
├── images/YYYY/YYYY-MM/                    # Post images
├── images/Signature-Pink36ptFaceTransparent.png
├── tag/slug.md                             # Tag index pages (582)
├── category/slug.md                        # Category index pages (19)
├── page/N/index.md                         # Home pagination pages
├── pages/                                  # WordPress static pages
├── comments.json                           # Extracted WordPress comments
├── links.json                              # Extracted blogroll links
├── index.md                                # Home page
├── posts.md                                # Posts index
└── tags.md                                 # Tags index
```

---

## 🔄 Migration Scripts (`bin/`)

All migration was one-time and is now complete. Scripts are retained for reference.

| Script | Purpose |
|--------|---------|
| `migrate_wordpress_to_markdown.dart` | Fetch posts from WP REST API → markdown |
| `generate_tag_pages.dart` | Generate `content/tag/` index pages |
| `generate_category_pages.dart` | Generate `content/category/` index pages |
| `generate_archive_pages.dart` | Generate `content/page/` pagination pages |
| `generate_home_pagination.dart` | Generate home page pagination |

---

## ✍️ Adding New Content

Create `content/posts/YYYY/YYYY-MM/YYYY-MM-DD-slug.md`:

```markdown
---
title: "My New Post"
date: 2026-04-06
slug: my-new-post
excerpt: "Brief description for SEO and previews"
categories: ["Life"]
tags: ["tag-one", "tag-two"]
author: Stef
image: /images/2026/2026-04/2026-04-06-my-new-post-featured.jpg
published: true
---

Content written in **markdown**.
```

**Date rules:**
- Filename **must** match frontmatter date: `YYYY-MM-DD` (e.g., `2026-04-06`)
- Leading zeros required — `2026-04-06` ✅, `2026-4-6` ❌

After adding a post, regenerate pagination, categories, tags, and archive pages if needed:

```bash
dart run bin/generate_home_pagination.dart
dart run bin/generate_archive_pages.dart
dart run bin/generate_category_pages.dart
dart run bin/generate_tag_pages.dart
```

---

## 🧪 Development

```bash
# Analyze code
dart analyze

# Format code
dart format .

# Build static site
jaspr build

# Serve built site
firebase serve
```

---
## 📖 Why jaspr_content?

**Advantages:**
- ✅ **No Database:** Zero database costs and complexity
- ✅ **Version Control:** Full Git history for all content
- ✅ **Simple:** Just markdown files - easy to understand
- ✅ **Portable:** Can move to any platform anytime
- ✅ **Fast:** No database queries at build time
- ✅ **Official:** First-party Jaspr package
- ✅ **Cheap:** $0.26/month vs $10/month (database)

**Trade-offs:**
- ⚠️ **No Dynamic Queries:** Can't filter at runtime
- ⚠️ **Rebuild Required:** Every change triggers full rebuild
- ⚠️ **No Admin UI:** Must edit markdown files (for now)

**When to Switch to Database:**
- You start posting daily (rebuild time becomes issue)
- You add multiple authors (need admin UI)
- You need dynamic features (search, comments, user accounts)

**Migration Path:** Markdown → Database is easy (just import files)

---