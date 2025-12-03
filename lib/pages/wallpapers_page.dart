// TODO 129: Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO 130: Import providers, widgets, and utils
import '../providers/app_provider.dart';
import '../widgets/wallpapers/wallpaper_grid.dart';
import '../widgets/wallpapers/search_dialog.dart';
import '../utils/constants.dart';

// TODO 131: Define wallpapers page
class WallpapersPage extends StatefulWidget {
  const WallpapersPage({super.key});

  @override
  State<WallpapersPage> createState() => _WallpapersPageState();
}

class _WallpapersPageState extends State<WallpapersPage> {
  @override
  void initState() {
    super.initState();
    // TODO 132: Initialize app data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.initialize();
    });
  }

  // TODO 133: Show search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => const SearchDialog(),
    );
  }

  // TODO 134: Return to curated wallpapers
  void _returnToCurated() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.clearCategory();
    provider.loadCuratedWallpapers();
  }

  // TODO 135: Refresh wallpapers
  void _refreshWallpapers() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.loadCuratedWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Wallpapers Gallery',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 1,
        actions: [
          // TODO 136: Categories button
          IconButton(
            icon: const Icon(Icons.category, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.categories);
            },
            tooltip: 'Categories',
          ),

          // TODO 137: Search button
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _showSearchDialog,
            tooltip: 'Search',
          ),

          // TODO 138: Favorites button with badge
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.favorites);
                    },
                    tooltip: 'Favorites',
                  ),
                  if (provider.favoritesCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          provider.favoritesCount.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // TODO 139: Current category indicator
              if (provider.currentCategory != 'curated')
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.blue.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.category, color: Colors.blue, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Category: ${provider.currentCategory}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.blue, size: 16),
                        onPressed: _returnToCurated,
                        tooltip: 'Show Curated',
                      ),
                    ],
                  ),
                ),

              // TODO 140: Wallpaper grid
              Expanded(
                child: WallpaperGrid(
                  enablePullToRefresh: true,
                  onRefresh: _refreshWallpapers,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}