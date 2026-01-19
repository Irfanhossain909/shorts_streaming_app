import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/services/video_progress/video_progress_service.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';
import 'package:testemu/features/download/service/download_service.dart';
import 'package:testemu/features/shorts/model/season_video_details_model.dart';
import 'package:testemu/features/shorts/repository/shorts_repository.dart';
import 'package:testemu/features/shorts/widgets/episode_list_bottomsheet.dart';
import 'package:video_player/video_player.dart';

/// Controller for playing season/episode videos in shorts-style format
/// This controller is optimized for episode playback from video details screen
class EpisodeShortsController extends GetxController {
  final ShortsRepository repository = ShortsRepository.instance;
  final DownloadService downloadService = DownloadService.instance;
  final VideoProgressService progressService = VideoProgressService.instance;

  // Episode videos data
  late List<SeasonVideo> episodeVideos;
  late int initialIndex;

  // Loading state
  RxBool isLoadingVideos = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // Timer for periodic progress saving
  Timer? _progressSaveTimer;

  // Video list - populated from episodes
  List<String> get videos {
    return episodeVideos
        .map((video) => video.downloadUrl)
        .where((url) => url.isNotEmpty)
        .toList();
  }

  // Video metadata
  List<Map<String, String>> get videoMetadata {
    return episodeVideos.map((video) {
      return {
        'title': video.title,
        'description': video.description,
        'thumbnailUrl': video.thumbnailUrl,
        'episodeNumber': video.episodeNumber.toString(),
        'seasonNumber': '1', // Will be updated from actual data if available
        'videoId': video.id,
        'likes': video.likes.toString(),
      };
    }).toList();
  }

  // PageView controller
  late PageController pageController;

  // Current page index
  late RxInt currentIndex;

  // Track if screen is visible
  RxBool isScreenVisible = true.obs;

  // Map to store video controllers for each index
  final Map<int, VideoPlayerController> _videoControllers = {};

  // Map to store loading states for each video
  final Map<int, bool> _loadingStates = {};

  // Map to store error states for each video
  final Map<int, bool> _errorStates = {};

  // Map to store playing states for each video
  final Map<int, bool> _playingStates = {};

  // Map to store like states for each video
  final Map<String, bool> _likeStates = {};

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

    // Get arguments from navigation
    final args = Get.arguments as Map<String, dynamic>;
    episodeVideos = args['episodes'] as List<SeasonVideo>;
    initialIndex = args['initialIndex'] as int? ?? 0;

    printInfo(
      info:
          '📺 EpisodeShortsController initialized with ${episodeVideos.length} episodes',
    );
    printInfo(info: '🎯 Starting at index: $initialIndex');

    // Initialize reactive index
    currentIndex = initialIndex.obs;

    // Initialize page controller with initial index
    pageController = PageController(initialPage: initialIndex);

    // Initialize like states
    for (var video in episodeVideos) {
      _likeStates[video.id] = video.likedBy.isNotEmpty;
    }

