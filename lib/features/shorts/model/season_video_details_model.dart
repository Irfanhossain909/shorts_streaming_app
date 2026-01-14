class SeasonVideoResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<SeasonVideo> data;

  SeasonVideoResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory SeasonVideoResponse.fromJson(Map<String, dynamic> json) {
    return SeasonVideoResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SeasonVideo.fromJson(e))
          .toList(),
    );
  }
}

class SeasonVideo {
  final String id;
  final String title;
  final String description;
  final int duration;
  final String videoUrl;
  final String videoId;
  final String libraryId;
  final String thumbnailUrl;
  final String movieId;
  final String seasonId;
  final int episodeNumber;
  final int views;
  final int likes;
  final List<String> likedBy;
  final bool isDeleted;
  final bool isSubscribed;
  final bool isAccess;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  SeasonVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.videoUrl,
    required this.videoId,
    required this.libraryId,
    required this.thumbnailUrl,
    required this.movieId,
    required this.seasonId,
    required this.episodeNumber,
    required this.views,
    required this.likes,
    required this.likedBy,
    required this.isDeleted,
    required this.isSubscribed,
    required this.isAccess,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory SeasonVideo.fromJson(Map<String, dynamic> json) {
    // Sanitize videoUrl to remove whitespace and newlines
    String rawVideoUrl = json['videoUrl'] ?? '';
    String sanitizedVideoUrl = rawVideoUrl
        .replaceAll(RegExp(r'\s+'), '') // Remove all whitespace
        .replaceAll('\n', '') // Remove newlines
        .replaceAll('\r', '') // Remove carriage returns
        .trim();
    
    return SeasonVideo(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      videoUrl: sanitizedVideoUrl,
      videoId: json['videoId'] ?? '',
      libraryId: json['libraryId'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      movieId: json['movieId'] ?? '',
      seasonId: json['seasonId'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      isDeleted: json['isDeleted'] ?? false,
      isSubscribed: json['isSubscribed'] ?? false,
      isAccess: json['isAccess'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      version: json['__v'] ?? 0,
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
      'movieId': movieId,
      'seasonId': seasonId,
      'episodeNumber': episodeNumber,
      'views': views,
      'likes': likes,
      'likedBy': likedBy,
      'isDeleted': isDeleted,
      'isSubscribed': isSubscribed,
      'isAccess': isAccess,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}
