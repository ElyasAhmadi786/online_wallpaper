// TODO 150: Import necessary packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO 151: Import providers and widgets
import '../providers/app_provider.dart';
import '../widgets/full_image/image_viewer.dart';

// TODO 152: Define full image page
class FullImagePage extends StatelessWidget {
  const FullImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final currentList = provider.getCurrentList();

        // TODO 153: Check if current index is valid
        if (currentList.isEmpty || provider.currentIndex >= currentList.length) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  const Text(
                    'Image not available',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        final photo = currentList[provider.currentIndex];
        final isFavorite = provider.isFavorite(photo);

        return Scaffold(
          backgroundColor: Colors.black,
          body: ImageViewer(
            photo: photo,
            isFavorite: isFavorite,
          ),
        );
      },
    );
  }
}