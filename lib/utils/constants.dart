// TODO 52: Define application constants
class AppConstants {
  // TODO 53: API Constants
  static const String apiKey = 'kCvMGYbKdtzok8mHlznVnGcUXCRBfVkjdtoQ8Vc9TT3L8o6gKCE8vbJf';
  static const String baseUrl = 'https://api.pexels.com/v1';
  static const int itemsPerPage = 30;

  // TODO 54: Storage Keys
  static const String favoritesKey = 'favorites_list';

  // TODO 55: Category Constants
  static const List<Map<String, dynamic>> categories = [
    {
      'name': 'Curated',
      'query': 'curated',
      'icon': 'explore',
      'color': 'blue',
    },
    {
      'name': 'Nature',
      'query': 'nature',
      'icon': 'landscape',
      'color': 'green',
    },
    {
      'name': 'Abstract',
      'query': 'abstract',
      'icon': 'brush',
      'color': 'purple',
    },
    {
      'name': 'Technology',
      'query': 'technology',
      'icon': 'computer',
      'color': 'orange',
    },
    {
      'name': 'Animals',
      'query': 'animals',
      'icon': 'pets',
      'color': 'brown',
    },
    {
      'name': 'Space',
      'query': 'space',
      'icon': 'rocket_launch',
      'color': 'indigo',
    },
  ];

  // TODO 56: Error Messages
  static const String networkError = 'Network error occurred';
  static const String loadError = 'Failed to load data';
  static const String favoriteError = 'Failed to update favorites';
  static const String downloadError = 'Download failed';
  static const String wallpaperError = 'Failed to set wallpaper';

  // TODO 57: Success Messages
  static const String favoriteAdded = 'Added to favorites';
  static const String favoriteRemoved = 'Removed from favorites';
  static const String downloadSuccess = 'Download started';
  static const String wallpaperSuccess = 'Wallpaper set successfully';
}

// TODO 58: Define Route Names
class AppRoutes {
  static const String home = '/';
  static const String fullImage = '/full_image';
  static const String favorites = '/favorites';
  static const String categories = '/categories';
}

// TODO 59: Define Wallpaper Locations
class WallpaperLocation {
  static const int homeScreen = 1;
  static const int lockScreen = 2;
  static const int bothScreens = 3;
}