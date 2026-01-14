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
            /// 🔥 SINGLE WEBVIEW (ALWAYS ONE)
            Obx(() {
              if (controller.hasError.value) {
                return _errorUI(controller);
              }

              return Center(
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : WebViewWidget(controller: controller.webViewController),
              );
            }),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Get.height * 0.8.h,
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.videos.length,
                onPageChanged: controller.loadVideo,
                itemBuilder: (_, __) => const SizedBox.expand(),
              ),
            ),

            /// 🔥 GESTURE OVERLAY
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Get.height * 0.9.h,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,

                onTap: () {
                  controller.togglePlayPause();
                },

                onDoubleTapDown: (details) {
                  final width = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx < width / 2) {
                    controller.seekBackward();
                  } else {
                    controller.seekForward();
                  }
                },
              ),
            ),

            /// BACK BUTTON
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 60),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
