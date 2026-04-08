import 'package:jaspr_content/jaspr_content.dart';

/// A FilesystemLoader that only loads .md files, excluding binary files like images.
/// This prevents crashes when using eagerlyLoadAllPages: true with images in content/.
class FilteredFilesystemLoader extends FilesystemLoader {
  FilteredFilesystemLoader(super.directory)
      : super(filterExtensions: {'.md'});
}

