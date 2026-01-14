import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/services/video_progress/video_progress_service.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';
import 'package:testemu/features/download/service/download_service.dart';
import 'package:video_player/video_player.dart';

class DownloadedShortsPlayerController extends GetxController {
  final DownloadService _downloadService = DownloadService.instance;
  final VideoProgressService progressService = VideoProgressService.instance;

  // Video list
  late List<DownloadedVideoModel> videos;
  late int initialIndex;

  // PageView controller
  late PageController pageController;

  // Current page index
  RxInt currentIndex = 0.obs;

  // Map to store video controllers for each index
  final Map<int, VideoPlayerController> _videoControllers = {};

  // Map to store loading states for each video
  final Map<int, bool> _loadingStates = {};

  // Map to store error states for each video
  final Map<int, bool> _errorStates = {};

  // Map to store playing states for each video
  final Map<int, bool> _playingStates = {};

  // Timer for periodic progress saving
  Timer? _progressSaveTimer;

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    final args = Get.arguments;
    videos = args['videos'] ?? [];
    initialIndex = args['initialIndex'] ?? 0;

    if (videos.isEmpty) {
      Get.back();
      Get.snackbar(
        "Error",
        "No videos available",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    currentIndex.value = initialIndex;
    pageController = PageController(initialPage: initialIndex);
    _initializeVideoForIndex(initialIndex);
  }

  VideoPlayerController? getVideoController(int index) {
    return _videoControllers[index];
  }

  bool isLoadingVideo(int index) {
    return _loadingStates[index] ?? true;
  }

  bool hasVideoError(int index) {
    return _errorStates[index] ?? false;
  }

  bool isVideoPlaying(int index) {
    return _playingStates[index] ?? false;
  }

  Future<void> onPageChanged(int index) async {
    // Pause previous video and save its progress
    final previousIndex = currentIndex.value;
    await _saveVideoProgress(previousIndex);
    _pauseVideo(previousIndex);

    // Update current index
    currentIndex.value = index;

    // Manage resources
    await _manageControllerResources(index);

    // CRITICAL: Add delay to allow native buffers to be fully released
    await Future.delayed(const Duration(milliseconds: 100));

    // Initialize and play new video if not already initialized
    if (!_videoControllers.containsKey(index)) {
      _initializeVideoForIndex(index);
    } else {
      _playVideo(index);
    }
  }

  void _initializeVideoForIndex(int index) {
    if (index < 0 || index >= videos.length) return;

    final video = videos[index];
    final videoFile = File(video.localPath);

    // Check if file exists
    if (!videoFile.existsSync()) {
      _loadingStates[index] = false;
      _errorStates[index] = true;
      _playingStates[index] = false;
      update();
      return;
    }

    _loadingStates[index] = true;
    _errorStates[index] = false;
    _playingStates[index] = false;
    update();

    // Configure video player with optimized settings for buffer management
    final controller = VideoPlayerController.file(
      videoFile,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false, // Don't mix with other audio
        allowBackgroundPlayback: false, // Prevent background playback
      ),
    );

    _videoControllers[index] = controller;

    controller
        .initialize()
        .then((_) async {
          // Check if controller was disposed while initializing
          if (_videoControllers[index] != controller) {
            printInfo(info: 'Controller was disposed during init, cleaning up');
            try {
              controller.dispose();
            } catch (e) {
              printInfo(info: 'Error disposing orphaned controller: $e');
            }
            return;
          }

          _loadingStates[index] = false;
          _errorStates[index] = false;
          update();

          // Load and seek to saved progress
          await _loadVideoProgress(index);

          // Auto-play if it's the current video
          if (currentIndex.value == index) {
            _playVideo(index);
          }
        })
        .catchError((error) {
          printInfo(info: 'Error initializing video at index $index: $error');

          // Check if controller was disposed
          if (_videoControllers[index] != controller) return;

          // Dispose the failed controller
          try {
            controller.dispose();
          } catch (e) {
            printInfo(info: 'Error disposing failed controller: $e');
          }
          _videoControllers.remove(index);

          _loadingStates[index] = false;
          _errorStates[index] = true;
          _playingStates[index] = false;

          update();

          // If error is buffer-related, show helpful message
          if (error.toString().contains('buffer') ||
              error.toString().contains('decoder')) {
            printInfo(
              info:
                  '⚠️ Buffer/Decoder error detected - may need to reduce video quality',
            );
          }
        });

    // Listen for video completion and progress tracking
    controller.addListener(() {
      if (controller.value.position >= controller.value.duration &&
          controller.value.duration.inMilliseconds > 0) {
        // Video completed, clear saved progress and restart
        final videoId = _getVideoIdAtIndex(index);
        if (videoId != null) {
          progressService.clearProgress(videoId);
        }
        controller.seekTo(Duration.zero);
        if (currentIndex.value == index) {
          controller.play();
        }
      }
    });
  }

