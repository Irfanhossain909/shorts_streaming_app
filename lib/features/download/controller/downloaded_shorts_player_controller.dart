import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';
import 'package:testemu/features/download/service/download_service.dart';
import 'package:video_player/video_player.dart';

class DownloadedShortsPlayerController extends GetxController {
  final DownloadService _downloadService = DownloadService.instance;

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
    // Pause previous video
    final previousIndex = currentIndex.value;
    _pauseVideo(previousIndex);

    // Update current index
    currentIndex.value = index;

    // Manage resources
    await _manageControllerResources(index);

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

    final controller = VideoPlayerController.file(videoFile);
    _videoControllers[index] = controller;

    controller.initialize().then((_) {
      // Check if controller was disposed while initializing
      if (_videoControllers[index] != controller) return;

      _loadingStates[index] = false;
      _errorStates[index] = false;
      update();

      // Auto-play if it's the current video
      if (currentIndex.value == index) {
        _playVideo(index);
      }
    }).catchError((error) {
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
      printInfo(info: 'Error initializing video at index $index: $error');
    });

    // Listen for video completion
    controller.addListener(() {
      if (controller.value.position >= controller.value.duration &&
          controller.value.duration.inMilliseconds > 0) {
        // Video completed, restart
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
    }
  }

  void _pauseVideo(int index) {
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isInitialized) {
      controller.pause();
      _playingStates[index] = false;
      update();
    }
  }

  void togglePlayPause() {
    final index = currentIndex.value;
    final controller = _videoControllers[index];

    if (controller != null && controller.value.isInitialized) {
      if (_playingStates[index] == true) {
        controller.pause();
        _playingStates[index] = false;
      } else {
        controller.play();
        _playingStates[index] = true;
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

      _videoControllers.remove(index);
      _loadingStates.remove(index);
      _errorStates.remove(index);
      _playingStates.remove(index);

      update();

      try {
        await controller.dispose();
      } catch (e) {
        printInfo(info: 'Error disposing controller at index $index: $e');
      }
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
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
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
      final success = await _downloadService.deleteDownloadedVideo(videoId);

      if (success) {
        Get.snackbar(
          "Success",
          "Video deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
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

        update();
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete video",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error deleting video",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
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

