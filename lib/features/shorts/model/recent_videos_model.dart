class RecentVideosResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<RecentlyViewedItem> data;
  final Meta? meta;

  RecentVideosResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
    this.meta,
  });

  factory RecentVideosResponse.fromJson(Map<String, dynamic> json) {
    return RecentVideosResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => RecentlyViewedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class RecentlyViewedItem {
  final RecentVideo videoId;
  final String id;
  final DateTime viewedAt;

  RecentlyViewedItem({
    required this.videoId,
    required this.id,
    required this.viewedAt,
  });

  factory RecentlyViewedItem.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedItem(
      videoId: RecentVideo.fromJson(json['videoId'] as Map<String, dynamic>),
      id: json['_id'] ?? '',
      viewedAt: DateTime.tryParse(json['viewedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class RecentVideo {
  final String type;
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
  final DownloadUrls? downloadUrls;
  final List<String> likedBy;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSubscribed;
  final bool isAccess;

  RecentVideo({
    required this.type,
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
    this.downloadUrls,
    required this.likedBy,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.isSubscribed,
    required this.isAccess,
  });

  factory RecentVideo.fromJson(Map<String, dynamic> json) {
    // Sanitize videoUrl to remove whitespace and newlines
    String rawVideoUrl = json['videoUrl'] ?? '';
    String sanitizedVideoUrl = rawVideoUrl
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .trim();

    return RecentVideo(
      type: json['type'] ?? 'video',
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
      downloadUrls: json['downloadUrls'] != null
          ? DownloadUrls.fromJson(json['downloadUrls'])
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
}

class DownloadUrls {
  final String original;
  final String hd;
  final String sd;
  final String? mobile;

  DownloadUrls({
    required this.original,
    required this.hd,
    required this.sd,
    this.mobile,
  });

  factory DownloadUrls.fromJson(Map<String, dynamic> json) {
    return DownloadUrls(
      original: json['original'] ?? '',
      hd: json['hd'] ?? '',
      sd: json['sd'] ?? '',
      mobile: json['mobile'],
    );
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;

  Meta({required this.total, required this.page, required this.limit});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(total: json['total'], page: json['page'], limit: json['limit']);
  }
}
