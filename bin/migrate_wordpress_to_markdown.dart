import 'dart:convert';
import 'dart:io';

import 'package:html2md/html2md.dart' as html2md;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// Configuration
const String wpBaseUrl = 'http://_____Place WordPress Site Here_____/wp-json/wp/v2';
const String author = '___place Author name here___';

// Command-line arguments
bool? downloadImages;
int? postsLimit;
DateTime? afterDate;
DateTime? beforeDate;

void main(List<String> args) async {
  // Parse command-line arguments
  if (!_parseArguments(args)) {
    exit(1);
  }

  print('🚀 Starting WordPress to Markdown Migration...\n');
  print('⚙️  Configuration:');
  print('   - Download images: ${downloadImages! ? "Yes" : "No"}');
  print('   - Posts limit: ${postsLimit != null ? "$postsLimit per batch" : "No limit"}');
  print('   - After date: ${_formatDate(afterDate!)}');
  if (beforeDate != null) print('   - Before date: ${_formatDate(beforeDate!)}');
  print('');

  // Create directories
  final postsDir = Directory('content/posts');
  final imagesDir = Directory('content/images');

  if (!postsDir.existsSync()) postsDir.createSync(recursive: true);
  if (downloadImages! && !imagesDir.existsSync()) imagesDir.createSync(recursive: true);

  int totalPosts = 0;
  int totalImages = 0;
  int page = 1;
  bool hasMore = true;

  while (hasMore) {
    print('📄 Fetching page $page...');

    // Fetch posts ordered by date (oldest first)
    // Build URL with optional date filters
    String url = '$wpBaseUrl/posts?per_page=100&page=$page&_embed&order=asc&orderby=date';
    if (afterDate != null) {
      url += '&after=${afterDate!.toIso8601String()}';
    }
    if (beforeDate != null) {
      url += '&before=${beforeDate!.toIso8601String()}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 400) {
      // WordPress returns 400 when requesting a page beyond available posts
      print('✅ Reached end of posts (no more pages available).');
      break;
    }

    if (response.statusCode != 200) {
      print('❌ Failed to fetch posts: ${response.statusCode}');
      print('   Response: ${response.body}');
      break;
    }

    final List<dynamic> posts = jsonDecode(response.body);

    if (posts.isEmpty) {
      print('✅ No more posts found.');
      break;
    }

    // Show date range for this batch
    if (posts.isNotEmpty) {
      final firstDate = DateTime.parse(posts.first['date'] as String);
      final lastDate = DateTime.parse(posts.last['date'] as String);
      print('📅 Date range: ${_formatDate(firstDate)} to ${_formatDate(lastDate)}');
    }

    int batchCount = 0;
    for (var post in posts) {
      try {
        final slug = post['slug'] as String;
        final title = _cleanHtml(post['title']['rendered'] as String);
        final date = DateTime.parse(post['date'] as String);
        final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        // Extract content and convert to markdown
        String htmlContent = post['content']['rendered'] as String;
        String htmlExcerpt = post['excerpt']['rendered'] as String? ?? '';

        // Download and replace images (if enabled)
        if (downloadImages!) {
          htmlContent = await _processImages(htmlContent, slug, dateStr, imagesDir, date);
          totalImages += _countImages(htmlContent);
        }

        // Convert to markdown
        final markdownContent = html2md.convert(htmlContent);
        final markdownExcerpt = html2md.convert(htmlExcerpt).replaceAll('\n', ' ').trim();

        // Extract tags and categories
        final tags = await _extractTags(post);
        final categories = await _extractCategories(post);

        // Get featured image (if enabled)
        String? featuredImage;
        if (downloadImages! &&
            post['_embedded'] != null &&
            post['_embedded']['wp:featuredmedia'] != null &&
            (post['_embedded']['wp:featuredmedia'] as List).isNotEmpty) {
          final media = (post['_embedded']['wp:featuredmedia'] as List)[0];
          final imageUrl = media['source_url'] as String;
          featuredImage = await _downloadImage(imageUrl, slug, dateStr, 'featured', imagesDir, date);
          if (featuredImage != null) totalImages++;
        }

        // Create frontmatter
        final frontmatter = _createFrontmatter(
          title: title,
          date: dateStr,
          slug: slug,
          excerpt: markdownExcerpt,
          tags: tags,
          categories: categories,
          author: author,
          image: featuredImage,
        );

        // Create markdown file in year/month folder structure
        final year = date.year.toString();
        final yearMonth = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        final postYearDir = Directory(p.join(postsDir.path, year));
        final postMonthDir = Directory(p.join(postYearDir.path, yearMonth));

        if (!postMonthDir.existsSync()) {
          postMonthDir.createSync(recursive: true);
        }

        final filename = '$dateStr-$slug.md';
        final file = File(p.join(postMonthDir.path, filename));
        await file.writeAsString('$frontmatter\n$markdownContent');

        totalPosts++;
        batchCount++;
        print('  ✅ Migrated: $slug');

        // Check if we've reached the batch limit
        if (postsLimit != null && batchCount >= postsLimit!) {
          print('\n⏸️  Reached batch limit of $postsLimit posts.');
          print('📊 Current progress:');
          print('   - Posts migrated so far: $totalPosts');
          if (downloadImages!) print('   - Images downloaded so far: $totalImages');
          print('');
          stdout.write('Continue with next batch? (y/n): ');
          final answer = stdin.readLineSync()?.toLowerCase().trim();
          if (answer != 'y' && answer != 'yes') {
            print('\n⏹️  Migration stopped by user.');
            hasMore = false;
            break;
          }
          print('');
          batchCount = 0;
        }
      } catch (e) {
        print('  ❌ Error migrating post ${post['slug']}: $e');
      }
    }

    page++;
  }

  print('\n🎉 Migration Complete!');
  print('📊 Summary:');
  print('   - Posts migrated: $totalPosts');
  if (downloadImages!) print('   - Images downloaded: $totalImages');
  print('\n📝 Next steps:');
  print('   1. Review the generated markdown files in content/posts/');
  print('   2. Commit to Git: git add content/ && git commit -m "feat: migrate WordPress content"');
  print('   3. Push to GitHub: git push origin main');
}

