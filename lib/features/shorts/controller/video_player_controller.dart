import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class VideoPlayerController extends GetxController {
  /// state
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isIframe = false.obs;

  WebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    final videoUrl = args?['videoUrl'] ?? '';

    log('=============> Original VideoUrl: $videoUrl');

    if (videoUrl.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'Invalid video url';
      isLoading.value = false;
      return;
    }

    _initIframe(videoUrl);
  }

  /// ================= IFRAME INIT =================
  void _initIframe(String url) {
    isIframe.value = true;

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            isLoading.value = true;
          },
          onPageFinished: (_) {
            isLoading.value = false;
          },
          onWebResourceError: (error) {
            hasError.value = true;
            errorMessage.value = error.description;
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    /// 🔥🔥 CRITICAL FOR ANDROID
    if (webViewController!.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);

      (webViewController!.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  void retry() {
    hasError.value = false;
    errorMessage.value = '';
    isLoading.value = true;

    onInit();
  }

  @override
  void onClose() {
    webViewController = null;
    super.onClose();
  }
}
