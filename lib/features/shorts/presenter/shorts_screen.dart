import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/shimmer/video_player_shimmer.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_icons.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/features/shorts/controller/shorts_controller.dart';
import 'package:testemu/features/shorts/widgets/ad_overlay_widget.dart';
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
          body: Stack(
            children: [
              Obx(() {
                if (controller.isLoadingVideos.value) {
                  return const VideoPlayerShimmer();
                }

                if (controller.hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.refreshVideos(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.videos.isEmpty) {
                  return const Center(
                    child: Text(
                      "No videos available",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                return PageView.builder(
                  controller: controller.pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.videos.length,
                  onPageChanged: controller.onPageChanged,
                  physics: controller.showAdOverlay.value
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  itemBuilder: (context, index) {
                    return ShortVideoPlayer(index: index);
                  },
                );
              }),

              // Ad interstitial overlay
              Obx(
                () => controller.showAdOverlay.value
                    ? AdOverlayWidget(
                        canClose: controller.canCloseAd,
                        isLoading: controller.isAdLoading,
                        videoUrl: controller.adVideoUrl,
                        onVideoFinished: controller.onAdVideoFinished,
                        onClose: controller.dismissAd,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
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
              /// Background video with shimmer
              isLoading
                  ? const VideoPlayerShimmer()
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
                child: RepaintBoundary(
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
              ),

              /// Texts + Progress bar
              if (!isLoading && !hasError && videoController != null)
                Positioned(
                  bottom: 110.h,
                  left: 20,
                  right: 20,
                  child: RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        // Get metadata for current video
                        final metadata = index < controller.videoMetadata.length
                            ? controller.videoMetadata[index]
                            : null;

                        if (metadata == null) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: metadata['title'] ?? "Short Video",
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
                                color: AppColors.background.withValues(
                                  alpha: 0.7,
                                ),
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                text: metadata['description'] ?? "",
                              ),
                            ),
                            SizedBox(width: 8.h),
                            Row(
                              children: [
                                CommonImage(
                                  imageSrc: AppIcons.icList,
                                  width: 16,
                                ),
                                const SizedBox(width: 8),
                                CommonText(
                                  text:
                                      "EP.${metadata['episodeNumber'] ?? '1'}",
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
                                  bufferedColor: Colors.grey.withValues(
                                    alpha: .5,
                                  ),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

              /// Right side action buttons
              Positioned(
                bottom: 146.h,
                right: 10,
                child: RepaintBoundary(
                  child: Column(
                    spacing: 18.h,
                    children: [
                      RepaintBoundary(
                        child: InkWell(
                          onTap: () => controller.showEpisodeListBottomSheet(),
                          child: Builder(
                            builder: (context) {
                              final metadata =
                                  index < controller.videoMetadata.length
                                  ? controller.videoMetadata[index]
                                  : null;

                              return Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CommonImage(
                                  fill: BoxFit.cover,
                                  borderRadius: 28,
                                  imageSrc:
                                      metadata?['thumbnailUrl'] ??
                                      "https://cdn.pixabay.com/photo/2025/08/09/18/23/knight-9765068_640.jpg",
                                  width: 56,
                                  height: 56,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      RepaintBoundary(
                        child: ReelButton(
                          imgPath: AppIcons.icStar,
                          text:
                              "${(controller.videoMetadata[index]['likes'] ?? '0')} likes",
                          onTap: () async =>
                              await controller.toggleLikeVideo(index),
                        ),
                      ),
                      RepaintBoundary(
                        child: ReelButton(
                          imgPath: AppIcons.icList,
                          text: "List",
                          onTap: () => controller.showEpisodeListBottomSheet(),
                        ),
                      ),
                      RepaintBoundary(
                        child: ReelButton(
                          imgPath: AppIcons.icShare,
                          text: "Share",
                          onTap: () => controller.showShareBottomSheet(),
                        ),
                      ),
                      if (LocalStorage.isSubscribed)
                        Obx(() {
                          final isDownloading = controller.isDownloading.value;
                          final progress = controller.downloadProgress.value;

                          return InkWell(
                            onTap: isDownloading
                                ? null
                                : () => controller.downloadCurrentVideo(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4.h,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  height: 40.w,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (isDownloading)
                                        SizedBox(
                                          width: 40.w,
                                          height: 40.w,
                                          child: CircularProgressIndicator(
                                            value: progress,
                                            strokeWidth: 2.5,
                                            backgroundColor: AppColors.white
                                                .withOpacity(0.3),
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(AppColors.red2),
                                          ),
                                        ),
                                      CommonImage(
                                        imageColor: isDownloading
                                            ? AppColors.red2
                                            : AppColors.background,
                                        imageSrc: AppIcons.icDownload,
                                        width: 24.w,
                                      ),
                                    ],
                                  ),
                                ),
                                CommonText(
                                  text: isDownloading
                                      ? "${(progress * 100).toInt()}%"
                                      : "Download",
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w600,
                                  color: isDownloading
                                      ? AppColors.red2
                                      : AppColors.background,
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
