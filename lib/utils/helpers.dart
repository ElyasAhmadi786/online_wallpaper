// TODO 60: Import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// TODO 61: Define helper functions for common operations
class AppHelpers {
  // TODO 62: Show success snackbar
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TODO 63: Show error snackbar
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // TODO 64: Show info snackbar
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // TODO 65: Show confirmation dialog
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // TODO 66: Check if platform is web
  static bool get isWeb => kIsWeb;

  // TODO 67: Get appropriate image URL based on quality
  static String getImageUrl(Map<String, dynamic> src, {String quality = 'medium'}) {
    switch (quality) {
      case 'original':
        return src['original'] ?? '';
      case 'large2x':
        return src['large2x'] ?? '';
      case 'large':
        return src['large'] ?? '';
      case 'portrait':
        return src['portrait'] ?? '';
      case 'landscape':
        return src['landscape'] ?? '';
      case 'tiny':
        return src['tiny'] ?? '';
      default: // medium
        return src['medium'] ?? '';
    }
  }

  // TODO 68: Format file name for download
  static String formatFileName(String photographer, int id, {String extension = 'jpg'}) {
    final cleanName = photographer.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return 'wallpaper_${cleanName}_$id.$extension';
  }
}