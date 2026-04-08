import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
import 'package:yaml/yaml.dart';

// Import the constant for posts per page
const int postsPerPage = 10;

/// Generates pagination pages for tags.
///
/// This script scans all posts for tags and creates pagination pages
/// for tags with more than postsPerPage posts.
///
/// Structure:
/// - content/tag/cucumber.md (page 1)
/// - content/tag/cucumber/page/2/index.md
/// - content/tag/cucumber/page/3/index.md
/// etc.
///
/// Run this script:
/// - After adding new posts
/// - When tag assignments change
/// - To regenerate all tag pagination
void main() async {
  print('📁 Generating tag pagination pages...\n');

  final postsDir = Directory('content/posts');
  final tagDir = Directory('content/tag');

  if (!postsDir.existsSync()) {
    print('❌ content/posts/ directory not found!');
    exit(1);
  }

  // Create tag directory if it doesn't exist
  if (!tagDir.existsSync()) {
    tagDir.createSync(recursive: true);
    print('✅ Created content/tag/ directory\n');
  }

  // Count posts per tag (by tag name from posts)
  final tagNamePostCounts = <String, int>{};
  await _countPostsByTag(postsDir, tagNamePostCounts);

  // Convert tag names to slugs (case-insensitive)
  final tagSlugPostCounts = <String, int>{};
  final tagSlugToName = <String, String>{};

  for (final entry in tagNamePostCounts.entries) {
    final tagName = entry.key;
    final slug = _slugify(tagName);
    tagSlugPostCounts[slug] = entry.value;
    tagSlugToName[slug] = tagName;
  }

  print('📊 Tag post counts:');
  final sortedSlugs = tagSlugPostCounts.keys.toList()..sort();
  for (final slug in sortedSlugs) {
    final name = tagSlugToName[slug] ?? slug;
    print('   $name ($slug): ${tagSlugPostCounts[slug]} posts');
  }
  print('');

  // Filter tags by minimum post count
  final filteredTagSlugPostCounts = <String, int>{};
  int skippedTags = 0;

  for (final entry in tagSlugPostCounts.entries) {
    if (entry.value >= minPostsPerTag) {
      filteredTagSlugPostCounts[entry.key] = entry.value;
    } else {
      skippedTags++;
    }
  }

  print('📊 Tag statistics:');
  print('   Total unique tags: ${tagSlugPostCounts.length}');
  print('   Tags with $minPostsPerTag+ posts: ${filteredTagSlugPostCounts.length}');
  print('   Skipped (< $minPostsPerTag posts): $skippedTags\n');

  int created = 0;
  int deleted = 0;

  // Generate base page and pagination for each tag
  for (final entry in tagSlugPostCounts.entries) {
    final tagSlug = entry.key;
    final tagName = tagSlugToName[tagSlug] ?? tagSlug;
    final postCount = entry.value;
    final totalPages = (postCount / postsPerPage).ceil();

    // Create base tag page (page 1)
    final basePath = p.join('content/tag', '$tagSlug.md');
    final baseFile = File(basePath);

    final baseFrontmatter =
        '''---
layout: flexible
page-type: archive
tag_slug: $tagSlug
---

<TagPage />
''';

    baseFile.writeAsStringSync(baseFrontmatter);
    created++;
    print('   ✅ Created: $basePath');

    // Create pagination pages (page 2, 3, 4, etc.) if needed
    if (totalPages > 1) {
      for (int pageNum = 2; pageNum <= totalPages; pageNum++) {
        final pagePath = p.join(
          'content/tag',
          tagSlug,
          'page',
          pageNum.toString(),
          'index.md',
        );

        final pageFile = File(pagePath);

        // Create directory if needed
        pageFile.parent.createSync(recursive: true);

        // Create frontmatter
        final frontmatter =
            '''---
layout: flexible
page-type: archive
tag_slug: $tagSlug
page_num: $pageNum
---

<TagPage />
''';

        pageFile.writeAsStringSync(frontmatter);
        created++;
        print('   ✅ Created: $pagePath');
      }
    }

    // Clean up old pagination files if posts decreased
    final tagPaginationDir = Directory(p.join('content/tag', tagSlug, 'page'));
    if (tagPaginationDir.existsSync()) {
      final pageNumDirs = tagPaginationDir.listSync().whereType<Directory>().toList();
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

  print('\n✅ Tag pagination generation complete!');
  print('   Created: $created pages');
  if (deleted > 0) {
    print('   Deleted: $deleted old pages');
  }
}

/// Count posts by tag
Future<void> _countPostsByTag(
  Directory postsDir,
  Map<String, int> tagPostCounts,
) async {
  await for (final entity in postsDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.md') && !entity.path.contains('/page/')) {
      final content = entity.readAsStringSync();
      final frontmatterMatch = RegExp(r'^---\s*\n(.*?)\n---', dotAll: true).firstMatch(content);

      if (frontmatterMatch != null) {
        final yaml = loadYaml(frontmatterMatch.group(1)!);
        final tags = yaml['tags'];

        if (tags is List) {
          for (final tag in tags) {
            final tagStr = tag.toString();
            tagPostCounts[tagStr] = (tagPostCounts[tagStr] ?? 0) + 1;
          }
        }
      }
    }
  }
}

/// Convert tag name to slug (case-insensitive, spaces to hyphens)
String _slugify(String name) {
  return name
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special chars except spaces/hyphens
      .replaceAll(RegExp(r'\s+'), '-'); // Convert spaces to hyphens
}
