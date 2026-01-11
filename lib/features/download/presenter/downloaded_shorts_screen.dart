import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/download/controller/downloaded_shorts_controller.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';

class DownloadedShortsScreen extends StatelessWidget {
  const DownloadedShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadedShortsController>(
      init: DownloadedShortsController(),
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: IconButton(
                  onPressed: () {
                    controller.toggleSelectionMode();
                  },
                  icon: SvgPicture.asset(width: 18.w, AppImages.markIcon),
                ),
              ),
            ],
            isCenterTitle: false,
            title: "Downloaded Shorts",
            isShowBackButton: true,
          ),
          body: Obx(() {
            if (controller.isLoading.value &&
                controller.downloadedVideos.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.downloadedVideos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 80,
                      color: AppColors.white.withValues(alpha: 0.3),
                    ),
                    SizedBox(height: 16.h),
                    CommonText(
                      text: "No Downloaded Videos",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 8.h),
                    CommonText(
                      text: "Download videos to watch offline",
                      fontSize: 12.sp,
                      color: AppColors.white.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Storage info
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.storage_outlined,
                        size: 16,
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                      SizedBox(width: 8.w),
                      CommonText(
                        text: "Total: ${controller.totalStorageUsed.value}",
                        fontSize: 12.sp,
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                      const Spacer(),
                      CommonText(
                        text: "${controller.downloadedVideos.length} Videos",
                        fontSize: 12.sp,
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),

                // Video list
                Expanded(
                  child: ListView.builder(
                    addRepaintBoundaries: true,
                    addAutomaticKeepAlives: false,
                    itemCount: controller.downloadedVideos.length,
                    itemBuilder: (context, index) {
                      final video = controller.getVideoAt(index);
                      return Obx(() {
                        return DownloadedVideoCard(
                          video: video,
                          isSelectionMode: controller.isSelectionMode.value,
                          isSelected: controller.isVideoSelected(video.videoId),
                          onTap: () {
                            controller.playDownloadedVideo(index);
                          },
                        );
                      });
                    },
                  ),
                ),
              ],
            );
          }),
          bottomNavigationBar: Obx(() {
            return controller.isSelectionMode.value
                ? SafeArea(
                    child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.selectAllVideos();
                              },
                              child: CommonText(
                                text:
                                    controller.selectedVideoIds.length ==
                                        controller.downloadedVideos.length
                                    ? "Deselect All"
                                    : "Select All",
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.showDeleteConfirmationDialog();
                              },
                              child: CommonText(
                                text:
                                    "Delete (${controller.selectedVideoIds.length})",
                                style: GoogleFonts.poppins(
                                  color: AppColors.red,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox();
          }),
        );
      },
    );
  }
}

class DownloadedVideoCard extends StatelessWidget {
  final DownloadedVideoModel video;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;

  const DownloadedVideoCard({
    super.key,
    required this.video,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          spacing: 8,
          children: [
            // Selection indicator
            if (isSelectionMode)
              InkWell(
                onTap: onTap,
                child: isSelected
                    ? Container(
                        width: 18.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: const Icon(
                          Icons.done,
                          size: 12,
                          color: AppColors.black,
                        ),
                      )
                    : Container(
                        width: 18.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(color: AppColors.white),
                        ),
                      ),
              ),

            // Thumbnail
            Stack(
              children: [
                CommonImage(
                  borderRadius: 8.r,
                  width: 82.w,
                  height: 103.h,
                  imageSrc: video.thumbnailUrl.isNotEmpty
                      ? video.thumbnailUrl
                      : AppImages.m1,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.offline_pin,
                      size: 12,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Video info
            Expanded(
              child: SizedBox(
                height: 103.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    CommonText(
                      text: video.title,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Description
                    CommonText(
                      text: video.description,
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: AppColors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const Spacer(),

                    // Episode info and file size
                    Row(
                      children: [
                        if (video.episodeInfo.isNotEmpty) ...[
                          CommonText(
                            text: video.episodeInfo,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: AppColors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        CommonText(
                          text: video.formattedFileSize,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: AppColors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
