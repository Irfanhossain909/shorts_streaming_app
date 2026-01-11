import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';
import 'package:testemu/features/download/service/download_service.dart';
import 'package:testemu/features/shorts/repository/shorts_repository.dart';
import 'package:testemu/features/shorts/widgets/episod_list_bottomsheet.dart';
import 'package:video_player/video_player.dart';

class ShortsScontroller extends GetxController {
  final ShortsRepository repository = ShortsRepository.instance;
  final DownloadService downloadService = DownloadService.instance;

  // Video list
  final List<String> videos = [
    "https://vz-4bdf02a2-a32.b-cdn.net/2797393c-0073-4763-9a4a-21f9588fe2f7/original",
    "https://vz-4bdf02a2-a32.b-cdn.net/2797393c-0073-4763-9a4a-21f9588fe2f7/original",
    "https://vz-4bdf02a2-a32.b-cdn.net/2797393c-0073-4763-9a4a-21f9588fe2f7/original",
    "https://vz-4bdf02a2-a32.b-cdn.net/2797393c-0073-4763-9a4a-21f9588fe2f7/original",
  ];

  // Video metadata (should come from API in real implementation)
  // For now, using sample data
  final List<Map<String, String>> videoMetadata = [
    {
      'title': 'Amazing Short Video 1',
      'description':
          'This is an amazing short video with stunning visuals and great content. Watch till the end!',
      'thumbnailUrl':
          'https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg',
      'episodeNumber': '1',
      'seasonNumber': '1',
    },
    {
      'title': 'Incredible Short Video 2',
      'description':
          'Another incredible short that will blow your mind. Don\'t miss this one!',
      'thumbnailUrl':
          'https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg',
      'episodeNumber': '2',
      'seasonNumber': '1',
    },
    {
      'title': 'Epic Short Video 3',
      'description':
          'An epic journey captured in a short video. Experience the magic!',
      'thumbnailUrl':
          'https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg',
      'episodeNumber': '3',
      'seasonNumber': '1',
    },
    {
      'title': 'Fantastic Short Video 4',
      'description':
          'A fantastic short that showcases creativity at its best. Enjoy!',
      'thumbnailUrl':
          'https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg',
      'episodeNumber': '4',
      'seasonNumber': '1',
    },
  ];

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

  // Getters for current video
  VideoPlayerController? getCurrentVideoController() {
    return _videoControllers[currentIndex.value];
  }

  // Getter for video controller at specific index
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

  @override
  void onInit() {
    super.onInit();
    printInfo(info: 'ShortsScontroller initialized');
    pageController = PageController(initialPage: 0);
    _initializeVideoForIndex(0);
  }

  Future<void> onPageChanged(int index) async {
    // Pause previous video
    final previousIndex = currentIndex.value;
    _pauseVideo(previousIndex);

    // Update current index
    currentIndex.value = index;

    // Strict Mode: Manage resources - keep only THE CURRENT controller
    // Await this to ensure resources are freed before we try to allocate new ones
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

    _loadingStates[index] = true;
    _errorStates[index] = false;
    _playingStates[index] = false;
    update();

    final videoUrl = videos[index];
    final controller = VideoPlayerController.network(videoUrl);

    _videoControllers[index] = controller;

    controller
        .initialize()
        .then((_) {
          // Check if controller was disposed while initializing
          if (_videoControllers[index] != controller) return;

          _loadingStates[index] = false;
          _errorStates[index] = false;
          update();

          // Auto-play if it's the current video
          if (currentIndex.value == index) {
            _playVideo(index);
          }
        })
        .catchError((error) {
          // Check if controller was disposed
          if (_videoControllers[index] != controller) return;

          // Dispose the failed controller immediately to free up the decoder
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

  void seekTo(Duration position, {int? index}) {
    final videoIndex = index ?? currentIndex.value;
    final controller = _videoControllers[videoIndex];
    if (controller != null && controller.value.isInitialized) {
      controller.seekTo(position);
    }
  }

  Future<void> _manageControllerResources(int focusedIndex) async {
    // STRICT MODE: Keep only focusedIndex.
    // Disposing immediate neighbors is necessary for low-end devices (Samsung A20).
    final indicesToKeep = {focusedIndex};

    // Create a list of keys to remove to avoid concurrent modification
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

      // 1. Remove from maps immediately to prevent UI from accessing it
      _videoControllers.remove(index);
      _loadingStates.remove(index);
      _errorStates.remove(index);
      _playingStates.remove(index);

      // 2. Notify UI immediately to unmount the VideoPlayer widget
      update();

      // 3. Dispose the controller safely
      try {
        await controller.dispose();
      } catch (e) {
        printInfo(info: 'Error disposing controller at index $index: $e');
      }
    }
  }

  void showEpisodeListBottomSheet() {
    Get.bottomSheet(isScrollControlled: true, const ListBottomSheet());
  }

  void navigateToDownloadMenu() {
    Get.toNamed(AppRoutes.downloadMenu);
  }

  Future<String> getPrivateVideoPath(String videoId) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/videos/$videoId.mp4';
  }

  Future<String> getVideoLocalPath(String videoId) async {
    final dir = await getApplicationDocumentsDirectory();
    final videoDir = Directory('${dir.path}/videos');
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }
    return '${videoDir.path}/$videoId.mp4';
  }

