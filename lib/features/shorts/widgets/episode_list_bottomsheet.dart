import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/features/setting/data/model/subscription_model.dart';
import 'package:testemu/features/setting/presentation/widgets/sub_card.dart';
import 'package:testemu/features/shorts/controller/episode_shorts_controller.dart';
import 'package:testemu/features/shorts/widgets/episod_select_button.dart';

/// Bottom sheet for displaying episode list in EpisodeShortsScreen
class EpisodeListBottomSheet extends StatelessWidget {
  const EpisodeListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EpisodeShortsController>();

    return Obx(() {
      // Get current episode data
      if (controller.episodeVideos.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            gradient: const LinearGradient(
              colors: [AppColors.red2, AppColors.red],
              stops: [0.8, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: CommonText(
              text: "No episodes available",
              color: AppColors.white,
            ),
          ),
        );
      }

      final currentIndex = controller.currentIndex.value;
      final currentEpisode = controller.episodeVideos[currentIndex];
      final totalEpisodes = controller.episodeVideos.length;

      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            gradient: const LinearGradient(
              colors: [AppColors.red2, AppColors.red],
              stops: [0.8, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///// Current Episode Image And Description
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: .1),
                    ),
                    child: CommonImage(
                      fill: BoxFit.cover,
                      width: 84,
                      height: 120,
                      borderRadius: 8,
                      imageSrc: currentEpisode.thumbnailUrl,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CommonText(
                          text: currentEpisode.title,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 4.h),
                        CommonText(
                          text:
                              "Episode ${currentEpisode.episodeNumber} of $totalEpisodes",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white.withValues(alpha: .8),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 6.h),
                        CommonText(
                          text: currentEpisode.description,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white.withValues(alpha: .6),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              //// Episode Selection Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: "Select Episode",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: CommonText(
                      text: "$totalEpisodes Episodes",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              /// GridView.builder for episodes
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.episodeVideos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  final episode = controller.episodeVideos[index];
                  final episodeNumber = episode.episodeNumber;
                  final isCurrentEpisode = index == currentIndex;
                  final hasAccess = episode.isAccess;
                  final isSubscribed = episode.isSubscribed;

                  return EpisodSelectBtn(
                    onPressed: () {
                      if (!hasAccess && !isSubscribed) {
                        // Show subscription bottom sheet
                        Get.back();
                        showModalBottomSheet(
                          scrollControlDisabledMaxHeightRatio: 0.75,
                          context: context,
                          isScrollControlled: false,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const SubscriptionBottomSheet(),
                        );
                      } else {
                        // Navigate to this episode
                        Get.back();

                        // Jump to that page
                        controller.pageController.jumpToPage(index);
                      }
                    },
                    isRunning: isCurrentEpisode,
                    isAvilable: hasAccess || isSubscribed,
                    isLock: !hasAccess && !isSubscribed,
                    text: episodeNumber.toString(),
                  );
                },
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      );
    });
  }
}

class SubscriptionBottomSheet extends StatelessWidget {
  const SubscriptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200, // container height
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF981C2C).withValues(alpha: .5), // top shadow
                Color(0xFF981C2C).withValues(alpha: .3),
                Colors.black.withValues(alpha: .6), // bottom shadow
              ],
              stops: [
                0.0,
                0.7, // 70% red
                1.0, // 30% black
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText(
                text: "Subscribe",
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              CommonText(
                text: "Watch more episodes",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 16.h),

              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: SubCard(
                      subscription: SubscriptionData(
                        name: "Test",
                        description: "Test",
                        price: 100,
                        duration: "Test",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      textAlign: TextAlign.center,
                      text: "Automatic Episode Unlock",
                      style: GoogleFonts.poppins(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 4), // optional spacing
                    CommonText(
                      textAlign: TextAlign.center,
                      text:
                          "By subscribing you agree to our Recharge Agreement",
                      style: GoogleFonts.poppins(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
