import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';

class DownloadService {
  DownloadService._();
  static final DownloadService _instance = DownloadService._();
  static DownloadService get instance => _instance;

  static const String _downloadedVideosKey = 'downloaded_videos';

  Future<SharedPreferences> get _storage async =>
      await SharedPreferences.getInstance();

  /// Get all downloaded videos
  Future<List<DownloadedVideoModel>> getAllDownloadedVideos() async {
    try {
      final prefs = await _storage;
      final String? jsonString = prefs.getString(_downloadedVideosKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);

      // Filter out videos where the file no longer exists
      final List<DownloadedVideoModel> videos = [];
      for (var json in jsonList) {
        final video = DownloadedVideoModel.fromJson(json);
        if (await File(video.localPath).exists()) {
          videos.add(video);
        }
      }

      // Update storage if any files were missing
      if (videos.length != jsonList.length) {
        await _saveVideosList(videos);
      }

      return videos;
    } catch (e) {
      return [];
    }
  }

  /// Save a downloaded video metadata
  Future<bool> saveDownloadedVideo(DownloadedVideoModel video) async {
    try {
      final List<DownloadedVideoModel> currentVideos = await getAllDownloadedVideos();

      // Check if video already exists
      final existingIndex = currentVideos.indexWhere(
        (v) => v.videoId == video.videoId,
      );

      if (existingIndex != -1) {
        // Update existing video
        currentVideos[existingIndex] = video;
      } else {
        // Add new video at the beginning
        currentVideos.insert(0, video);
      }

      await _saveVideosList(currentVideos);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete a downloaded video (both metadata and file)
  Future<bool> deleteDownloadedVideo(String videoId) async {
    try {
      final List<DownloadedVideoModel> currentVideos = await getAllDownloadedVideos();

      final videoToDelete = currentVideos.firstWhere(
        (v) => v.videoId == videoId,
        orElse: () => throw Exception('Video not found'),
      );

      // Delete the actual video file
      final file = File(videoToDelete.localPath);
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from list
      currentVideos.removeWhere((v) => v.videoId == videoId);

      // Save updated list
      await _saveVideosList(currentVideos);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete multiple downloaded videos
  Future<bool> deleteMultipleVideos(List<String> videoIds) async {
    try {
      for (String videoId in videoIds) {
        await deleteDownloadedVideo(videoId);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if a video is downloaded
  Future<bool> isVideoDownloaded(String videoId) async {
    try {
      final List<DownloadedVideoModel> videos = await getAllDownloadedVideos();
      return videos.any((v) => v.videoId == videoId);
    } catch (e) {
      return false;
    }
  }

  /// Get a specific downloaded video
  Future<DownloadedVideoModel?> getDownloadedVideo(String videoId) async {
    try {
      final List<DownloadedVideoModel> videos = await getAllDownloadedVideos();
      return videos.firstWhere(
        (v) => v.videoId == videoId,
        orElse: () => throw Exception('Video not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get total downloaded videos count
  Future<int> getDownloadedVideosCount() async {
    final videos = await getAllDownloadedVideos();
    return videos.length;
  }

  /// Get total storage used by downloaded videos
  Future<int> getTotalStorageUsed() async {
    final videos = await getAllDownloadedVideos();
    return videos.fold<int>(0, (sum, video) => sum + video.fileSize);
  }

  /// Format storage size
  String formatStorageSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Clear all downloaded videos
  Future<bool> clearAllDownloads() async {
    try {
      final List<DownloadedVideoModel> videos = await getAllDownloadedVideos();

      // Delete all video files
      for (var video in videos) {
        final file = File(video.localPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Clear storage
      final prefs = await _storage;
      await prefs.remove(_downloadedVideosKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Private helper to save videos list
  Future<void> _saveVideosList(List<DownloadedVideoModel> videos) async {
    final jsonList = videos.map((v) => v.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final prefs = await _storage;
    await prefs.setString(_downloadedVideosKey, jsonString);
  }
}

