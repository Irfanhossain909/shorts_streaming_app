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
  Timer? _loadingTimeoutTimer;
  bool _isInitialized = false;
  int _retryCount = 0;
  static const int _maxRetries = 2;
  static const Duration _loadingTimeout = Duration(
    seconds: 15,
  ); // Timeout for slow networks

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
          onPageStarted: (String url) {
            printInfo(info: '📄 Page started loading: $url');
            isLoading.value = true;
            isPlaying.value = false;
            hasError.value = false;
            _stopProgressTracking();

            // Start timeout timer for slow networks
            _startLoadingTimeout();
          },
          onPageFinished: (String url) async {
            printInfo(info: '✅ Page finished loading: $url');
            _cancelLoadingTimeout();
            isLoading.value = false;

            // Wait for video to be ready (longer delay for embedded players)
            await Future.delayed(const Duration(milliseconds: 1500));

            // Check if video element is ready
            try {
              final hasVideo = await _checkVideoReady();
              if (hasVideo) {
                hasError.value = false;
                isPlaying.value = true;
                _isInitialized = true;

                // Load and seek to saved progress
                await _loadAndSeekToProgress();

                // Start progress tracking
                _startProgressTracking();
              } else {
                printInfo(info: '⚠️ Video element not ready or no sources');
                // Still mark as initialized but don't track progress
                _isInitialized = true;
                isPlaying.value = true;
              }
            } catch (e) {
              printInfo(info: '⚠️ Error checking video readiness: $e');
              // Fail gracefully - still mark as initialized
              _isInitialized = true;
              isPlaying.value = true;
            }
          },
          onWebResourceError: (WebResourceError error) {
            printInfo(info: '❌ Web resource error: ${error.description}');
            _cancelLoadingTimeout();

            if (error.isForMainFrame != null && !error.isForMainFrame!) return;
            if (isPlaying.value) return;

            hasError.value = true;
            isLoading.value = false;

            // Better error messages based on error type
            if (error.description.contains('ERR_CONNECTION_TIMED_OUT') ||
                error.description.contains('ERR_INTERNET_DISCONNECTED')) {
              errorMessage.value =
                  'Slow or no internet connection. Please check your network.';
            } else if (error.description.contains('ERR_NAME_NOT_RESOLVED')) {
              errorMessage.value =
                  'Cannot reach video server. Check your internet connection.';
            } else if (error.description.contains('ERR_ADDRESS_UNREACHABLE')) {
              errorMessage.value =
                  'Video server is unreachable. Try again later.';
            } else {
              errorMessage.value = 'Failed to load video. Try again.';
            }

            // Attempt auto-retry for network errors
            if (_retryCount < _maxRetries &&
                (error.description.contains('ERR_NAME_NOT_RESOLVED') ||
                    error.description.contains('ERR_CONNECTION_TIMED_OUT') ||
                    error.description.contains('ERR_INTERNET_DISCONNECTED'))) {
              _attemptAutoRetry();
            }
          },
        ),
      );

    // Configure Android-specific settings
    if (webViewController.platform is AndroidWebViewController) {
      final androidController =
          webViewController.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);

      // Disable resource loading callbacks to avoid null pointer exceptions
      try {
        androidController.setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            return GeolocationPermissionsResponse(allow: false, retain: false);
          },
        );
      } catch (e) {
        printInfo(info: '⚠️ Could not set geolocation callbacks: $e');
      }
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
    _retryCount = 0; // Reset retry count for new video
    isLoading.value = true;
    _isInitialized = false;

    final videoUrl = videos[index];
    printInfo(info: '📺 Loading video: $videoUrl');

    try {
      webViewController.loadRequest(Uri.parse(videoUrl));
    } catch (e) {
      printInfo(info: '❌ Error loading video URL: $e');
      hasError.value = true;
      errorMessage.value = 'Invalid video URL';
      isLoading.value = false;
    }
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
    printInfo(info: '🔄 Retrying video load (attempt ${_retryCount + 1})');
    hasError.value = false;
    errorMessage.value = '';
    _retryCount++;
    loadVideo(currentIndex);
  }

  /// Auto-retry on network errors
  void _attemptAutoRetry() {
    if (_retryCount < _maxRetries) {
      printInfo(info: '🔄 Auto-retrying video load in 2 seconds...');
      Future.delayed(const Duration(seconds: 2), () {
        if (hasError.value && !isLoading.value) {
          retry();
        }
      });
    } else {
      printInfo(info: '❌ Max retries reached. Giving up.');
    }
  }

  void togglePlayPause() async {
    if (!_isInitialized) return;

    try {
      await webViewController.runJavaScript('''
        (function() {
          try {
            var video = document.querySelector("video");
            if (video) {
              if (video.paused) {
                video.play();
              } else {
                video.pause();
              }
            }
          } catch (e) {
            console.error('Error toggling play/pause:', e);
          }
        })();
      ''');

      // Save progress when paused
      if (isPlaying.value) {
        await _saveCurrentProgress();
      }
    } catch (e) {
      printInfo(info: '⚠️ Error toggling play/pause: $e');
    }
  }

  void seekForward() {
    if (!_isInitialized) return;

    try {
      webViewController.runJavaScript('''
        (function() {
          try {
            var video = document.querySelector("video");
            if (video) {
              video.currentTime += 10;
            }
          } catch (e) {
            console.error('Error seeking forward:', e);
          }
        })();
      ''');
    } catch (e) {
      printInfo(info: '⚠️ Error seeking forward: $e');
    }
  }

  void seekBackward() {
    if (!_isInitialized) return;

    try {
      webViewController.runJavaScript('''
        (function() {
          try {
            var video = document.querySelector("video");
            if (video) {
              video.currentTime -= 10;
            }
          } catch (e) {
            console.error('Error seeking backward:', e);
          }
        })();
      ''');
    } catch (e) {
      printInfo(info: '⚠️ Error seeking backward: $e');
    }
  }

  /// Check if video element is ready
  Future<bool> _checkVideoReady() async {
    try {
      final result = await webViewController.runJavaScriptReturningResult('''
        (function() {
          try {
            var video = document.querySelector("video");
            if (!video) return false;
            // Check if video has sources and is not in error state
            return video.readyState >= 1 && !video.error;
          } catch (e) {
            return false;
          }
        })();
      ''');

      return result == true || result == 1;
    } catch (e) {
      printInfo(info: '⚠️ Error checking video ready: $e');
      return false;
    }
  }

  /// Get current video position from WebView
  Future<double?> _getCurrentPosition() async {
    if (!_isInitialized) return null;

    try {
      final result = await webViewController.runJavaScriptReturningResult('''
        (function() {
          try {
            var video = document.querySelector("video");
            if (!video || video.readyState < 1) return null;
            return video.currentTime || 0;
          } catch (e) {
            return null;
          }
        })();
      ''');

      if (result is num) {
        return result.toDouble();
      }
    } catch (e) {
      printInfo(info: '⚠️ Error getting video position: $e');
    }
    return null;
  }

  /// Get video duration from WebView
  Future<double?> _getVideoDuration() async {
    if (!_isInitialized) return null;

    try {
      final result = await webViewController.runJavaScriptReturningResult('''
        (function() {
          try {
            var video = document.querySelector("video");
            if (!video || video.readyState < 1) return null;
            var duration = video.duration;
            // Check if duration is valid (not NaN or Infinity)
            return (duration && isFinite(duration)) ? duration : null;
          } catch (e) {
            return null;
          }
        })();
      ''');

      if (result is num && result.isFinite && result > 0) {
        return result.toDouble();
      }
    } catch (e) {
      printInfo(info: '⚠️ Error getting video duration: $e');
    }
    return null;
  }

  /// Load saved progress and seek to that position
  Future<void> _loadAndSeekToProgress() async {
    if (!_isInitialized) return;
    if (currentIndex < 0 || currentIndex >= videoIds.length) return;

    final videoId = videoIds[currentIndex];
    try {
      final savedPosition = await progressService.getProgress(videoId);
      if (savedPosition == null || savedPosition <= 3) {
        return; // No saved progress or too early
      }

      // Wait for video to be in ready state
      for (int i = 0; i < 10; i++) {
        final isReady = await _checkVideoReady();
        if (isReady) {
          // Try to seek
          try {
            await webViewController.runJavaScript('''
              (function() {
                try {
                  var video = document.querySelector("video");
                  if (video && video.readyState >= 2 && video.duration > $savedPosition) {
                    // Add event listener to handle seeking
                    video.addEventListener('loadedmetadata', function() {
                      if (video.currentTime < $savedPosition) {
                        video.currentTime = $savedPosition;
                      }
                    }, { once: true });
                    
                    // Try immediate seek if metadata already loaded
                    if (video.readyState >= 2) {
                      video.currentTime = $savedPosition;
                    }
                  }
                } catch (e) {
                  console.error('Error seeking video:', e);
                }
              })();
            ''');
            printInfo(
              info: '▶️ Resumed WebView video $videoId from ${savedPosition}s',
            );
            return;
          } catch (e) {
            printInfo(info: '⚠️ Seek attempt failed: $e');
          }
        }
        // Wait before retry
        await Future.delayed(const Duration(milliseconds: 300));
      }

      printInfo(info: '⚠️ Could not seek video - not ready after 3 seconds');
    } catch (e) {
      printInfo(info: '⚠️ Error loading video progress: $e');
    }
  }

  /// Save current video progress
  Future<void> _saveCurrentProgress() async {
    if (!_isInitialized) return;
    if (currentIndex < 0 || currentIndex >= videoIds.length) return;

    final videoId = videoIds[currentIndex];
    try {
      // Check if video is ready first
      final isReady = await _checkVideoReady();
      if (!isReady) {
        return; // Don't save if video isn't ready
      }

      final position = await _getCurrentPosition();
      final duration = await _getVideoDuration();

      if (position != null &&
          duration != null &&
          duration > 0 &&
          position > 0) {
        await progressService.saveProgress(
          videoId: videoId,
          positionInSeconds: position.toInt(),
          durationInSeconds: duration.toInt(),
        );
      }
    } catch (e) {
      printInfo(info: '⚠️ Error saving video progress: $e');
    }
  }

  /// Start periodic progress tracking
  void _startProgressTracking() {
    _stopProgressTracking();

    _progressSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_isInitialized && isPlaying.value) {
        await _saveCurrentProgress();
      }
    });
  }

  /// Stop progress tracking
  void _stopProgressTracking() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = null;
  }

  /// Start loading timeout timer
  void _startLoadingTimeout() {
    _cancelLoadingTimeout();

    _loadingTimeoutTimer = Timer(_loadingTimeout, () {
      if (isLoading.value) {
        printInfo(info: '⚠️ Video loading timeout - slow network detected');
        hasError.value = true;
        isLoading.value = false;
        errorMessage.value =
            'Video taking too long to load. Your network may be slow. Please try again or check your internet connection.';

        // Attempt auto-retry on timeout
        if (_retryCount < _maxRetries) {
          _attemptAutoRetry();
        }
      }
    });
  }

  /// Cancel loading timeout timer
  void _cancelLoadingTimeout() {
    _loadingTimeoutTimer?.cancel();
    _loadingTimeoutTimer = null;
  }

  @override
  void onClose() {
    try {
      _saveCurrentProgress();
    } catch (e) {
      printInfo(info: '⚠️ Error saving progress on close: $e');
    }
    _stopProgressTracking();
    _cancelLoadingTimeout();
    super.onClose();
  }
}
