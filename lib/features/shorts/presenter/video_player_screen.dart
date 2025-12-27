import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/features/shorts/controller/video_player_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoPlayerController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /// ================= CONTENT =================
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.hasError.value) {
                return _errorUI(controller);
              }

              /// 🔥 ONLY WEBVIEW
              return WebViewWidget(controller: controller.webViewController!);
            }),

            /// ================= BACK BUTTON =================
            Positioned(
              top: 12.h,
              left: 12.w,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorUI(VideoPlayerController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 60),
          const SizedBox(height: 12),
          Text(
            controller.errorMessage.value.isEmpty
                ? 'Failed to load video'
                : controller.errorMessage.value,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.retry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
