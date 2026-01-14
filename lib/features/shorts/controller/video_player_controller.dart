import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/services/video_progress/video_progress_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class VideoPlayerController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isPlaying = false.obs;

  late WebViewController webViewController;
  final VideoProgressService progressService = VideoProgressService.instance;

  List<String> videos = [];
  List<String> videoIds = []; // Store video IDs for progress tracking
  int currentIndex = 0;
  
  Timer? _progressSaveTimer;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};

    /// ✅ read args
    final String? singleVideo = args['videoUrl'];
    final List<dynamic>? videoList = args['listOfVideos'];
    final List<dynamic>? videoIdList = args['videoIds'];
    final String? singleVideoId = args['videoId'];
    final int startIndex = args['index'] ?? 0;

    /// ✅ normalize data (MOST IMPORTANT PART)
    if (singleVideo != null && singleVideo.isNotEmpty) {
      videos = [singleVideo]; // 🔥 convert single to list
      videoIds = [singleVideoId ?? _generateVideoIdFromUrl(singleVideo)];
      currentIndex = 0;
    } else if (videoList != null && videoList.isNotEmpty) {
      videos = List<String>.from(videoList);
      currentIndex = startIndex < videos.length ? startIndex : 0;
      
      // Generate video IDs from list or URLs
      if (videoIdList != null && videoIdList.isNotEmpty) {
        videoIds = List<String>.from(videoIdList);
      } else {
        videoIds = videos.map((url) => _generateVideoIdFromUrl(url)).toList();
      }
    } else {
      hasError.value = true;
      errorMessage.value = 'No video found';
      isLoading.value = false;
      return;
    }

    _initWebView();
    loadVideo(currentIndex);
  }
  
  /// Generate a unique video ID from URL (fallback if no ID provided)
  String _generateVideoIdFromUrl(String url) {
    // Extract video ID from URL or use hash of URL
    final uri = Uri.tryParse(url);
    if (uri != null) {
      // Try to extract YouTube video ID
      if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
        final videoId = uri.queryParameters['v'] ?? uri.pathSegments.lastOrNull;
        if (videoId != null && videoId.isNotEmpty) return videoId;
      }
    }
    // Use hashCode as fallback
    return url.hashCode.abs().toString();
  }

  void _initWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            isLoading.value = true;
            isPlaying.value = false;
            _stopProgressTracking();
          },
          onPageFinished: (_) async {
            isLoading.value = false;
            hasError.value = false;
            isPlaying.value = true; // 🔥 video started
            _isInitialized = true;
            
            // Load and seek to saved progress
            await _loadAndSeekToProgress();
            
            // Start progress tracking
            _startProgressTracking();
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != null && !error.isForMainFrame!) return;
            if (isPlaying.value) return;

            hasError.value = true;
            errorMessage.value = 'Failed to load video';
            isLoading.value = false;
          },
        ),
      );

    if (webViewController.platform is AndroidWebViewController) {
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  /// 🔥 change video safely
  void loadVideo(int index) async {
    if (index < 0 || index >= videos.length) return;
    
    // Save progress of previous video
    if (_isInitialized) {
      await _saveCurrentProgress();
    }
    
    currentIndex = index;
    isLoading.value = true;
    _isInitialized = false;
    webViewController.loadRequest(Uri.parse(videos[index]));
  }

  void playNext() {
    if (currentIndex + 1 < videos.length) {
      loadVideo(currentIndex + 1);
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      loadVideo(currentIndex - 1);
    }
  }

  void retry() {
    if (isLoading.value) return;
    hasError.value = false;
    loadVideo(currentIndex);
  }

  void togglePlayPause() async {
    await webViewController.runJavaScript('''
    var video = document.querySelector("video");
    if (video) {
      if (video.paused) {
        video.play();
      } else {
        video.pause();
      }
    }
  ''');
    
    // Save progress when paused
    if (isPlaying.value) {
      await _saveCurrentProgress();
    }
  }

  void seekForward() {
    webViewController.runJavaScript('''
    var video = document.querySelector("video");
    if (video) {
      video.currentTime += 10;
    }
  ''');
  }

  void seekBackward() {
    webViewController.runJavaScript('''
    var video = document.querySelector("video");
    if (video) {
      video.currentTime -= 10;
    }
  ''');
  }

  /// Get current video position from WebView
  Future<double?> _getCurrentPosition() async {
    try {
      final result = await webViewController.runJavaScriptReturningResult('''
        (function() {
          var video = document.querySelector("video");
          return video ? video.currentTime : 0;
        })();
      ''');
      
      if (result is num) {
        return result.toDouble();
      }
    } catch (e) {
      printInfo(info: 'Error getting video position: $e');
    }
    return null;
  }

  /// Get video duration from WebView
  Future<double?> _getVideoDuration() async {
    try {
      final result = await webViewController.runJavaScriptReturningResult('''
        (function() {
          var video = document.querySelector("video");
          return video ? video.duration : 0;
        })();
      ''');
      
      if (result is num) {
        return result.toDouble();
      }
    } catch (e) {
      printInfo(info: 'Error getting video duration: $e');
    }
    return null;
  }

  /// Load saved progress and seek to that position
  Future<void> _loadAndSeekToProgress() async {
    if (currentIndex < 0 || currentIndex >= videoIds.length) return;
    
    final videoId = videoIds[currentIndex];
    try {
      final savedPosition = await progressService.getProgress(videoId);
      if (savedPosition != null && savedPosition > 3) {
        // Seek to saved position
        await webViewController.runJavaScript('''
          (function() {
            var video = document.querySelector("video");
            if (video) {
              video.currentTime = $savedPosition;
            }
          })();
        ''');
        printInfo(info: '▶️ Resumed WebView video $videoId from ${savedPosition}s');
      }
    } catch (e) {
      printInfo(info: 'Error loading video progress: $e');
    }
  }

  /// Save current video progress
  Future<void> _saveCurrentProgress() async {
    if (currentIndex < 0 || currentIndex >= videoIds.length) return;
    
    final videoId = videoIds[currentIndex];
    try {
      final position = await _getCurrentPosition();
      final duration = await _getVideoDuration();
      
      if (position != null && duration != null && duration > 0) {
        await progressService.saveProgress(
          videoId: videoId,
          positionInSeconds: position.toInt(),
          durationInSeconds: duration.toInt(),
        );
      }
    } catch (e) {
      printInfo(info: 'Error saving video progress: $e');
    }
  }

  /// Start periodic progress tracking
  void _startProgressTracking() {
    _stopProgressTracking();
    
    _progressSaveTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        if (_isInitialized && isPlaying.value) {
          await _saveCurrentProgress();
        }
      },
    );
  }

  /// Stop progress tracking
  void _stopProgressTracking() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = null;
  }

  @override
  void onClose() {
    _saveCurrentProgress();
    _stopProgressTracking();
    super.onClose();
  }
}
