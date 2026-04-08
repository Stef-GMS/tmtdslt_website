// Site configuration
const String siteTitle = 'Too Much To Do; So Little Time...';
const String siteDescription = 'My personal blog about life; technology; and everything in between';
const String siteUrl = 'https://toomuchtodosolittletime.com';
const bool enableDarkMode = true;
const bool showSidebar = true;
//const String sidebarPosition = 'right';
const String footerText = 'Copyright © 2009-2026 TooMuchToDoSoLittleTime.com. All rights reserved.';
const bool showJasprBadge = true;

/// Sidebar position options
enum FlexSidebarPosition {
  left,
  right,
}

/// Format date for display (YYYY-MM-DD format)
String formatDate(DateTime date) {
  final year = date.year.toString();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

// CONFIGURATION: Change this number to show more or fewer recent posts
const int recentPostsToShow = 8;

// CONFIGURATION: Number of posts to show per page on archive/category/tag pages
const int postsPerPage = 10;

// CONFIGURATION: Minimum posts required to generate a tag page
const int minPostsPerTag = 5;

// CONFIGURATION: Maximum length for post titles in navigation (truncate with "...")
const int postNavigationTitleLength = 50;

// CONFIGURATION: Maximum number of tags to display in tag cloud
const int maxTagsInCloud = 30;
