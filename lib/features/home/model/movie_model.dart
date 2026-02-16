//--- Movie Response Model ---//
class MovieResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<Movie> data;
  final Meta meta;

  MovieResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
    required this.meta,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Movie.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

//--- Movie Model ---//
class Movie {
  final String id;
  final String title;
  final String? category;
  final String? categoryId;
  final String? type;
  final String genre;
  final List<String> tags;
  final String description;
  final String accentColor;
  final String? thumbnail;
  final String? bannerUrl;
  final String status;
  final int totalViews;
  final double rating;
  final bool isReleased;
  final bool isDeleted;
  final DateTime releaseDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Movie({
    required this.id,
    required this.title,
    this.category,
    this.categoryId,
    this.type,
    required this.genre,
    required this.tags,
    required this.description,
    required this.accentColor,
    this.thumbnail,
    this.bannerUrl,
    required this.status,
    required this.totalViews,
    required this.rating,
    required this.isReleased,
    required this.isDeleted,
    required this.releaseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'],
      categoryId: json['categoryId'],
      type: json['type'],
      genre: json['genre'] ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      description: json['description'] ?? '',
      accentColor: json['accentColor'] ?? '',
      thumbnail: json['thumbnail'],
      bannerUrl: json['bannerUrl'],
      status: json['status'] ?? '',
      totalViews: json['totalViews'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isReleased: json['isReleased'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      releaseDate:
          DateTime.tryParse(json['releaseDate'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'category': category,
      'categoryId': categoryId,
      'type': type,
      'genre': genre,
      'tags': tags,
      'description': description,
      'accentColor': accentColor,
      'thumbnail': thumbnail,
      'bannerUrl': bannerUrl,
      'status': status,
      'totalViews': totalViews,
      'rating': rating,
      'isReleased': isReleased,
      'isDeleted': isDeleted,
      'releaseDate': releaseDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

//--- Meta Model ---//
class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}
