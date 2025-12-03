// TODO 141: Import necessary packages
import 'package:flutter/material.dart';

// TODO 142: Import widgets
import '../widgets/favorites/favorite_grid.dart';

// TODO 143: Define favorites page
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Favorite Wallpapers'),
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const FavoriteGrid(),
    );
  }
}