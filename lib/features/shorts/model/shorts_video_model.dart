class ShortsVideosResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<ShortsVideoItem> data;

  ShortsVideosResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory ShortsVideosResponse.fromJson(Map<String, dynamic> json) {
    return ShortsVideosResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ShortsVideoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ShortsVideoItem {
  final String id;
  final String title;
  final String description;
  final int duration;
  final String videoUrl;
  final String videoId;
  final String libraryId;
  final String thumbnailUrl;
  final MovieInfo? movieId;
  final SeasonInfo? seasonId;
  final int episodeNumber;
  final int views;
  final int likes;
  final String? downloadUrls;
  final List<String> likedBy;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSubscribed;
  final bool isAccess;

  ShortsVideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.videoUrl,
    required this.videoId,
    required this.libraryId,
    required this.thumbnailUrl,
    this.movieId,
    this.seasonId,
    required this.episodeNumber,
    required this.views,
    required this.likes,
    this.downloadUrls,
    required this.likedBy,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.isSubscribed,
    required this.isAccess,
  });

  factory ShortsVideoItem.fromJson(Map<String, dynamic> json) {
    // Sanitize thumbnailUrl - add https:// if missing
    String rawThumbnailUrl = json['thumbnailUrl'] ?? '';
    String sanitizedThumbnailUrl = rawThumbnailUrl;
    if (rawThumbnailUrl.isNotEmpty &&
        !rawThumbnailUrl.startsWith('http://') &&
        !rawThumbnailUrl.startsWith('https://')) {
      sanitizedThumbnailUrl = 'https://$rawThumbnailUrl';
    }

    // Parse movieId
    MovieInfo? movieInfo;
    if (json['movieId'] != null && json['movieId'] is Map<String, dynamic>) {
      movieInfo = MovieInfo.fromJson(json['movieId'] as Map<String, dynamic>);
    }

    // Parse seasonId
    SeasonInfo? seasonInfo;
    if (json['seasonId'] != null && json['seasonId'] is Map<String, dynamic>) {
      seasonInfo = SeasonInfo.fromJson(
        json['seasonId'] as Map<String, dynamic>,
      );
    }

    return ShortsVideoItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      videoId: json['videoId'] ?? '',
      libraryId: json['libraryId'] ?? '',
      thumbnailUrl: sanitizedThumbnailUrl,
      movieId: movieInfo,
      seasonId: seasonInfo,
      episodeNumber: json['episodeNumber'] ?? 0,
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      downloadUrls: json['downloadUrls'] is String
          ? json['downloadUrls'] as String
          : null,
      likedBy: (json['likedBy'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isSubscribed: json['isSubscribed'] ?? false,
      isAccess: json['isAccess'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'videoUrl': videoUrl,
      'videoId': videoId,
      'libraryId': libraryId,
      'thumbnailUrl': thumbnailUrl,
      'movieId': movieId?.toJson(),
      'seasonId': seasonId?.toJson(),
      'episodeNumber': episodeNumber,
      'views': views,
      'likes': likes,
      'downloadUrls': downloadUrls,
      'likedBy': likedBy,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSubscribed': isSubscribed,
      'isAccess': isAccess,
    };
  }
}

class MovieInfo {
  final String id;
  final String title;

  MovieInfo({required this.id, required this.title});

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(id: json['_id'] ?? '', title: json['title'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'title': title};
  }
}

class SeasonInfo {
  final String id;
  final String title;
  final int seasonNumber;

  SeasonInfo({
    required this.id,
    required this.title,
    required this.seasonNumber,
  });

  factory SeasonInfo.fromJson(Map<String, dynamic> json) {
    return SeasonInfo(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      seasonNumber: json['seasonNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'title': title, 'seasonNumber': seasonNumber};
  }
}