    // Initialize first video
    if (videos.isNotEmpty) {
      _initializeVideoForIndex(initialIndex);
    }
  }

  Future<void> onPageChanged(int index) async {
    // Pause previous video and save its progress
    final previousIndex = currentIndex.value;
    await _saveVideoProgress(previousIndex);
    _pauseVideo(previousIndex);

    // Update current index
    currentIndex.value = index;

    // Manage resources - keep only current controller
    await _manageControllerResources(index);

    // Delay to allow native buffers to be released
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

    final downloadUrl = videos[index];

    printInfo(info: '🎬 Initializing video at index $index');
    printInfo(info: '📹 Video URL: $downloadUrl');

    // Validate URL
    if (downloadUrl.isEmpty) {
      printInfo(info: '❌ Video URL is empty');
      _loadingStates[index] = false;
      _errorStates[index] = true;
      update();
      return;
    }

    // Configure video player with optimized settings and proper headers
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(downloadUrl),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
      httpHeaders: {
        'Accept': '*/*',
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
        'Connection': 'keep-alive',
        'Range': 'bytes=0-',
      },
    );

    _videoControllers[index] = controller;

    // Initialize with timeout
    controller
        .initialize()
        .timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            printInfo(info: '⚠️ Video initialization timeout at index $index');
            throw Exception('Video loading timeout - slow network');
          },
        )
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

          printInfo(
            info:
                '✅ Video loaded: ${controller.value.size.width}x${controller.value.size.height}',
          );

          // Load and seek to saved progress
          await _loadVideoProgress(index);

          // Auto-play if it's the current video AND screen is visible
          if (currentIndex.value == index && isScreenVisible.value) {
            _playVideo(index);
          }
        })
        .catchError((error) {
          printInfo(info: '❌ Error initializing video at index $index: $error');
          printInfo(info: '📹 Failed URL: $downloadUrl');

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

          // User-friendly error messages
          final errorString = error.toString().toLowerCase();

          if (errorString.contains('timeout')) {
            Get.snackbar(
              'Slow Network',
              'Video is taking too long to load. Check your internet connection.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          } else if (errorString.contains('unrecognizedinputformat') ||
              errorString.contains('source error')) {
            printInfo(
              info:
                  '⚠️ Video format not recognized - URL may be invalid or inaccessible',
            );
            Get.snackbar(
              'Video Unavailable',
              'This video cannot be played. The file may be corrupted or unavailable.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          } else if (errorString.contains('buffer') ||
              errorString.contains('decoder')) {
            printInfo(
              info:
                  '⚠️ Buffer/Decoder error - device may not support this video quality',
            );
            Get.snackbar(
              'Playback Error',
              'Your device may not support this video quality. Try another video.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          } else {
            // Generic error
            Get.snackbar(
              'Playback Error',
              'Unable to play this video. Please try another one.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          }
        });

    // Listen for video completion
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

  /// Pause current video (called when navigating away)
  void pauseCurrentVideo() {
    isScreenVisible.value = false;
    final index = currentIndex.value;
    _pauseVideo(index);
    _saveVideoProgress(index);
  }

  /// Resume current video (called when navigating back)
  void resumeCurrentVideo() {
    isScreenVisible.value = true;
    final index = currentIndex.value;
    if (_videoControllers.containsKey(index)) {
      _playVideo(index);
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
    // Keep only focused index for low-end devices
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

      try {
        if (controller.value.isInitialized) {
          await controller.pause();
          await controller.setVolume(0);
          await controller.seekTo(Duration.zero);
        }
      } catch (e) {
        printInfo(info: 'Error pausing controller at index $index: $e');
      }

      _videoControllers.remove(index);
      _loadingStates.remove(index);
      _errorStates.remove(index);
      _playingStates.remove(index);

      update();

      await Future.delayed(const Duration(milliseconds: 50));

      try {
        await controller.dispose();
      } catch (e) {
        printInfo(info: 'Error disposing controller at index $index: $e');
      }

      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> toggleLikeVideo(int index) async {
    if (index < 0 || index >= episodeVideos.length) return;

    final videoId = _getVideoIdAtIndex(index);
    if (videoId == null) return;

    final videoItem = episodeVideos[index];
    final currentLikes = videoItem.likes;
    final isCurrentlyLiked =
        _likeStates[videoId] ?? videoItem.likedBy.isNotEmpty;

    final newLikes = isCurrentlyLiked ? currentLikes - 1 : currentLikes + 1;

    // Update local like state
    _likeStates[videoId] = !isCurrentlyLiked;

    // Update in list (optimistic update)
    episodeVideos[index] = SeasonVideo(
      id: videoItem.id,
      title: videoItem.title,
      description: videoItem.description,
      duration: videoItem.duration,
      videoUrl: videoItem.videoUrl,
      videoId: videoItem.videoId,
      libraryId: videoItem.libraryId,
      thumbnailUrl: videoItem.thumbnailUrl,
      movieId: videoItem.movieId,
      seasonId: videoItem.seasonId,
      episodeNumber: videoItem.episodeNumber,
      views: videoItem.views,
      likes: newLikes,
      downloadUrl: videoItem.downloadUrl,
      likedBy: !isCurrentlyLiked ? ['current_user'] : [],
      isDeleted: videoItem.isDeleted,
      isSubscribed: videoItem.isSubscribed,
      isAccess: videoItem.isAccess,
      createdAt: videoItem.createdAt,
      updatedAt: videoItem.updatedAt,
      version: videoItem.version,
    );

    update();

    printInfo(
      info:
          '👍 Optimistically updated like count from $currentLikes to $newLikes',
    );

    // Make API call in background
    try {
      printInfo(info: '📡 Calling API to toggle like for video: $videoId');
      final response = await repository.toggleLikeVideo(videoId);

      if (response.isSuccess) {
        printInfo(info: '✅ Like toggled successfully on server');
      } else {
        printInfo(info: '⚠️ API failed: ${response.message}');
        // Revert on failure
        _likeStates[videoId] = isCurrentlyLiked;
        episodeVideos[index] = videoItem;
        update();
        printInfo(info: '🔄 Reverted like count back to $currentLikes');
      }
    } catch (e) {
      printInfo(info: '❌ Error toggling like: $e');
      _likeStates[videoId] = isCurrentlyLiked;
      episodeVideos[index] = videoItem;
      update();
      printInfo(info: '🔄 Reverted like count due to error');
    }
  }

  void showEpisodeListBottomSheet() {
    Get.bottomSheet(isScrollControlled: true, const EpisodeListBottomSheet());
  }

  void navigateToDownloadMenu() {
    Get.toNamed(AppRoutes.downloadMenu);
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

  // Track download state
  RxBool isDownloading = false.obs;
  RxDouble downloadProgress = 0.0.obs;

  Future<void> downloadCurrentVideo() async {
    printInfo(info: '🚀 downloadCurrentVideo called');

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

    if (index >= episodeVideos.length) {
      Get.snackbar(
        "Error",
        "Video not found",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final videoItem = episodeVideos[index];
    final url = videoItem.downloadUrl;
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

    // Pause video before downloading
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

      final response = await repository.downloadVideo(
        url,
        path,
        onProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      if (response.statusCode == 200) {
        printInfo(info: '✅ Download success');

        await Future.delayed(const Duration(milliseconds: 500));

        final file = File(path);
        final exists = await file.exists();

        if (!exists) {
          throw Exception('Downloaded file not found at: $path');
        }

        final fileSize = await file.length();

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
          seasonNumber: '1',
        );

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

          _playVideo(index);
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

      _playVideo(index);
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  String? _getVideoIdAtIndex(int index) {
    if (index < 0 || index >= videoMetadata.length) return null;
    return videoMetadata[index]['videoId'];
  }

  Future<void> _loadVideoProgress(int index) async {
    final videoId = _getVideoIdAtIndex(index);
    if (videoId == null) return;

    final controller = _videoControllers[index];
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final savedPosition = await progressService.getProgress(videoId);
      if (savedPosition != null && savedPosition > 0) {
        final duration = controller.value.duration.inSeconds;

        if (savedPosition < duration) {
          await controller.seekTo(Duration(seconds: savedPosition));
          printInfo(info: '▶️ Resumed video $videoId from ${savedPosition}s');
        }
      }
    } catch (e) {
      printInfo(info: 'Error loading video progress: $e');
    }
  }

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

  void _startProgressSaveTimer(int index) {
    _stopProgressSaveTimer();

    _progressSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (currentIndex.value == index && _playingStates[index] == true) {
        _saveVideoProgress(index);
      }
    });
  }

  void _stopProgressSaveTimer() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = null;
  }

  @override
  void onClose() {
    _saveVideoProgress(currentIndex.value);
    _stopProgressSaveTimer();

    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    _loadingStates.clear();
    _errorStates.clear();
    _playingStates.clear();
    _likeStates.clear();
    if (pageController.hasClients) {
      pageController.dispose();
    }
    super.onClose();
  }
}