bool _parseArguments(List<String> args) {
  // Check for help first
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    exit(0);
  }

  bool hasImagesYes = false;
  bool hasImagesNo = false;

  for (var arg in args) {
    if (arg == '--images-yes') {
      hasImagesYes = true;
      downloadImages = true;
    } else if (arg == '--images-no') {
      hasImagesNo = true;
      downloadImages = false;
    } else if (arg.startsWith('--limit=')) {
      final limitStr = arg.substring('--limit='.length);
      postsLimit = int.tryParse(limitStr);
      if (postsLimit == null) {
        print('❌ ERROR: Invalid limit value: $limitStr\n');
        _printHelp();
        return false;
      }
    } else if (arg.startsWith('--after=')) {
      final dateStr = arg.substring('--after='.length);
      afterDate = DateTime.tryParse(dateStr);
      if (afterDate == null) {
        print('❌ ERROR: Invalid --after date: $dateStr. Use YYYY-MM-DD format.\n');
        _printHelp();
        return false;
      }
    } else if (arg.startsWith('--before=')) {
      final dateStr = arg.substring('--before='.length);
      beforeDate = DateTime.tryParse(dateStr);
      if (beforeDate == null) {
        print('❌ ERROR: Invalid --before date: $dateStr. Use YYYY-MM-DD format.\n');
        _printHelp();
        return false;
      }
    } else {
      print('❌ ERROR: Unknown argument: $arg\n');
      _printHelp();
      return false;
    }
  }

  // Validate required parameters
  if (hasImagesYes && hasImagesNo) {
    print('❌ ERROR: Cannot specify both --images-yes and --images-no\n');
    _printHelp();
    return false;
  }

  if (!hasImagesYes && !hasImagesNo) {
    print('❌ ERROR: Must specify either --images-yes or --images-no\n');
    _printHelp();
    return false;
  }

  if (afterDate == null) {
    print('❌ ERROR: --after=YYYY-MM-DD is required\n');
    _printHelp();
    return false;
  }

  return true;
}

