class DownloadedVideoModel {
  final String videoId;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String localPath;
  final String originalUrl;
  final DateTime downloadedAt;
  final int fileSize;
  final String episodeNumber;
  final String seasonNumber;

  DownloadedVideoModel({
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.localPath,
    required this.originalUrl,
    required this.downloadedAt,
    required this.fileSize,
    this.episodeNumber = "",
    this.seasonNumber = "",
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'localPath': localPath,
      'originalUrl': originalUrl,
      'downloadedAt': downloadedAt.toIso8601String(),
      'fileSize': fileSize,
      'episodeNumber': episodeNumber,
      'seasonNumber': seasonNumber,
    };
  }

  // Create from JSON
  factory DownloadedVideoModel.fromJson(Map<String, dynamic> json) {
    return DownloadedVideoModel(
      videoId: json['videoId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      localPath: json['localPath'] ?? '',
      originalUrl: json['originalUrl'] ?? '',
      downloadedAt: DateTime.parse(json['downloadedAt']),
      fileSize: json['fileSize'] ?? 0,
      episodeNumber: json['episodeNumber'] ?? '',
      seasonNumber: json['seasonNumber'] ?? '',
    );
  }

  // Format file size
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(2)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  // Format episode info
  String get episodeInfo {
    if (episodeNumber.isNotEmpty && seasonNumber.isNotEmpty) {
      return 'S$seasonNumber E$episodeNumber';
    } else if (episodeNumber.isNotEmpty) {
      return 'EP.$episodeNumber';
    }
    return '';
  }

  DownloadedVideoModel copyWith({
    String? videoId,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? localPath,
    String? originalUrl,
    DateTime? downloadedAt,
    int? fileSize,
    String? episodeNumber,
    String? seasonNumber,
  }) {
    return DownloadedVideoModel(
      videoId: videoId ?? this.videoId,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      localPath: localPath ?? this.localPath,
      originalUrl: originalUrl ?? this.originalUrl,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      fileSize: fileSize ?? this.fileSize,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      seasonNumber: seasonNumber ?? this.seasonNumber,
    );
  }
}