  Future<bool> isVideoDownloaded(String videoId) async {
    final path = await getVideoLocalPath(videoId);
    return File(path).exists();
  }

  Future<bool> downloadVideo({
    required String url,
    required String savePath,
  }) async {
    try {
      printInfo(info: '📥 Starting download from: $url');
      printInfo(info: '💾 Saving to: $savePath');

      final response = await repository.downloadVideo(
        url,
        savePath,
        onProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            downloadProgress.value = received / total;
            printInfo(info: '⬇️ Download progress: $progress%');
          }
        },
      );

      if (response.statusCode == 200) {
        printInfo(info: '✅ Download completed successfully');
        return true;
      } else {
        printInfo(
          info: '❌ Download failed with status: ${response.statusCode}',
        );
        printInfo(info: 'Response: ${response.data}');
        return false;
      }
    } catch (e) {
      printInfo(info: '❌ Download exception: $e');
      return false;
    }
  }

  // Track download state
  RxBool isDownloading = false.obs;
  RxDouble downloadProgress = 0.0.obs;

  Future<void> downloadCurrentVideo() async {
    printInfo(info: '🚀 downloadCurrentVideo called');

    // Prevent multiple simultaneous downloads
    if (isDownloading.value) {
      printInfo(info: '⏸️ Already downloading, skipping');
      Get.snackbar(
        "Please Wait",
        "Another download is in progress",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final index = currentIndex.value;
    final url = videos[index];
    final videoId = url.hashCode.toString();

    printInfo(info: '📹 Video URL: $url');
    printInfo(info: '🆔 Video ID: $videoId');

    // Check if already downloaded
    try {
      final isAlreadyDownloaded = await downloadService.isVideoDownloaded(
        videoId,
      );
      printInfo(info: '✓ Already downloaded check: $isAlreadyDownloaded');

      if (isAlreadyDownloaded) {
        Get.snackbar(
          "Already Downloaded",
          "This video is already available offline",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    } catch (e) {
      printInfo(info: '❌ Error checking download status: $e');
    }

    // CRITICAL: Pause the video before downloading to free up resources
    printInfo(info: '⏸️ Pausing video before download');
    _pauseVideo(index);

    isDownloading.value = true;
    downloadProgress.value = 0.0;

    Get.snackbar(
      "Downloading",
      "Starting download...",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      showProgressIndicator: true,
    );

    try {
      final path = await getVideoLocalPath(videoId);
      printInfo(info: '💾 Save path: $path');

      // Download in background (non-blocking)
      printInfo(info: '⬇️ Calling downloadVideo method...');
      final success = await downloadVideo(url: url, savePath: path);
      printInfo(info: '✓ downloadVideo returned: $success');

      if (success) {
        printInfo(info: '✅ Download success flag is true');

        // Wait a bit for file system to sync
        await Future.delayed(const Duration(milliseconds: 500));

        // Get file size
        final file = File(path);
        final exists = await file.exists();
        printInfo(info: '📁 File exists check: $exists');

        if (!exists) {
          printInfo(info: '❌ File not found at: $path');
          throw Exception('Downloaded file not found at: $path');
        }

        final fileSize = await file.length();
        printInfo(
          info:
              '📦 File size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
        );

        // Get metadata for this video
        final metadata = index < videoMetadata.length
            ? videoMetadata[index]
            : {
                'title': 'Short Video ${index + 1}',
                'description': 'Enjoy this amazing short video!',
                'thumbnailUrl': '',
                'episodeNumber': '${index + 1}',
                'seasonNumber': '1',
              };

        // Create downloaded video model
        final downloadedVideo = DownloadedVideoModel(
          videoId: videoId,
          title: metadata['title'] ?? 'Short Video ${index + 1}',
          description:
              metadata['description'] ?? 'Enjoy this amazing short video!',
          thumbnailUrl: metadata['thumbnailUrl'] ?? '',
          localPath: path,
          originalUrl: url,
          downloadedAt: DateTime.now(),
          fileSize: fileSize,
          episodeNumber: metadata['episodeNumber'] ?? '',
          seasonNumber: metadata['seasonNumber'] ?? '',
        );

        // Save metadata
        final saved = await downloadService.saveDownloadedVideo(
          downloadedVideo,
        );

        if (saved) {
          Get.snackbar(
            "✓ Downloaded",
            "Video saved successfully",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );

          // Resume video playback after successful download
          _playVideo(index);
        } else {
          Get.snackbar(
            "Warning",
            "Video downloaded but metadata not saved",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        throw Exception('Download failed');
      }
    } catch (e) {
      printInfo(info: 'Download error: $e');
      Get.snackbar(
        "Download Failed",
        "Please check your internet connection and try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Resume video playback after error
      _playVideo(index);
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
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
