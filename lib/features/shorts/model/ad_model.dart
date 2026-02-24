class AdResponse {
  final bool success;
  final String message;
  final int statusCode;
  final AdData? data;

  AdResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory AdResponse.fromJson(Map<String, dynamic> json) {
    return AdResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null ? AdData.fromJson(json['data']) : null,
    );
  }
}

class AdData {
  final String id;
  final String name;
  final String videoUrl;
  final String videoId;
  final String libraryId;
  final int views;
  final String downloadUrls;
  final String uploadedBy;
  final String createdAt;
  final String updatedAt;

  AdData({
    required this.id,
    required this.name,
    required this.videoUrl,
    required this.videoId,
    required this.libraryId,
    required this.views,
    required this.downloadUrls,
    required this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdData.fromJson(Map<String, dynamic> json) {
    return AdData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      videoId: json['videoId'] ?? '',
      libraryId: json['libraryId'] ?? '',
      views: json['views'] ?? 0,
      downloadUrls: json['downloadUrls'] ?? '',
      uploadedBy: json['uploadedBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
