// TODO 81: Import necessary packages
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// TODO 82: Import models and providers
import '../../models/photo_model.dart';

// TODO 83: Define photo grid item widget
class PhotoGridItem extends StatelessWidget {
  final Photo photo;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool showPhotographer;

  const PhotoGridItem({
    super.key,
    required this.photo,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    this.showPhotographer = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // TODO 84: Image container with cached network image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: photo.src.medium,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[800],
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white54),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
              ),
            ),
          ),

          // TODO 85: Bottom gradient for readability
          if (showPhotographer && photo.photographer.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 24, 10, 8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Text(
                    photo.photographer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

          // TODO 86: Favorite button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}