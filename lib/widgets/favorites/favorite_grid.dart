// TODO 108: Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO 109: Import providers and widgets
import '../../providers/app_provider.dart';
import '../../utils/constants.dart';
import '../common/photo_grid_item.dart';
import '../common/error_widget.dart';
import '../../utils/helpers.dart';

// TODO 110: Define favorite grid widget
class FavoriteGrid extends StatelessWidget {
  const FavoriteGrid({super.key});

  // TODO 111: Remove from favorites
  void _removeFromFavorite(BuildContext context, int index) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final photo = provider.favorites[index];

    try {
      await provider.removeFromFavorites(photo);
      AppHelpers.showSuccess(context, 'Removed from favorites');
    } catch (e) {
      AppHelpers.showError(context, 'Failed to remove from favorites');
    }
  }

  // TODO 112: Clear all favorites with confirmation
  void _clearAllFavorites(BuildContext context) async {
    final confirmed = await AppHelpers.showConfirmationDialog(
      context: context,
      title: 'Clear All Favorites',
      content: 'Are you sure you want to remove all favorites?',
      confirmText: 'Clear All',
    );

    if (confirmed == true) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      try {
        await provider.clearAllFavorites();
        AppHelpers.showSuccess(context, 'All favorites cleared');
      } catch (e) {
        AppHelpers.showError(context, 'Failed to clear favorites');
      }
    }
  }

  // TODO 113: Open favorite image in full view
  void _openFavoriteImage(BuildContext context, int index) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final favoritePhoto = provider.favorites[index];

    // Find the photo in current list
    final currentList = provider.getCurrentList();
    final indexInCurrentList = currentList.indexWhere(
            (photo) => photo.id == favoritePhoto.id
    );

    if (indexInCurrentList != -1) {
      provider.setCurrentIndex(indexInCurrentList);
      Navigator.pushNamed(context, AppRoutes.fullImage);
    } else {
      AppHelpers.showInfo(
        context,
        'This wallpaper is from your favorites collection',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;

        // TODO 114: Show empty state for favorites
        if (favorites.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.favorite_border,
            iconColor: Colors.grey,
            title: 'No favorites yet',
            description: 'Tap the heart icon to add wallpapers to your favorites',
            buttonText: 'Browse Wallpapers',
            onButtonPressed: () => Navigator.pop(context),
          );
        }

        return Column(
          children: [
            // TODO 115: Favorites header with count and clear button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${favorites.length} Favorite Wallpapers',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    onPressed: () => _clearAllFavorites(context),
                    tooltip: 'Clear All Favorites',
                  ),
                ],
              ),
            ),

            // TODO 116: Favorites grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: favorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final photo = favorites[index];

                  return PhotoGridItem(
                    photo: photo,
                    isFavorite: true,
                    onTap: () => _openFavoriteImage(context, index),
                    onFavoriteTap: () => _removeFromFavorite(context, index),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}