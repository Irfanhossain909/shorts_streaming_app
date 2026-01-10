import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/shorts/controller/shorts_controller.dart';
import 'package:testemu/features/shorts/widgets/reel_button.dart';
import 'package:video_player/video_player.dart';

class ShortsFeedScreen extends StatelessWidget {
  ShortsFeedScreen({super.key});
  final ShortsScontroller controller = Get.put(ShortsScontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShortsScontroller>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: PageView.builder(
            controller: controller.pageController,
            scrollDirection: Axis.vertical,
            itemCount: controller.videos.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              return ShortVideoPlayer(index: index);
            },
          ),
        );
      },
    );
  }
}

class ShortVideoPlayer extends StatelessWidget {
  final int index;
  const ShortVideoPlayer({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShortsScontroller>(
      builder: (controller) {
        final videoController = controller.getVideoController(index);
        final isLoading = controller.isLoadingVideo(index);
        final hasError = controller.hasVideoError(index);
        final isPlaying = controller.isVideoPlaying(index);

        return GestureDetector(
          onTap: () => controller.togglePlayPause(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Background video
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                  ? const Center(
                      child: Text(
                        "Error loading video",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : videoController != null &&
                        videoController.value.isInitialized
                  ? SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: videoController.value.size.width,
                          height: videoController.value.size.height,
                          child: VideoPlayer(videoController),
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),

              /// Play icon overlay
              if (!isPlaying && !isLoading && !hasError)
                const Icon(Icons.play_arrow, size: 64, color: Colors.white),

              /// 🔥 Gradient Shadow from bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 550.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: .8),
                        Colors.black.withValues(alpha: .5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              /// Texts + Progress bar
              if (!isLoading && !hasError && videoController != null)
                Positioned(
                  bottom: 110.h,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: "This is the title of the content",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        color: AppColors.background,
                      ),
                      SizedBox(
                        width: 300.w,
                        child: CommonText(
                          fontSize: 12.sp,
                          color: AppColors.background.withValues(alpha: 0.7),
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text:
                              "This is the description text. It is long and should be shown only in 2 lines initially. When the user clicks 'See more', the full description will be displayed properly without cutting off any part of the text.",
                        ),
                      ),
                      SizedBox(width: 8.h),
                      Row(
                        children: [
                          CommonImage(imageSrc: AppImages.listIc, width: 16),
                          const SizedBox(width: 8),
                          CommonText(
                            text: "EP.1/67 EP",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                        child: VideoProgressIndicator(
                          videoController,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: AppColors.red2,
                            bufferedColor: Colors.grey.withValues(alpha: .5),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              /// Right side action buttons
              Positioned(
                bottom: 146.h,
                right: 10,
                child: Column(
                  spacing: 16.h,
                  children: [
                    InkWell(
                      onTap: () => controller.showEpisodeListBottomSheet(),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: CommonImage(
                            fill: BoxFit.cover,
                            imageSrc:
                                "https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg",
                            width: 56,
                            height: 56,
                          ),
                        ),
                      ),
                    ),
                    ReelButton(imgPath: AppImages.star, text: "125.5K"),
                    ReelButton(
                      imgPath: AppImages.listIc,
                      text: "List",
                      onTap: () => controller.showEpisodeListBottomSheet(),
                    ),
                    ReelButton(imgPath: AppImages.shareIc, text: "Share"),
                    ReelButton(
                      onTap: () => controller.downloadCurrentVideo(),
                      imgPath: AppImages.download,
                      text: "DownLoad",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
