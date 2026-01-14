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
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/download/controller/downloaded_shorts_controller.dart';

class DownloadSesoneListScreen extends StatelessWidget {
  const DownloadSesoneListScreen({super.key});

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
            isShowBackButton: false,
          ),

          body: Obx(() {
            // Loading state
            if (controller.isLoading.value &&
                controller.downloadedVideos.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // Empty state
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
                      text: "Download videos from Shorts to watch offline",
                      fontSize: 12.sp,
                      color: AppColors.white.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              );
            }

            // Video list
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

                Expanded(
                  child: ListView.builder(
                    addRepaintBoundaries: true,
                    addAutomaticKeepAlives: false,
                    itemCount: controller.downloadedVideos.length,
                    itemBuilder: (context, index) {
                      final video = controller.getVideoAt(index);
                      return Obx(() {
                        return MovieCardD(
                          imagePath: video.thumbnailUrl,
                          title: video.title,
                          description: video.description,
                          size: video.formattedFileSize,
                          episodeInfo: video.episodeInfo,
                          isMarkShowAll: controller.isSelectionMode.value,
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

                          // Vertical Divider
                          Container(
                            width: 1,
                            height: 24,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),

                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (controller.selectedVideoIds.isNotEmpty) {
                                  deteleDialog(context, controller);
                                }
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

  Future<dynamic> deteleDialog(
    BuildContext context,
    DownloadedShortsController controller,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        contentPadding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                34.height, // space for close button

                Text(
                  "Delete ${controller.selectedVideoIds.length} video(s)?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "This will permanently delete the videos from your device",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withValues(alpha: 0.6),
                    fontSize: 12.sp,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(36.r),
                          ),
                          alignment: Alignment.center,
                          child: CommonText(
                            top: 8.h,
                            bottom: 8.h,
                            text: "Cancel",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          controller.deleteSelectedVideos();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(36.r),
                          ),
                          alignment: Alignment.center,
                          child: CommonText(
                            top: 8.h,
                            bottom: 8.h,
                            text: "Delete",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCardD extends StatefulWidget {
  final String? imagePath;
  final String? title;
  final String? description;
  final String? size;
  final String? episodeInfo;
  final VoidCallback? onTap;
  final bool isMarkShowAll;
  final bool isSelected;

  const MovieCardD({
    super.key,
    this.imagePath,
    this.title,
    this.description,
    this.size,
    this.episodeInfo,
    this.onTap,
    this.isMarkShowAll = false,
    this.isSelected = false,
  });

  @override
  State<MovieCardD> createState() => _MovieCardDState();
}

class _MovieCardDState extends State<MovieCardD> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          spacing: 8,
          children: [
            if (widget.isMarkShowAll)
              InkWell(
                onTap: widget.onTap,
                child: widget.isSelected
                    ? Container(
                        width: 18.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Icon(
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
            Stack(
              children: [
                CommonImage(
                  borderRadius: 8.r,
                  width: 82.w,
                  height: 103.h,
                  imageSrc: widget.imagePath?.isNotEmpty == true
                      ? widget.imagePath!
                      : AppImages.m1,
                ),
                // Offline indicator badge
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
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: widget.title ?? "Reborn True Princess Returns",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    CommonText(
                      text:
                          widget.description ??
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore ...",
                      maxLines: 3,
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
                        if (widget.episodeInfo?.isNotEmpty == true) ...[
                          CommonText(
                            text: widget.episodeInfo!,
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
                          text: widget.size ?? "0 MB",
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

// Note: This screen now shows REAL offline downloaded videos
// The dummy data below is kept for reference but not used anymore
