// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/_internal/code_block_copy_button.dart'
    as _code_block_copy_button;
import 'package:jaspr_content/components/_internal/tab_bar.dart' as _tab_bar;
import 'package:jaspr_content/components/callout.dart' as _callout;
import 'package:jaspr_content/components/code_block.dart' as _code_block;
import 'package:jaspr_content/components/drop_cap.dart' as _drop_cap;
import 'package:jaspr_content/components/file_tree.dart' as _file_tree;
import 'package:jaspr_content/components/post_break.dart' as _post_break;
import 'package:jaspr_content/components/tabs.dart' as _tabs;
import 'package:jaspr_content/components/theme_toggle.dart' as _theme_toggle;
import 'package:tmtdslt/layout/flexible_layout/components/image_extended.dart'
    as _image_extended;
import 'package:tmtdslt/layout/flexible_layout/components/image_extended_zoomable.dart'
    as _image_extended_zoomable;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _code_block_copy_button.CodeBlockCopyButton:
        ClientTarget<_code_block_copy_button.CodeBlockCopyButton>(
          'jaspr_content:code_block_copy_button',
        ),
    _tab_bar.TabBar: ClientTarget<_tab_bar.TabBar>(
      'jaspr_content:tab_bar',
      params: __tab_barTabBar,
    ),
    _theme_toggle.ThemeToggle: ClientTarget<_theme_toggle.ThemeToggle>(
      'jaspr_content:theme_toggle',
    ),
    _image_extended_zoomable.ZoomableImageExtended:
        ClientTarget<_image_extended_zoomable.ZoomableImageExtended>(
          'image_extended_zoomable',
          params: __image_extended_zoomableZoomableImageExtended,
        ),
  },
  styles: () => [
    ..._tab_bar.TabBar.styles,
    ..._callout.Callout.styles,
    ..._code_block.CodeBlock.styles,
    ..._drop_cap.DropCap.styles,
    ..._file_tree.FileTree.styles,
    ..._post_break.PostBreak.styles,
    ..._tabs.Tabs.styles,
    ..._theme_toggle.ThemeToggleState.styles,
    ..._image_extended.ImageExtended.styles,
    ..._image_extended_zoomable.ZoomableImageExtended.styles,
  ],
);

Map<String, Object?> __tab_barTabBar(_tab_bar.TabBar c) => {
  'initialValue': c.initialValue,
  'items': c.items,
};
Map<String, Object?> __image_extended_zoomableZoomableImageExtended(
  _image_extended_zoomable.ZoomableImageExtended c,
) => {'src': c.src, 'alt': c.alt, 'caption': c.caption, 'title': c.title};
