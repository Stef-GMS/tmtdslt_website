import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

// Import the constant for posts per page
const int postsPerPage = 10;

/// Generates pagination pages for categories.
///
/// This script scans all posts for categories and creates pagination pages
/// for categories with more than postsPerPage posts.
///
/// Structure:
/// - content/category/life.md (page 1)
/// - content/category/life/page/2/index.md
/// - content/category/life/page/3/index.md
/// etc.
///
/// Run this script:
/// - After adding new posts
/// - When category post counts change
/// - To regenerate all category pagination
void main() async {
  print('📁 Generating category pagination pages...\n');

  final postsDir = Directory('content/posts');
  final categoryDir = Directory('content/category');

  if (!postsDir.existsSync()) {
    print('❌ content/posts/ directory not found!');
    exit(1);
  }

  if (!categoryDir.existsSync()) {
    print('❌ content/category/ directory not found!');
    exit(1);
  }

  // Get all category files to map names to slugs
  final categoryNameToSlug = <String, String>{};
  final categorySlugToName = <String, String>{};
  final categoryFiles = categoryDir.listSync().whereType<File>().where((f) => f.path.endsWith('.md')).toList();

  for (final categoryFile in categoryFiles) {
    final content = categoryFile.readAsStringSync();
    final frontmatterMatch = RegExp(r'^---\s*\n(.*?)\n---', dotAll: true).firstMatch(content);
    if (frontmatterMatch != null) {
      final yaml = loadYaml(frontmatterMatch.group(1)!);
      final slug = yaml['category_slug'];
      if (slug != null) {
        // We'll populate categorySlugToName from post data
        // For now just track that this slug exists
        categorySlugToName[slug.toString()] = slug.toString();
      }
    }
  }

  // Count posts per category (by category name from posts)
  final categoryNamePostCounts = <String, int>{};
  await _countPostsByCategory(postsDir, categoryNamePostCounts);

  // Convert to slug-based counts by lowercasing and removing spaces
  final categorySlugPostCounts = <String, int>{};
  for (final entry in categoryNamePostCounts.entries) {
    final categoryName = entry.key;
    // Convert category name to slug format (lowercase, no spaces)
    final slug = categoryName.toLowerCase().replaceAll(' ', '-');

    // Only include if we have a category file for this slug
    if (categorySlugToName.containsKey(slug)) {
      categorySlugPostCounts[slug] = entry.value;
      categorySlugToName[slug] = categoryName; // Update with proper display name
    }
  }

  print('📊 Category post counts:');
  for (final entry in categorySlugPostCounts.entries) {
    final slug = entry.key;
    final name = categorySlugToName[slug] ?? slug;
    print('   $name ($slug): ${entry.value} posts');
  }
  print('');

  int created = 0;
  int deleted = 0;

  // Generate pagination for each category
  for (final entry in categorySlugPostCounts.entries) {
    final categorySlug = entry.key;
    final categoryName = categorySlugToName[categorySlug] ?? categorySlug;
    final postCount = entry.value;
    final totalPages = (postCount / postsPerPage).ceil();

    if (totalPages > 1) {
      // Create pagination pages (page 2, 3, 4, etc.)
      for (int pageNum = 2; pageNum <= totalPages; pageNum++) {
        final pagePath = p.join(
          'content/category',
          categorySlug,
          'page',
          pageNum.toString(),
          'index.md',
        );

        final pageFile = File(pagePath);

        // Create directory if needed
        pageFile.parent.createSync(recursive: true);

        // Create frontmatter (no title - CategoryDropdown shows "Category: [dropdown]")
        final frontmatter =
            '''---
layout: flexible
page-type: archive
category_slug: $categorySlug
page_num: $pageNum
---

<CategoryPage />
''';

        pageFile.writeAsStringSync(frontmatter);
        created++;
        print('   ✅ Created: $pagePath');
      }
    }

    // Clean up old pagination files if posts decreased
    final categoryPaginationDir = Directory(p.join('content/category', categorySlug, 'page'));
    if (categoryPaginationDir.existsSync()) {
      final pageNumDirs = categoryPaginationDir.listSync().whereType<Directory>().toList();
      for (final pageNumDir in pageNumDirs) {
        final pageNum = int.tryParse(p.basename(pageNumDir.path));
        if (pageNum != null && pageNum > totalPages) {
          pageNumDir.deleteSync(recursive: true);
          deleted++;
          print('   🗑️  Deleted: ${pageNumDir.path}');
        }
      }
    }
  }

  print('\n✅ Category pagination generation complete!');
  print('   Created: $created pages');
  if (deleted > 0) {
    print('   Deleted: $deleted old pages');
  }
}

/// Count posts by category
Future<void> _countPostsByCategory(
  Directory postsDir,
  Map<String, int> categoryPostCounts,
) async {
  await for (final entity in postsDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.md') && !entity.path.contains('/page/')) {
      final content = entity.readAsStringSync();
      final frontmatterMatch = RegExp(r'^---\s*\n(.*?)\n---', dotAll: true).firstMatch(content);

      if (frontmatterMatch != null) {
        final yaml = loadYaml(frontmatterMatch.group(1)!);
        final categories = yaml['categories'];

        if (categories is List) {
          for (final category in categories) {
            final categoryStr = category.toString();
            categoryPostCounts[categoryStr] = (categoryPostCounts[categoryStr] ?? 0) + 1;
          }
        }
      }
    }
  }
}
