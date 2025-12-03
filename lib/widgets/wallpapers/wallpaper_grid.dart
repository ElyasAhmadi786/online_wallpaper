// TODO 91: Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO 92: Import providers and widgets
import '../../providers/app_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../common/error_widget.dart';
import '../common/photo_grid_item.dart';
import '../common/loading_indicator.dart';

// TODO 93: Define wallpaper grid widget
class WallpaperGrid extends StatefulWidget {
  final bool enablePullToRefresh;
  final VoidCallback? onRefresh;

  const WallpaperGrid({
    super.key,
    this.enablePullToRefresh = true,
    this.onRefresh,
  });

  @override
  State<WallpaperGrid> createState() => _WallpaperGridState();
}

class _WallpaperGridState extends State<WallpaperGrid> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  String _lastCategory = 'curated';
  String _lastSearchQuery = '';

  @override
  void initState() {
    super.initState();
    // TODO 94: Setup scroll controller for pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<AppProvider>(context, listen: false);
    final currentCategory = provider.currentCategory;

    // Reset pagination when category changes
    if (_lastCategory != currentCategory) {
      _currentPage = 1;
      _lastCategory = currentCategory;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // TODO 95: Handle scroll for pagination
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreWallpapers();
    }
  }

  // TODO 96: Load more wallpapers for pagination
  void _loadMoreWallpapers() async {
    if (_isLoadingMore) return;

    final provider = Provider.of<AppProvider>(context, listen: false);
    final currentCategory = provider.currentCategory;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;

      if (currentCategory == 'curated') {
        await provider.loadCuratedWallpapers(page: _currentPage);
      } else if (currentCategory == 'search') {
        // برای جستجو باید query را ذخیره کنید
        await provider.searchWallpapers(_lastSearchQuery, page: _currentPage);
      } else {
        await provider.loadCategoryWallpapers(currentCategory, page: _currentPage);
      }
    } catch (e) {
      // خطا را مدیریت کنید
      print('Error loading more: $e');
      _currentPage--;
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // TODO 97: Toggle favorite status
  void _toggleFavorite(int index) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final photos = provider.getCurrentList();

    if (index >= photos.length) return;

    final photo = photos[index];

    try {
      if (provider.isFavorite(photo)) {
        await provider.removeFromFavorites(photo);
        AppHelpers.showSuccess(context, 'Removed from favorites');
      } else {
        await provider.addToFavorites(photo);
        AppHelpers.showSuccess(context, 'Added to favorites');
      }
    } catch (e) {
      AppHelpers.showError(context, 'Failed to update favorites');
    }
  }

  // TODO 98: Open full image view
  void _openFullImage(int index) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final photos = provider.getCurrentList();

    if (index >= photos.length) return;

    provider.setCurrentIndex(index);
    Navigator.pushNamed(context, AppRoutes.fullImage);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final photos = provider.getCurrentList();

        // TODO 99: Show loading state
        if (provider.isLoading && photos.isEmpty) {
          return const GridLoadingIndicator();
        }

        // TODO 100: Show error state
        if (provider.hasError && photos.isEmpty) {
          return CustomErrorWidget(
            message: provider.errorMessage,
            onRetry: () => provider.loadCuratedWallpapers(),
          );
        }

        // TODO 101: Show empty state
        if (photos.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.photo_library,
            title: 'No Wallpapers',
            description: 'No wallpapers found. Please check your connection or try again later.',
            buttonText: 'Retry',
            onButtonPressed: () => provider.loadCuratedWallpapers(),
          );
        }

        // TODO 102: Build grid view with refresh indicator
        Widget gridView = GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: photos.length + (_isLoadingMore ? 1 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            // TODO 103: Show loading indicator at the end for pagination
            if (index >= photos.length) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }

            final photo = photos[index];
            final isFavorite = provider.isFavorite(photo);

            return PhotoGridItem(
              photo: photo,
              isFavorite: isFavorite,
              onTap: () => _openFullImage(index),
              onFavoriteTap: () => _toggleFavorite(index),
            );
          },
        );

        if (widget.enablePullToRefresh) {
          return RefreshIndicator(
            onRefresh: () async {
              _currentPage = 1;
              if (widget.onRefresh != null) {
                widget.onRefresh!();
              } else {
                final provider = Provider.of<AppProvider>(context, listen: false);
                if (provider.currentCategory == 'curated') {
                  await provider.loadCuratedWallpapers();
                } else if (provider.currentCategory == 'search') {
                  // برای refresh باید query را داشته باشیم
                  await provider.searchWallpapers(_lastSearchQuery);
                } else {
                  await provider.loadCategoryWallpapers(provider.currentCategory);
                }
              }
            },
            child: gridView,
          );
        } else {
          return gridView;
        }
      },
    );
  }
}