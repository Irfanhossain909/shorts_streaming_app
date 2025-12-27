class MovieDetailResponse {
  final bool success;
  final String message;
  final int statusCode;
  final MovieDetailData data;

  MovieDetailResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: MovieDetailData.fromJson(json['data'] ?? {}),
    );
  }
}

class MovieDetailData {
  final Movie movie;
  final List<Season> seasons;
  final int totalSeasons;

  MovieDetailData({
    required this.movie,
    required this.seasons,
    required this.totalSeasons,
  });

  factory MovieDetailData.fromJson(Map<String, dynamic> json) {
    return MovieDetailData(
      movie: Movie.fromJson(json['movie'] ?? {}),
      seasons: (json['seasons'] as List<dynamic>? ?? [])
          .map((e) => Season.fromJson(e))
          .toList(),
      totalSeasons: json['totalSeasons'] ?? 0,
    );
  }
}

class Movie {
  final String id;
  final String title;
  final String? category;
  final String? categoryId;
  final String genre;
  final List<String> tags;
  final String description;
  final String accentColor;
  final String? thumbnail;
  final String status;
  final int totalViews;
  final double rating;
  final bool isReleased;
  final bool isDeleted;
  final DateTime releaseDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Movie({
    required this.id,
    required this.title,
    this.category,
    this.categoryId,
    required this.genre,
    required this.tags,
    required this.description,
    required this.accentColor,
    this.thumbnail,
    required this.status,
    required this.totalViews,
    required this.rating,
    required this.isReleased,
    required this.isDeleted,
    required this.releaseDate,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'],
      categoryId: json['categoryId'],
      genre: json['genre'] ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      description: json['description'] ?? '',
      accentColor: json['accentColor'] ?? '',
      thumbnail: json['thumbnail'],
      status: json['status'] ?? '',
      totalViews: json['totalViews'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isReleased: json['isReleased'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      releaseDate:
          DateTime.tryParse(json['releaseDate'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }
}

class Season {
  final String? id;
  final int? seasonNumber;
  final String? seasonTitle;

  Season({this.id, this.seasonNumber, this.seasonTitle});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['seasonId'] ?? json['_id'],
      seasonNumber: json['seasonNumber'],
      seasonTitle: json['seasonTitle'],
    );
  }
}
