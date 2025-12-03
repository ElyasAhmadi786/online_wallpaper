// TODO 15: Import necessary packages
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO 16: Import models
import '../models/api_response_model.dart';

// TODO 17: Define API Service class
class ApiService {
  static const String _baseUrl = 'https://api.pexels.com/v1';
  static const String _apiKey = 'kCvMGYbKdtzok8mHlznVnGcUXCRBfVkjdtoQ8Vc9TT3L8o6gKCE8vbJf';

  // TODO 18: Create headers for API requests
  Map<String, String> get _headers => {
    'Authorization': _apiKey,
  };

  // TODO 19: Fetch curated wallpapers
  Future<ApiResponse> getCuratedWallpapers({int page = 1, int perPage = 30}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/curated?per_page=$perPage&page=$page'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load wallpapers: ${response.statusCode}');
    }
  }

  // TODO 20: Search wallpapers by query
  Future<ApiResponse> searchWallpapers(String query, {int page = 1, int perPage = 30}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?query=$query&per_page=$perPage&page=$page'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to search wallpapers: ${response.statusCode}');
    }
  }

  // TODO 21: Fetch wallpapers by category
  Future<ApiResponse> getCategoryWallpapers(String category, {int page = 1, int perPage = 30}) async {
    return searchWallpapers(category, page: page, perPage: perPage);
  }
}