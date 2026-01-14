import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/services/video_progress/video_progress_service.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';
import 'package:testemu/features/download/service/download_service.dart';
import 'package:testemu/features/shorts/model/shorts_video_model.dart';
import 'package:testemu/features/shorts/repository/shorts_repository.dart';
import 'package:testemu/features/shorts/widgets/episod_list_bottomsheet.dart';
import 'package:video_player/video_player.dart';

class ShortsScontroller extends GetxController {
  final ShortsRepository repository = ShortsRepository.instance;
  final DownloadService downloadService = DownloadService.instance;
  final VideoProgressService progressService = VideoProgressService.instance;

  // API data
  RxList<ShortsVideoItem> shortsVideosList = <ShortsVideoItem>[].obs;
  RxBool isLoadingVideos = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // Timer for periodic progress saving
  Timer? _progressSaveTimer;

  // Video list - will be populated from API
  List<String> get videos {
    return shortsVideosList
        .map((video) => video.downloadUrls ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  // Video metadata - will be populated from API
  List<Map<String, String>> get videoMetadata {
    return shortsVideosList.map((video) {
      return {
        'title': video.title,
        'description': video.description,
        'thumbnailUrl': video.thumbnailUrl,
        'episodeNumber': video.episodeNumber.toString(),
        'seasonNumber': video.seasonId?.seasonNumber.toString() ?? '1',
        'videoId': video.id,
      };
    }).toList();
  }

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
    fetchShortsVideos();
  }

  // Fetch shorts videos from API
  Future<void> fetchShortsVideos() async {
    try {
      isLoadingVideos.value = true;
      hasError.value = false;
      errorMessage.value = '';

      printInfo(info: '🔄 Fetching shorts videos from API...');

      final response = await repository.getShortsVideos();

      if (response.success && response.data.isNotEmpty) {
        shortsVideosList.value = response.data;
        printInfo(
          info: '✅ Successfully fetched ${response.data.length} videos',
        );

        // Initialize first video after data is loaded
        if (videos.isNotEmpty) {
          _initializeVideoForIndex(0);
        }
      } else {
        hasError.value = true;
        errorMessage.value = response.message.isEmpty
            ? 'No videos available'
            : response.message;
        printInfo(info: '❌ Failed to fetch videos: ${errorMessage.value}');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load videos: $e';
      printInfo(info: '❌ Error fetching shorts videos: $e');
    } finally {
      isLoadingVideos.value = false;
    }
  }

  // Refresh videos
  Future<void> refreshVideos() async {
    await fetchShortsVideos();
  }

  Future<void> onPageChanged(int index) async {
    // Pause previous video and save its progress
    final previousIndex = currentIndex.value;
    await _saveVideoProgress(previousIndex);
    _pauseVideo(previousIndex);

    // Update current index
    currentIndex.value = index;

    // Strict Mode: Manage resources - keep only THE CURRENT controller
    // Await this to ensure resources are freed before we try to allocate new ones
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

    _loadingStates[index] = true;
    _errorStates[index] = false;
    _playingStates[index] = false;
    update();

    final videoUrl = videos[index];

    // Configure video player with optimized settings for buffer management
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
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

    // Check if we have valid data
    if (index >= shortsVideosList.length) {
      Get.snackbar(
        "Error",
        "Video not found",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final videoItem = shortsVideosList[index];
    final url = videoItem.downloadUrls ?? '';
    final videoId = videoItem.id;

    if (url.isEmpty) {
      Get.snackbar(
        "Error",
        "Download URL not available",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

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

        // Get video item for metadata
        final videoItem = shortsVideosList[index];

        // Create downloaded video model
        final downloadedVideo = DownloadedVideoModel(
          videoId: videoId,
          title: videoItem.title,
          description: videoItem.description,
          thumbnailUrl: videoItem.thumbnailUrl,
          localPath: path,
          originalUrl: url,
          downloadedAt: DateTime.now(),
          fileSize: fileSize,
          episodeNumber: videoItem.episodeNumber.toString(),
          seasonNumber: videoItem.seasonId?.seasonNumber.toString() ?? '1',
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

  /// Get video ID for the video at given index
  String? _getVideoIdAtIndex(int index) {
    if (index < 0 || index >= videoMetadata.length) return null;
    return videoMetadata[index]['videoId'];
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
            info: '▶️ Resumed video $videoId from ${savedPosition}s',
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
    
    _progressSaveTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (currentIndex.value == index && _playingStates[index] == true) {
          _saveVideoProgress(index);
        }
      },
    );
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
