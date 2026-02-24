import 'package:shared_preferences/shared_preferences.dart';
import 'package:testemu/core/utils/log/app_log.dart';

/// Service to manage video playback progress across the app
/// Stores and retrieves video watch positions so users can resume from where they left off
class VideoProgressService {
  VideoProgressService._();

  static final VideoProgressService _instance = VideoProgressService._();
  static VideoProgressService get instance => _instance;

  static const String _keyPrefix = 'video_progress_';
  static const double _completionThreshold = 0.95; // 95% watched = completed

  SharedPreferences? _preferences;

  /// Get SharedPreferences instance
  Future<SharedPreferences> _getStorage() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  /// Save video progress position (in seconds)
  /// @param videoId - Unique identifier for the video
  /// @param positionInSeconds - Current playback position in seconds
  /// @param durationInSeconds - Total video duration in seconds
  Future<void> saveProgress({
    required String videoId,
    required int positionInSeconds,
    required int durationInSeconds,
  }) async {
    try {
      if (videoId.isEmpty) return;

      // Don't save if video is completed (watched > 95%)
      if (durationInSeconds > 0) {
        final watchedPercentage = positionInSeconds / durationInSeconds;
        if (watchedPercentage >= _completionThreshold) {
          // Video is completed, clear the progress
          await clearProgress(videoId);
          appLog(
            '✓ Video $videoId completed, progress cleared',
            source: 'VideoProgressService',
          );
          return;
        }
      }

      // Don't save progress for first few seconds
      if (positionInSeconds < 3) {
        return;
      }

      final localStorage = await _getStorage();
      final key = '$_keyPrefix$videoId';
      await localStorage.setInt(key, positionInSeconds);

      appLog(
        'Saved progress for video $videoId: ${positionInSeconds}s / ${durationInSeconds}s',
        source: 'VideoProgressService',
      );
    } catch (e) {
      appLog(
        'Error saving video progress: $e',
        source: 'VideoProgressService',
      );
    }
  }

  /// Get saved video progress position (in seconds)
  /// Returns null if no progress is saved
  Future<int?> getProgress(String videoId) async {
    try {
      if (videoId.isEmpty) return null;

      final localStorage = await _getStorage();
      final key = '$_keyPrefix$videoId';
      final position = localStorage.getInt(key);

      if (position != null && position > 0) {
        appLog(
          'Retrieved progress for video $videoId: ${position}s',
          source: 'VideoProgressService',
        );
      }

      return position;
    } catch (e) {
      appLog(
        'Error retrieving video progress: $e',
        source: 'VideoProgressService',
      );
      return null;
    }
  }

  /// Clear saved progress for a specific video
  Future<void> clearProgress(String videoId) async {
    try {
      if (videoId.isEmpty) return;

      final localStorage = await _getStorage();
      final key = '$_keyPrefix$videoId';
      await localStorage.remove(key);

      appLog(
        'Cleared progress for video $videoId',
        source: 'VideoProgressService',
      );
    } catch (e) {
      appLog(
        'Error clearing video progress: $e',
        source: 'VideoProgressService',
      );
    }
  }

  /// Clear all saved video progress
  Future<void> clearAllProgress() async {
    try {
      final localStorage = await _getStorage();
      final keys = localStorage.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_keyPrefix)) {
          await localStorage.remove(key);
        }
      }

      appLog(
        'Cleared all video progress',
        source: 'VideoProgressService',
      );
    } catch (e) {
      appLog(
        'Error clearing all video progress: $e',
        source: 'VideoProgressService',
      );
    }
  }

  /// Check if video has saved progress
  Future<bool> hasProgress(String videoId) async {
    final position = await getProgress(videoId);
    return position != null && position > 0;
  }
}
