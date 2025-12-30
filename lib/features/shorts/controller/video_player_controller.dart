import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class VideoPlayerController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isPlaying = false.obs;

  late WebViewController webViewController;

  List<String> videos = [];
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};

    /// ✅ read args
    final String? singleVideo = args['videoUrl'];
    final List<dynamic>? videoList = args['listOfVideos'];
    final int startIndex = args['index'] ?? 0;

    /// ✅ normalize data (MOST IMPORTANT PART)
    if (singleVideo != null && singleVideo.isNotEmpty) {
      videos = [singleVideo]; // 🔥 convert single to list
      currentIndex = 0;
    } else if (videoList != null && videoList.isNotEmpty) {
      videos = List<String>.from(videoList);
      currentIndex = startIndex < videos.length ? startIndex : 0;
    } else {
      hasError.value = true;
      errorMessage.value = 'No video found';
      isLoading.value = false;
      return;
    }

    _initWebView();
    loadVideo(currentIndex);
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
          },
          onPageFinished: (_) {
            isLoading.value = false;
            hasError.value = false;
            isPlaying.value = true; // 🔥 video started
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
  void loadVideo(int index) {
    if (index < 0 || index >= videos.length) return;
    currentIndex = index;
    isLoading.value = true;
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

  void togglePlayPause() {
    webViewController.runJavaScript('''
    var video = document.querySelector("video");
    if (video) {
      if (video.paused) {
        video.play();
      } else {
        video.pause();
      }
    }
  ''');
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
}
