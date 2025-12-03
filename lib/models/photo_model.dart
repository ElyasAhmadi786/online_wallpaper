// TODO 6: Define Photo data model class
class Photo {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final int photographerId;
  final String avgColor;
  final PhotoSrc src;
  final bool liked;
  final String alt;

  Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  // TODO 7: Create factory constructor from JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? 0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
      photographer: json['photographer'] ?? 'Unknown',
      photographerUrl: json['photographer_url'] ?? '',
      photographerId: json['photographer_id'] ?? 0,
      avgColor: json['avg_color'] ?? '',
      src: PhotoSrc.fromJson(json['src'] ?? {}),
      liked: json['liked'] ?? false,
      alt: json['alt'] ?? '',
    );
  }

  // TODO 8: Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
      'photographer': photographer,
      'photographer_url': photographerUrl,
      'photographer_id': photographerId,
      'avg_color': avgColor,
      'src': src.toJson(),
      'liked': liked,
      'alt': alt,
    };
  }

  // TODO 9: Override equality for comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Photo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// TODO 10: Define Photo Source model
class PhotoSrc {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  PhotoSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  // TODO 11: Create factory constructor from JSON
  factory PhotoSrc.fromJson(Map<String, dynamic> json) {
    return PhotoSrc(
      original: json['original'] ?? '',
      large2x: json['large2x'] ?? '',
      large: json['large'] ?? '',
      medium: json['medium'] ?? '',
      small: json['small'] ?? '',
      portrait: json['portrait'] ?? '',
      landscape: json['landscape'] ?? '',
      tiny: json['tiny'] ?? '',
    );
  }

  // TODO 12: Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'large2x': large2x,
      'large': large,
      'medium': medium,
      'small': small,
      'portrait': portrait,
      'landscape': landscape,
      'tiny': tiny,
    };
  }
}