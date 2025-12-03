// TODO 13: Define API Response model
import 'photo_model.dart';

class ApiResponse {
  final int page;
  final int perPage;
  final List<Photo> photos;
  final int totalResults;
  final String nextPage;

  ApiResponse({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    required this.nextPage,
  });

  // TODO 14: Create factory constructor from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      photos: (json['photos'] as List? ?? [])
          .map((photoJson) => Photo.fromJson(photoJson))
          .toList(),
      totalResults: json['total_results'] ?? 0,
      nextPage: json['next_page'] ?? '',
    );
  }
}