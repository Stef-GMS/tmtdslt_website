# TooMuchToDoSoLittleTime - Jaspr Migration

**WordPress to Jaspr migration** for [toomuchtodosolittletime.com](http://toomuchtodosolittletime.com)

A statically generated blog built with **Jaspr** (Dart), **jaspr_content** (markdown-based content management), and **Firebase Hosting**.

**No database required!** All content is stored as markdown files in Git.

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
- 🔄 Phase 2 multi-select dropdowns (checkboxes on all three dropdowns)

### Planned
- 📋 Search functionality
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
jaspr build --target static
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
Firebase Hosting
```

### Technology Stack

| Layer | Technology |
|-------|-----------|
| Language | Dart ^3.11.1 |
| Web Framework | Jaspr ^0.22.4 (static mode) |
| Content | jaspr_content ^0.5.1 |
| Routing | jaspr_router ^0.8.1 |
| Hosting | Firebase Hosting |

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
| `import_wordpress_xml.dart` | Extract comments (with emails) from XML export |
| `extract_wordpress_content.dart` | Extract comments/pages/links via REST API |
| `generate_tag_pages.dart` | Generate `content/tag/` index pages |
| `generate_category_pages.dart` | Generate `content/category/` index pages |
| `generate_archive_pages.dart` | Generate `content/page/` pagination pages |
| `generate_home_pagination.dart` | Generate home page pagination |
| `fix_wordpress_image_refs.dart` | Fix image paths after migration |
| `fix_signature_refs.dart` | Fix signature image references |
| `cleanup_duplicate_signatures.dart` | Remove duplicate signature images |
| `download_google_images.dart` | Download images referenced from Google |
| `update_google_image_refs.dart` | Update refs after Google image download |

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

After adding a post, regenerate pagination and archive pages if needed:

```bash
dart run bin/generate_home_pagination.dart
dart run bin/generate_archive_pages.dart
```

---

## 🧪 Development

```bash
# Analyze code
dart analyze

# Format code
dart format .

# Build static site
jaspr build --target static

# Serve built site
firebase serve
```

---

## 📝 License

This project is private and proprietary.

---

## 👤 Author

**Stephanie @ GeekMeSpeak**
- Website: [GeekMeSpeak.com](https://geekmespeak.com)
- GitHub: [@Stef-GMS](https://github.com/Stef-GMS)

