// TODO 22: Import necessary packages
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// TODO 23: Import models
import '../models/photo_model.dart';

// TODO 24: Define Storage Service class for local data persistence
class StorageService {
  static const String _favoritesKey = 'favorites_list';

  // TODO 25: Save favorites to local storage
  Future<void> saveFavorites(List<Photo> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = favorites.map((photo) => photo.toJson()).toList();
      final encodedFavorites = jsonEncode(favoritesJson);
      await prefs.setString(_favoritesKey, encodedFavorites);
    } catch (e) {
      throw Exception('Error saving favorites: $e');
    }
  }

  // TODO 26: Load favorites from local storage
  Future<List<Photo>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedFavorites = prefs.getString(_favoritesKey);

      if (encodedFavorites != null && encodedFavorites.isNotEmpty) {
        final favoritesJson = jsonDecode(encodedFavorites) as List;
        return favoritesJson.map((json) => Photo.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error loading favorites: $e');
    }
  }

  // TODO 27: Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
    } catch (e) {
      throw Exception('Error clearing favorites: $e');
    }
  }
}