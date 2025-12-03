// TODO 1: Import necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO 2: Import providers
import 'providers/app_provider.dart';

// TODO 3: Import pages
import 'pages/wallpapers_page.dart';
import 'pages/favorites_page.dart';
import 'pages/categories_page.dart';
import 'pages/full_image_page.dart';

// TODO 4: Import utils
import 'utils/themes.dart';
import 'utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO 5: Setup MultiProvider for state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.darkTheme,
        home: const WallpapersPage(),
        routes: {
          AppRoutes.fullImage: (context) => const FullImagePage(),
          AppRoutes.favorites: (context) => const FavoritesPage(),
          AppRoutes.categories: (context) => const CategoriesPage(),
        },
      ),
    );
  }
}