void _printHelp() {
  print('WordPress to Markdown Migration Tool');
  print('');
  print('Usage: dart run bin/migrate_wordpress_to_markdown.dart [REQUIRED OPTIONS] [OPTIONAL]');
  print('');
  print('REQUIRED Options:');
  print('  --images-yes          Download images during migration');
  print('  --images-no           Skip downloading images (faster re-runs)');
  print('                        (Must specify one: --images-yes OR --images-no)');
  print('');
  print('  --after=YYYY-MM-DD    Only migrate posts published after this date (REQUIRED)');
  print('');
  print('OPTIONAL Options:');
  print('  --before=YYYY-MM-DD   Only migrate posts published before this date');
  print('  --limit=N             Process N posts per batch, then pause for confirmation');
  print('  --help, -h            Show this help message');
  print('');
  print('Behavior:');
  print('  - Posts are saved to: content/posts/YYYY/YYYY-MM/');
  print('  - Images are saved to: content/images/YYYY/YYYY-MM/');
  print('  - Featured images renamed from -hero to -featured');
  print('  - Posts are fetched in chronological order (oldest first)');
  print('  - Date range is displayed for each batch');
  print('  - Existing files are overwritten with fresh data');
  print('');
  print('Examples:');
  print('  # Migrate all posts from 2019 onwards with images');
  print('  dart run bin/migrate_wordpress_to_markdown.dart --images-yes --after=2019-01-01');
  print('');
  print('  # Migrate posts from 2020 only, without images');
  print('  dart run bin/migrate_wordpress_to_markdown.dart --images-no --after=2020-01-01 --before=2020-12-31');
  print('');
  print('  # Migrate posts from 2019-2021 with images, in batches of 50');
  print(
    '  dart run bin/migrate_wordpress_to_markdown.dart --images-yes --after=2019-01-01 --before=2021-12-31 --limit=50',
  );
  print('');
  print('  # Re-run migration without re-downloading images (faster)');
  print('  dart run bin/migrate_wordpress_to_markdown.dart --images-no --after=2019-01-01');
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _cleanHtml(String html) {
  // First strip HTML tags
  String cleaned = html.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  // Then decode common HTML entities
  cleaned = cleaned
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#8211;', '–') // en-dash
      .replaceAll('&#8212;', '—') // em-dash
      .replaceAll('&#8216;', ''')  // left single quote
      .replaceAll('&#8217;', ''') // right single quote
      .replaceAll('&#8220;', '"') // left double quote
      .replaceAll('&#8221;', '"') // right double quote
      .replaceAll('&#8230;', '…') // ellipsis
      .replaceAll('&nbsp;', ' ') // non-breaking space
      .replaceAll('&rsquo;', ''')  // right single quote (named entity)
      .replaceAll('&lsquo;', ''') // left single quote (named entity)
      .replaceAll('&rdquo;', '"') // right double quote (named entity)
      .replaceAll('&ldquo;', '"') // left double quote (named entity)
      .replaceAll('&ndash;', '–') // en-dash (named entity)
      .replaceAll('&mdash;', '—'); // em-dash (named entity)

  return cleaned;
}

Future<String> _processImages(String html, String slug, String date, Directory imagesDir, DateTime postDate) async {
  final imgRegex = RegExp(r'<img([^>]+)>');
  final srcRegex = RegExp(r'src="([^"]+)"');
  final altRegex = RegExp(r'alt="([^"]*)"');
  final titleRegex = RegExp(r'title="([^"]*)"');

  final matches = imgRegex.allMatches(html);

  String processedHtml = html;
  int imageIndex = 1;

  for (var match in matches) {
    final imgTag = match.group(0)!;
    final attributes = match.group(1)!;

    // Extract src
    final srcMatch = srcRegex.firstMatch(attributes);
    if (srcMatch == null) continue;

    final oldUrl = srcMatch.group(1)!;
    if (!oldUrl.startsWith('http')) continue;

    // Extract alt and title attributes
    final altMatch = altRegex.firstMatch(attributes);
    final altAttr = altMatch?.group(1) ?? '';

    final titleMatch = titleRegex.firstMatch(attributes);
    final titleAttr = titleMatch?.group(1) ?? '';

    // Check if this is the signature image (don't duplicate it)
    String newPath;
    if (oldUrl.contains('______Place filename for post signature here______') ||
        altAttr.toLowerCase().contains('signature')) {
      // Use shared signature image path (web URL, not file path)
      newPath = '/images/______Place filename for post signature here______.png';

      // Download signature image only once if it doesn't exist
      final signatureFile = File('content/images/______Place filename for post signature here______.png');
      if (!signatureFile.existsSync()) {
        final downloaded = await _downloadImage(
          oldUrl,
          'shared',
          'signature',
          '______Place filename for post signature here______',
          imagesDir,
          null, // No date for signature image (stays at root)
        );
        if (downloaded == null) {
          print('    ⚠️  Failed to download signature image, using URL anyway');
        }
      }
    } else {
      // Download regular image with unique filename
      final downloaded = await _downloadImage(oldUrl, slug, date, 'img-$imageIndex', imagesDir, postDate);
      if (downloaded == null) continue;
      newPath = downloaded;
      imageIndex++;
    }

    // Build new image tag based on whether title exists
    String newImgTag;
    if (titleAttr.isNotEmpty) {
      // Has title: use HTML format with only src, alt, and title
      newImgTag =
          '<img src="$newPath"'
          '${altAttr.isNotEmpty ? ' alt="$altAttr"' : ''}'
          ' title="$titleAttr">';
    } else {
      // No title: will be converted to Markdown by html2md, just replace URL
      newImgTag = imgTag.replaceFirst(oldUrl, newPath);
    }

    processedHtml = processedHtml.replaceFirst(imgTag, newImgTag);
  }

  return processedHtml;
}

Future<String?> _downloadImage(
  String url,
  String slug,
  String date,
  String suffix,
  Directory imagesDir,
  DateTime? postDate,
) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return null;

    final ext = p.extension(Uri.parse(url).path);
    final filename = '$date-$slug-$suffix$ext';

    // If postDate is null, save to root (for signature image)
    if (postDate == null) {
      final file = File(p.join(imagesDir.path, filename));
      await file.writeAsBytes(response.bodyBytes);
      return '/images/$filename';
    }

    // Otherwise, save to year/month folder structure
    final year = postDate.year.toString();
    final yearMonth = '${postDate.year}-${postDate.month.toString().padLeft(2, '0')}';
    final imageYearDir = Directory(p.join(imagesDir.path, year));
    final imageMonthDir = Directory(p.join(imageYearDir.path, yearMonth));

    if (!imageMonthDir.existsSync()) {
      imageMonthDir.createSync(recursive: true);
    }

    final file = File(p.join(imageMonthDir.path, filename));
    await file.writeAsBytes(response.bodyBytes);
    return '/images/$year/$yearMonth/$filename';
  } catch (e) {
    print('    ⚠️  Failed to download image: $url');
    return null;
  }
}

