// TODO 117: Import necessary packages
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// TODO 118: Import providers, services, and utils
import '../../models/photo_model.dart';
import '../../providers/app_provider.dart';
import '../../services/wallpaper_service.dart';
import '../../utils/helpers.dart';
import '../../utils/constants.dart';

// TODO 119: Define image viewer widget for full screen display
class ImageViewer extends StatefulWidget {
  final Photo photo;
  final bool isFavorite;

  const ImageViewer({
    super.key,
    required this.photo,
    required this.isFavorite,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final WallpaperService _wallpaperService = WallpaperService();
  late bool _isFavorite;
  bool _isSettingWallpaper = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  // TODO 120: Toggle favorite status
  void _toggleFavorite() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    try {
      if (_isFavorite) {
        await provider.removeFromFavorites(widget.photo);
        AppHelpers.showSuccess(context, 'Removed from favorites');
      } else {
        await provider.addToFavorites(widget.photo);
        AppHelpers.showSuccess(context, 'Added to favorites');
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      AppHelpers.showError(context, 'Failed to update favorites');
    }
  }

  // TODO 121: Set as wallpaper
  void _setAsWallpaper() async {
    final imageUrl = widget.photo.src.original;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set as Wallpaper', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        content: const Text('Choose where to set the wallpaper:',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _setWallpaper(imageUrl, WallpaperLocation.homeScreen);
            },
            child: const Text('Home Screen', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _setWallpaper(imageUrl, WallpaperLocation.lockScreen);
            },
            child: const Text('Lock Screen', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _setWallpaper(imageUrl, WallpaperLocation.bothScreens);
            },
            child: const Text('Both Screens', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // TODO 122: Set wallpaper implementation
  Future<void> _setWallpaper(String url, int location) async {
    setState(() {
      _isSettingWallpaper = true;
    });

    try {
      await _wallpaperService.setWallpaper(url, location);
      AppHelpers.showSuccess(context, 'Wallpaper set successfully!');
    } catch (e) {
      AppHelpers.showError(context, 'Failed to set wallpaper: $e');
    } finally {
      setState(() {
        _isSettingWallpaper = false;
      });
    }
  }

  // TODO 123: Download wallpaper
  void _downloadWallpaper() async {
    try {
      final fileName = AppHelpers.formatFileName(
        widget.photo.photographer,
        widget.photo.id,
      );
      await _wallpaperService.downloadWallpaper(
        widget.photo.src.original,
        fileName,
      );
      AppHelpers.showSuccess(context, 'Download started!');
    } catch (e) {
      AppHelpers.showError(context, 'Download failed: $e');
    }
  }

  // TODO 124: Share wallpaper
  void _shareWallpaper() async {
    try {
      await _wallpaperService.shareWallpaper(
        widget.photo.src.original,
        widget.photo.photographer,
      );
    } catch (e) {
      AppHelpers.showError(context, 'Share failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // TODO 125: Interactive image viewer
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: CachedNetworkImage(
              imageUrl: widget.photo.src.large2x,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error, color: Colors.red, size: 50),
              ),
            ),
          ),
        ),

        // TODO 126: Top action buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ],
            ),
          ),
        ),

        // TODO 127: Bottom action buttons
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            children: [
              // نمایش دکمه تنظیم والپیپر فقط در موبایل
              if (!kIsWeb) ...[
                _isSettingWallpaper
                    ? Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
                    : FloatingActionButton(
                  onPressed: _setAsWallpaper,
                  backgroundColor: Colors.blue,
                  mini: true,
                  child: const Icon(Icons.wallpaper),
                ),
                const SizedBox(height: 10),
              ],
              FloatingActionButton(
                onPressed: _downloadWallpaper,
                backgroundColor: Colors.green,
                mini: true,
                child: const Icon(Icons.download),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: _shareWallpaper,
                backgroundColor: Colors.orange,
                mini: true,
                child: const Icon(Icons.share),
              ),
            ],
          ),
        ),

        // TODO 128: Photographer attribution
        if (widget.photo.photographer.isNotEmpty)
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Photo by: ${widget.photo.photographer}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}