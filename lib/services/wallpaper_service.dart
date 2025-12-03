// TODO 28: Import necessary packages
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

import '../utils/constants.dart'; // اضافه کردن این import

// بقیه کد بدون تغییر...
// TODO 29: Define Wallpaper Service class for device operations
class WallpaperService {

  // TODO 30: Set wallpaper on device
  Future<void> setWallpaper(String imageUrl, int location) async {
    if (kIsWeb) {
      throw Exception('Wallpaper setting is not supported on web');
    }

    try {
      // Check storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission is required to set wallpapers');
      }

      // Download image to temporary file
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp_wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(response.bodyBytes);

      // Set wallpaper
      await WallpaperManagerPlus().setWallpaper(file, location);
    } catch (e) {
      throw Exception('Failed to set wallpaper: $e');
    }
  }

  // TODO 31: Download wallpaper - Simple version without shareFiles
  Future<void> downloadWallpaper(String imageUrl, String fileName) async {
    try {
      if (kIsWeb) {
        // For web: Use share with download instructions
        await Share.share(
          'Download this wallpaper: $imageUrl\n\n'
              'To download: Right-click on the image and select "Save image as"',
          subject: 'Wallpaper Download - $fileName',
        );
      } else {
        // For mobile: Download first, then share the file path or URL
        await _downloadAndShareMobile(imageUrl, fileName);
      }
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  // TODO 32: Helper method for mobile download
  Future<void> _downloadAndShareMobile(String imageUrl, String fileName) async {
    try {
      // Download image
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      // Check if file exists
      if (await file.exists()) {
        // Use XFile to share the file
        final xFile = XFile(file.path);
        await Share.shareXFiles([xFile], text: 'Wallpaper: $fileName');
      } else {
        // Fallback: share the URL
        await Share.share(
          'Download this wallpaper: $imageUrl',
          subject: 'Wallpaper Download - $fileName',
        );
      }
    } catch (e) {
      // Fallback to URL sharing if file sharing fails
      await Share.share(
        'Download this wallpaper: $imageUrl',
        subject: 'Wallpaper Download - $fileName',
      );
    }
  }

  // TODO 33: Share wallpaper URL
  Future<void> shareWallpaper(String imageUrl, String photographer) async {
    try {
      String text = 'Check out this amazing wallpaper by $photographer! 🖼️\n\n$imageUrl';
      await Share.share(
        text,
        subject: 'Amazing Wallpaper by $photographer',
      );
    } catch (e) {
      throw Exception('Share failed: $e');
    }
  }

  // TODO 34: Simple download method (URL only)
  Future<void> downloadWallpaperSimple(String imageUrl, String photographer) async {
    try {
      String text = 'Download this wallpaper by $photographer: $imageUrl';
      await Share.share(
        text,
        subject: 'Wallpaper Download',
      );
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }
}
// TODO 35: Set wallpaper with different locations
Future<void> setWallpaper(String imageUrl, int location) async {
  if (kIsWeb) {
    throw Exception('Wallpaper setting is not supported on web');
  }

  try {
    // Check storage permission for Android
    if (defaultTargetPlatform == TargetPlatform.android) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission is required to set wallpapers');
        }
      }
    }

    // Download image to temporary file
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    }

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/temp_wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    // Check if file exists
    if (!await file.exists()) {
      throw Exception('Failed to save image file');
    }

    // Set wallpaper based on location
    String? result;

    switch (location) {
      case WallpaperLocation.homeScreen:
        result = await WallpaperManagerPlus().setWallpaper(
          file,
          WallpaperManagerPlus.homeScreen,
        );
        break;
      case WallpaperLocation.lockScreen:
        result = await WallpaperManagerPlus().setWallpaper(
          file,
          WallpaperManagerPlus.lockScreen,
        );
        break;
      case WallpaperLocation.bothScreens:
        result = await WallpaperManagerPlus().setWallpaper(
          file,
          WallpaperManagerPlus.bothScreens,
        );
        break;
      default:
        result = await WallpaperManagerPlus().setWallpaper(
          file,
          WallpaperManagerPlus.homeScreen,
        );
    }

    if (result != 'Success') {
      throw Exception('Failed to set wallpaper: $result');
    }
  } catch (e) {
    throw Exception('Failed to set wallpaper: $e');
  }
}