//--- Banner Model ---//
class TrailerResponse {
  final bool success;
  final String message;
  final int statusCode;
  final TrailerData data;

  TrailerResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory TrailerResponse.fromJson(Map<String, dynamic> json) {
    return TrailerResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: TrailerData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

//--- Banner Data Model ---//

class TrailerData {
  final Meta meta;
  final List<Trailer> result;

  TrailerData({required this.meta, required this.result});

  factory TrailerData.fromJson(Map<String, dynamic> json) {
    return TrailerData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      result: (json['result'] as List<dynamic>? ?? [])
          .map((e) => Trailer.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'result': result.map((e) => e.toJson()).toList(),
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

//--- Trailer Model ---//

class Trailer {
  final String id;
  final String title;
  final String duration;
  final String color;
  final String contentName;
  final String description;
  final String videoUrl;
  /// Direct MP4 (etc.) URL for in-app playback; prefer over iframe [videoUrl].
  final String downloadUrls;
  final String videoId;
  final String libraryId;
  final String thumbnailUrl;
  final String thumbnailUrlWithCache;
  final String status;
  final int views;
  final String uploadedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Trailer({
    required this.id,
    required this.title,
    required this.duration,
    required this.color,
    required this.contentName,
    required this.description,
    required this.videoUrl,
    required this.downloadUrls,
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

  static String _sanitizeUrl(dynamic raw) {
    if (raw == null) return '';
    return raw
        .toString()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .trim();
  }

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      color: json['color'] ?? '',
      contentName: json['contentName'] ?? '',
      description: json['description'] ?? '',
      videoUrl: _sanitizeUrl(json['videoUrl']),
      downloadUrls: _sanitizeUrl(json['downloadUrls']),
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'duration': duration,
      'color': color,
      'contentName': contentName,
      'description': description,
      'videoUrl': videoUrl,
      'downloadUrls': downloadUrls,
      'videoId': videoId,
      'libraryId': libraryId,
      'thumbnailUrl': thumbnailUrl,
      'thumbnailUrlWithCache': thumbnailUrlWithCache,
      'status': status,
      'views': views,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
