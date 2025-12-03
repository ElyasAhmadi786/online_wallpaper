// TODO 33: Import necessary packages
import 'package:flutter/material.dart';

// TODO 34: Import models and services
import '../models/photo_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

// TODO 35: Define App Provider for state management
class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // TODO 36: Define state variables
  List<Photo> _photos = [];
  List<Photo> _favorites = [];
  List<Photo> _natureWallpapers = [];
  List<Photo> _abstractWallpapers = [];
  List<Photo> _technologyWallpapers = [];
  List<Photo> _animalsWallpapers = [];
  List<Photo> _spaceWallpapers = [];
  List<Photo> _searchWallpapers = [];

  int _currentIndex = 0;
  String _currentCategory = 'curated';
  String _searchQuery = ''; // اضافه کردن این خط
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // TODO 37: Define getters
  List<Photo> get photos => _photos;
  List<Photo> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String get currentCategory => _currentCategory;
  int get currentIndex => _currentIndex;
  int get favoritesCount => _favorites.length;
  String get searchQuery => _searchQuery; // اضافه کردن این خط

  // TODO 38: Get current list based on category
  List<Photo> getCurrentList() {
    switch (_currentCategory) {
      case 'nature':
        return _natureWallpapers;
      case 'abstract':
        return _abstractWallpapers;
      case 'technology':
        return _technologyWallpapers;
      case 'animals':
        return _animalsWallpapers;
      case 'space':
        return _spaceWallpapers;
      case 'search':
        return _searchWallpapers;
      default:
        return _photos;
    }
  }

  // TODO 39: Check if photo is favorite
  bool isFavorite(Photo photo) {
    return _favorites.any((fav) => fav.id == photo.id);
  }

  // TODO 40: Initialize app data
  Future<void> initialize() async {
    await loadFavorites();
    await loadCuratedWallpapers();
  }

  // TODO 41: Load curated wallpapers
  Future<void> loadCuratedWallpapers({int page = 1}) async {
    _setLoading(true);
    try {
      final response = await _apiService.getCuratedWallpapers(page: page);
      if (page == 1) {
        _photos = response.photos;
      } else {
        _photos.addAll(response.photos);
      }
      _currentCategory = 'curated';
      _searchQuery = ''; // پاک کردن query جستجو
      _setError(false, '');
      notifyListeners();
    } catch (e) {
      _setError(true, e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // TODO 42: Search wallpapers
  Future<void> searchWallpapers(String query, {int page = 1}) async {
    if (query.isEmpty) return;

    _setLoading(true);
    try {
      final response = await _apiService.searchWallpapers(query, page: page);
      if (page == 1) {
        _searchWallpapers = response.photos;
      } else {
        _searchWallpapers.addAll(response.photos);
      }
      _currentCategory = 'search';
      _searchQuery = query; // ذخیره کردن query
      _setError(false, '');
      notifyListeners();
    } catch (e) {
      _setError(true, e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // TODO 43: Load category wallpapers
  Future<void> loadCategoryWallpapers(String category, {int page = 1}) async {
    _setLoading(true);
    try {
      final response = await _apiService.searchWallpapers(category, page: page);
      if (page == 1) {
        _updateCategoryWallpapers(category, response.photos);
      } else {
        _appendCategoryWallpapers(category, response.photos);
      }
      _currentCategory = category;
      _searchQuery = ''; // پاک کردن query جستجو
      _setError(false, '');
      notifyListeners();
    } catch (e) {
      _setError(true, e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // TODO 44: Update category wallpapers for first page
  void _updateCategoryWallpapers(String category, List<Photo> newWallpapers) {
    switch (category) {
      case 'nature':
        _natureWallpapers = newWallpapers;
        break;
      case 'abstract':
        _abstractWallpapers = newWallpapers;
        break;
      case 'technology':
        _technologyWallpapers = newWallpapers;
        break;
      case 'animals':
        _animalsWallpapers = newWallpapers;
        break;
      case 'space':
        _spaceWallpapers = newWallpapers;
        break;
    }
  }

  // TODO 45: Append category wallpapers for pagination
  void _appendCategoryWallpapers(String category, List<Photo> newWallpapers) {
    switch (category) {
      case 'nature':
        _natureWallpapers.addAll(newWallpapers);
        break;
      case 'abstract':
        _abstractWallpapers.addAll(newWallpapers);
        break;
      case 'technology':
        _technologyWallpapers.addAll(newWallpapers);
        break;
      case 'animals':
        _animalsWallpapers.addAll(newWallpapers);
        break;
      case 'space':
        _spaceWallpapers.addAll(newWallpapers);
        break;
    }
  }

  // TODO 46: Load favorites from storage
  Future<void> loadFavorites() async {
    try {
      _favorites = await _storageService.loadFavorites();
      notifyListeners();
    } catch (e) {
      _setError(true, 'Failed to load favorites: $e');
    }
  }

  // TODO 47: Add to favorites
  Future<void> addToFavorites(Photo photo) async {
    if (!isFavorite(photo)) {
      _favorites.add(photo);
      await _storageService.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  // TODO 48: Remove from favorites
  Future<void> removeFromFavorites(Photo photo) async {
    _favorites.removeWhere((fav) => fav.id == photo.id);
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  // TODO 49: Clear all favorites
  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _storageService.clearAllFavorites();
    notifyListeners();
  }

  // TODO 50: Set current index for full image view
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // TODO 51: Clear category and return to curated
  void clearCategory() {
    _currentCategory = 'curated';
    _searchQuery = '';
    notifyListeners();
  }

  // TODO 52: Helper methods for state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error, String message) {
    _hasError = error;
    _errorMessage = message;
    notifyListeners();
  }
}