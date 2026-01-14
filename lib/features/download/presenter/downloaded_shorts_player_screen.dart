import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/download/controller/downloaded_shorts_player_controller.dart';
import 'package:testemu/features/shorts/widgets/reel_button.dart';
import 'package:video_player/video_player.dart';

class DownloadedShortsPlayerScreen extends StatelessWidget {
  const DownloadedShortsPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadedShortsPlayerController>(
      init: DownloadedShortsPlayerController(),
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: CommonText(
              text: "Offline Videos",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          body: PageView.builder(
            controller: controller.pageController,
            scrollDirection: Axis.vertical,
            itemCount: controller.videos.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              return DownloadedVideoPlayer(index: index);
            },
          ),
        );
      },
    );
  }
}

class DownloadedVideoPlayer extends StatelessWidget {
  final int index;
  const DownloadedVideoPlayer({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadedShortsPlayerController>(
      builder: (controller) {
        final videoController = controller.getVideoController(index);
        final isLoading = controller.isLoadingVideo(index);
        final hasError = controller.hasVideoError(index);
        final isPlaying = controller.isVideoPlaying(index);
        final video = controller.videos[index];

        return GestureDetector(
          onTap: () => controller.togglePlayPause(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Background video
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16.h),
                          const Text(
                            "Error loading video",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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

              /// Gradient Shadow from bottom
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
                      // Offline indicator
                      Row(
                        children: [
                          Icon(
                            Icons.offline_pin,
                            size: 16,
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                          SizedBox(width: 4.w),
                          CommonText(
                            text: "Offline",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Title
                      CommonText(
                        text: video.title,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        color: AppColors.white,
                      ),

                      // Description
                      SizedBox(
                        width: 300.w,
                        child: CommonText(
                          fontSize: 12.sp,
                          color: AppColors.white.withValues(alpha: 0.7),
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text: video.description,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Episode info and file size
                      Row(
                        children: [
                          if (video.episodeInfo.isNotEmpty) ...[
                            CommonImage(imageSrc: AppImages.listIc, width: 16),
                            const SizedBox(width: 8),
                            CommonText(
                              text: video.episodeInfo,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                            SizedBox(width: 12.w),
                          ],
                          CommonText(
                            text: video.formattedFileSize,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white.withValues(alpha: 0.6),
                          ),
                        ],
                      ),

                      // Progress bar
                      SizedBox(height: 8.h),
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
                    // Thumbnail
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: CommonImage(
                          fill: BoxFit.cover,
                          imageSrc: video.thumbnailUrl.isNotEmpty
                              ? video.thumbnailUrl
                              : AppImages.m1,
                          width: 56,
                          height: 56,
                        ),
                      ),
                    ),

                    // Delete button
                    ReelButton(
                      imgPath: AppImages.download,
                      text: "Delete",
                      onTap: () => controller.showDeleteConfirmation(video.videoId),
                    ),

                    // Share button
                    ReelButton(
                      imgPath: AppImages.shareIc,
                      text: "Share",
                      onTap: () {},
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