int _countImages(String html) {
  return RegExp(r'<img[^>]+>').allMatches(html).length;
}

Future<List<String>> _extractTags(Map<String, dynamic> post) async {
  // Tags are in the _embedded data
  if (post['_embedded'] == null || post['_embedded']['wp:term'] == null) {
    return [];
  }

  final terms = post['_embedded']['wp:term'] as List;
  final tags = <String>[];

  for (var termGroup in terms) {
    for (var term in termGroup) {
      if (term['taxonomy'] == 'post_tag') {
        tags.add(term['name'] as String);
      }
    }
  }

  return tags;
}

Future<List<String>> _extractCategories(Map<String, dynamic> post) async {
  // Categories are in the _embedded data
  if (post['_embedded'] == null || post['_embedded']['wp:term'] == null) {
    return [];
  }

  final terms = post['_embedded']['wp:term'] as List;
  final categories = <String>[];

  for (var termGroup in terms) {
    for (var term in termGroup) {
      if (term['taxonomy'] == 'category') {
        categories.add(term['name'] as String);
      }
    }
  }

  return categories;
}

String _createFrontmatter({
  required String title,
  required String date,
  required String slug,
  required String excerpt,
  required List<String> tags,
  required List<String> categories,
  required String author,
  String? image,
}) {
  final buffer = StringBuffer('---\n');
  buffer.writeln('title: "${title.replaceAll('"', '\\"')}"');
  buffer.writeln('date: $date');
  buffer.writeln('slug: $slug');
  buffer.writeln('excerpt: "${excerpt.replaceAll('"', '\\"')}"');
  if (categories.isNotEmpty) buffer.writeln('categories: ${jsonEncode(categories)}');
  if (tags.isNotEmpty) buffer.writeln('tags: ${jsonEncode(tags)}');
  buffer.writeln('author: $author');
  if (image != null) buffer.writeln('image: $image');
  buffer.writeln('published: true');
  buffer.write('---');

  return buffer.toString();
}
