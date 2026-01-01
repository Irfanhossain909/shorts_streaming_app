class BookmarkResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<Bookmark> data;

  BookmarkResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Bookmark.fromJson(e))
          .toList(),
    );
  }
}

class Bookmark {
  final String id;
  final String userId;
  final String referenceType;
  final TrailerRef? trailer; // only when referenceType == Trailer
  final bool isBookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Bookmark({
    required this.id,
    required this.userId,
    required this.referenceType,
    this.trailer,
    required this.isBookmarked,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    final ref = json['referenceId'];

    return Bookmark(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      referenceType: json['referenceType'] ?? '',
      trailer: ref != null && json['referenceType'] == 'Trailer'
          ? TrailerRef.fromJson(ref)
          : null,
      isBookmarked: json['isBookmarked'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }
}

class TrailerRef {
  final String id;
  final String title;
  final String duration;
  final String color;
  final String contentName;
  final String description;
  final String videoUrl;
  final String videoId;
  final String libraryId;
  final String thumbnailUrl;
  final String thumbnailUrlWithCache;
  final String status;
  final int views;
  final String uploadedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrailerRef({
    required this.id,
    required this.title,
    required this.duration,
    required this.color,
    required this.contentName,
    required this.description,
    required this.videoUrl,
    required this.videoId,
    required this.libraryId,
    required this.thumbnailUrl,
    required this.thumbnailUrlWithCache,
    required this.status,
    required this.views,
    required this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrailerRef.fromJson(Map<String, dynamic> json) {
    return TrailerRef(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      color: json['color'] ?? '',
      contentName: json['contentName'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      videoId: json['videoId'] ?? '',
      libraryId: json['libraryId'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      thumbnailUrlWithCache: json['thumbnailUrlWithCache'] ?? '',
      status: json['status'] ?? '',
      views: json['views'] ?? 0,
      uploadedBy: json['uploadedBy'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
