/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/components/drop_cap.dart';
import 'package:jaspr_content/components/file_tree.dart';
import 'package:jaspr_content/components/post_break.dart';
import 'package:jaspr_content/components/tabs.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:tmtdslt/layout/flexible_layout/components/archive_page.dart';
import 'package:tmtdslt/layout/flexible_layout/components/category_page.dart';
import 'package:tmtdslt/layout/flexible_layout/components/home_page.dart';
import 'package:tmtdslt/layout/flexible_layout/components/image_extended.dart';
import 'package:tmtdslt/layout/flexible_layout/components/tag_page.dart';
import 'package:tmtdslt/layout/flexible_layout/constants.dart';
// Import FlexibleLayout for testing
import 'package:tmtdslt/layout/flexible_layout/flex_layout.dart';
import 'package:tmtdslt/layout/flexible_layout/flex_layout_config.dart';
import 'package:tmtdslt/layout/flexible_layout/loaders/filtered_filesystem_loader.dart';
import 'package:tmtdslt/layout/flexible_layout/theme/flex_theme.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Initialize AssetManager to handle images in content/ directory
  final assetManager = AssetManager(
    directory: 'content',
    // Optional: Configure which properties in your frontmatter contain asset paths.
    dataProperties: {'page.image', 'meta.thumbnail'},
  );

  // Add middleware to serve assets during development
  ServerApp.addMiddleware(assetManager.middleware);

  // Create filtered loader that only loads .md files (excludes images)
  final filteredLoader = FilteredFilesystemLoader('content');

  // Starts the app with jaspr_content using our filtered loader
  runApp(
    ContentApp.custom(
      loaders: [filteredLoader],
      eagerlyLoadAllPages: true,
      configResolver: PageConfig.all(
        dataLoaders: [
          FilesystemDataLoader('content/_data'),
          assetManager.dataLoader,
        ],
        theme: ContentTheme(
          // Primary color (links, buttons, highlights)
          primary: ThemeColor(
            Color(FlexTheme.linkLight),
            dark: Color(FlexTheme.linkDark),
          ),
          // Background color
          background: ThemeColor(
            Color(FlexTheme.pageBgLight),
            dark: Color(FlexTheme.pageBgDark),
          ),
          // Text color
          text: ThemeColor(
            Color(FlexTheme.textLight),
            dark: Color(FlexTheme.textDark),
          ),
          // Fonts
          font: FontFamily(FlexTheme.bodyFont),
          codeFont: FontFamily('monospace'),
        ),
        parsers: [
          MarkdownParser(),
        ],
        components: [
          // Home page component (filters and displays recent posts)
          HomePage(),
          // Archive page for displaying posts by month
          ArchivePage(),
          // Category page for displaying posts by category
          CategoryPage(),
          // Tag page for displaying posts by tag
          TagPage(),
          // Renders a callout box with a title and body.  The title is bold and the body is italicized.
          Callout(),
          // Renders a code block with syntax highlighting.
          CodeBlock(),
          // Renders an image with a caption and a lightbox.  The image is responsive and the caption is optional.
          //   Then use the <Image> component in your content files to display images:
          //     <Image src="path/to/image.jpg" alt="Image description" title="Image title" />  ??? does Jaspr support title???
          //     or <Image src="https://placehold.co/600x400" alt="Sample Image" />
          //
          //     To add caption below image, use the caption prop:
          //     <Image src="path/to/image.jpg" alt="Image description" title="Image title" caption="Image caption" /> ??? does Jaspr support title???
          //
          //     The <Image> component also supports zooming of images. To enable zooming, pass the
          //     zoom prop to the image:
          //       <Image src="path/to/image.jpg" alt="Image description" title="Image title" zoom="true" />
          //         This enables zooming of the image when clicked.
          //         The zoom prop is optional and defaults to false.
          //         You can enable zooming globally by passing the zoom prop to the Image component:
          //           Image(zoom: true)
          //             This will enable zooming for all images, both using the <Image> component and
          //             standard Markdown syntax ![Alt text](image url).
          //Image(),
          ImageExtended(),
          // Display content within different tabs.
          Tabs(),
          // A file tree component for displaying directory structures.
          FileTree(),
          // Renders a drop cap for the first letter of a paragraph.  The first letter of a paragraph in a larger font size.
          DropCap(),
          // Renders a post break with a horizontal rule and some vertical space.
          PostBreak(),
        ],
        layouts: [
          // Testing FlexibleLayout (Phase 1)
          FlexibleLayout(
            config: FlexLayoutConfig(
              siteTitle: siteTitle,
              siteDescription: siteDescription,
              siteUrl: siteUrl,
              enableDarkMode: enableDarkMode,
              showSidebar: showSidebar,
              sidebarPosition: FlexSidebarPosition.right,
              footerText: footerText,
              showJasprBadge: showJasprBadge,
            ),
          ),
          // Original BlogLayout (commented out for testing)
          // BlogLayout(
          //   header: Header(
          //     title: 'Too Much To Do; So Little Time...',
          //     logo: '',
          //   ),
          // ),
        ],
        extensions: [
          // Process relative asset paths in page content (markdown/html)
          assetManager.pageExtension,
        ],
      ),
    ),
  );
}