  void _playVideo(int index) {
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isInitialized) {
      controller.play();
      controller.setLooping(true);
      _playingStates[index] = true;
      update();

      // Start periodic progress saving
      _startProgressSaveTimer(index);
    }
  }

  void _pauseVideo(int index) {
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isInitialized) {
      controller.pause();
      _playingStates[index] = false;
      update();

      // Stop periodic progress saving
      _stopProgressSaveTimer();
    }
  }

  void togglePlayPause() {
    final index = currentIndex.value;
    final controller = _videoControllers[index];

    if (controller != null && controller.value.isInitialized) {
      if (_playingStates[index] == true) {
        controller.pause();
        _playingStates[index] = false;
        _stopProgressSaveTimer();
        // Save progress when manually paused
        _saveVideoProgress(index);
      } else {
        controller.play();
        _playingStates[index] = true;
        _startProgressSaveTimer(index);
      }
      update();
    }
  }

  Future<void> _manageControllerResources(int focusedIndex) async {
    // Keep only focused video
    final indicesToKeep = {focusedIndex};

    final keysToRemove = _videoControllers.keys
        .where((key) => !indicesToKeep.contains(key))
        .toList();

    for (final key in keysToRemove) {
      await _disposeControllerAtIndex(key);
    }
  }

  Future<void> _disposeControllerAtIndex(int index) async {
    final controller = _videoControllers[index];
    if (controller != null) {
      printInfo(info: 'Disposing video controller at index $index');

      // 1. Stop playback and release audio resources first
      try {
        if (controller.value.isInitialized) {
          await controller.pause();
          await controller.setVolume(0);
          // Seek to start to clear any buffered frames
          await controller.seekTo(Duration.zero);
        }
      } catch (e) {
        printInfo(info: 'Error pausing controller at index $index: $e');
      }

      // 2. Remove from maps immediately to prevent UI from accessing it
      _videoControllers.remove(index);
      _loadingStates.remove(index);
      _errorStates.remove(index);
      _playingStates.remove(index);

      // 3. Notify UI immediately to unmount the VideoPlayer widget
      update();

      // 4. Small delay to ensure UI has unmounted the widget
      await Future.delayed(const Duration(milliseconds: 50));

      // 5. Dispose the controller safely and wait for native cleanup
      try {
        await controller.dispose();
      } catch (e) {
        printInfo(info: 'Error disposing controller at index $index: $e');
      }

      // 6. Additional delay to allow native decoder resources to be freed
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void showDeleteConfirmation(String videoId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Delete Video",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to delete this video?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              deleteVideo(videoId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteVideo(String videoId) async {
    try {
      // Find the index of the video to delete
      final deleteIndex = videos.indexWhere((v) => v.videoId == videoId);
      if (deleteIndex == -1) {
        Get.snackbar(
          "Error",
          "Video not found",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // If the video being deleted is currently playing, dispose its controller
      if (deleteIndex == currentIndex.value) {
        await _disposeControllerAtIndex(deleteIndex);
      }

      // Delete from local storage
      final success = await _downloadService.deleteDownloadedVideo(videoId);

      if (success) {
        Get.snackbar(
          "Success",
          "Video deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Remove from current list
        videos.removeWhere((v) => v.videoId == videoId);

        if (videos.isEmpty) {
          Get.back();
          return;
        }

        // Adjust current index if needed
        if (currentIndex.value >= videos.length) {
          currentIndex.value = videos.length - 1;
        }

        // Navigate to the new current video
        pageController.jumpToPage(currentIndex.value);

        // Initialize the new current video
        _initializeVideoForIndex(currentIndex.value);

        update();
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete video",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error deleting video: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Get video ID for the video at given index
  String? _getVideoIdAtIndex(int index) {
    if (index < 0 || index >= videos.length) return null;
    return videos[index].videoId;
  }

  /// Load saved video progress and seek to that position
  Future<void> _loadVideoProgress(int index) async {
    final videoId = _getVideoIdAtIndex(index);
    if (videoId == null) return;

    final controller = _videoControllers[index];
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final savedPosition = await progressService.getProgress(videoId);
      if (savedPosition != null && savedPosition > 0) {
        final duration = controller.value.duration.inSeconds;

        // Only seek if the saved position is valid and less than video duration
        if (savedPosition < duration) {
          await controller.seekTo(Duration(seconds: savedPosition));
          printInfo(
            info: '▶️ Resumed downloaded video $videoId from ${savedPosition}s',
          );
        }
      }
    } catch (e) {
      printInfo(info: 'Error loading video progress: $e');
    }
  }

  /// Save current video progress
  Future<void> _saveVideoProgress(int index) async {
    final videoId = _getVideoIdAtIndex(index);
    if (videoId == null) return;

    final controller = _videoControllers[index];
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final position = controller.value.position.inSeconds;
      final duration = controller.value.duration.inSeconds;

      if (duration > 0) {
        await progressService.saveProgress(
          videoId: videoId,
          positionInSeconds: position,
          durationInSeconds: duration,
        );
      }
    } catch (e) {
      printInfo(info: 'Error saving video progress: $e');
    }
  }

  /// Start timer to periodically save progress
  void _startProgressSaveTimer(int index) {
    _stopProgressSaveTimer();

    _progressSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (currentIndex.value == index && _playingStates[index] == true) {
        _saveVideoProgress(index);
      }
    });
  }

  /// Stop progress save timer
  void _stopProgressSaveTimer() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = null;
  }

  @override
  void onClose() {
    // Save progress before closing
    _saveVideoProgress(currentIndex.value);
    _stopProgressSaveTimer();

    // Dispose all video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    _loadingStates.clear();
    _errorStates.clear();
    _playingStates.clear();
    if (pageController.hasClients) {
      pageController.dispose();
    }
    super.onClose();
  }
}
