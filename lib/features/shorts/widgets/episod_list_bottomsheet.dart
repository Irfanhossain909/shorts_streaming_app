import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/features/setting/data/model/subscription_model.dart';
import 'package:testemu/features/setting/presentation/widgets/sub_card.dart';
import 'package:testemu/features/shorts/controller/shorts_controller.dart';
import 'package:testemu/features/shorts/widgets/episod_select_button.dart';
import 'package:testemu/features/shorts/widgets/tag_card.dart';

class ListBottomSheet extends StatelessWidget {
  const ListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShortsScontroller>();

    return Obx(() {
      // Get current video data
      if (controller.shortsVideosList.isEmpty) {
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
              text: "No video data available",
              color: AppColors.white,
            ),
          ),
        );
      }

      final currentVideo =
          controller.shortsVideosList[controller.currentIndex.value];

      // Get all episodes from the same movie/season
      final relatedEpisodes = controller.shortsVideosList.where((video) {
        // Same movie and season
        return video.movieId?.id == currentVideo.movieId?.id &&
            video.seasonId?.id == currentVideo.seasonId?.id;
      }).toList();

      // Sort by episode number
      relatedEpisodes.sort(
        (a, b) => a.episodeNumber.compareTo(b.episodeNumber),
      );

      // Get total episodes count
      final totalEpisodes = relatedEpisodes.length;
      final currentEpisode = currentVideo.episodeNumber;

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
            children: [
              ///// Image And description
              Row(
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
                      imageSrc: currentVideo.thumbnailUrl,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.videoDetail);
                          },
                          child: CommonText(
                            text:
                                currentVideo.movieId?.title ??
                                currentVideo.title,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        CommonText(
                          text:
                              "Update to EP.$currentEpisode${totalEpisodes > 0 ? '/EP.$totalEpisodes' : ''}",
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white.withValues(alpha: .6),
                          bottom: 10.h,
                          textAlign: TextAlign.start,
                        ),
                        if (currentVideo.seasonId != null)
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 6.w,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CommonText(
                                text: "Season",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                                textAlign: TextAlign.start,
                              ),
                              TagCard(tag: currentVideo.seasonId!.title),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              //// Episode selection info
              CommonText(
                text: "Select Episode ($totalEpisodes Episodes)",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                bottom: 8.h,
                textAlign: TextAlign.start,
              ),

              /// GridView.builder for episodes
              if (relatedEpisodes.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: relatedEpisodes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (context, index) {
                    final episode = relatedEpisodes[index];
                    final episodeNumber = episode.episodeNumber;
                    final isCurrentEpisode = episode.id == currentVideo.id;
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
                            builder: (context) =>
                                const SubscriptionBottomSheet(),
                          );
                        } else {
                          // Navigate to this episode
                          Get.back();

                          // Find the index of this episode in the main list
                          final episodeIndex = controller.shortsVideosList
                              .indexWhere((v) => v.id == episode.id);

                          if (episodeIndex != -1) {
                            // Jump to that page
                            controller.pageController.jumpToPage(episodeIndex);
                          }
                        }
                      },
                      isRunning: isCurrentEpisode,
                      isAvilable: hasAccess || isSubscribed,
                      isLock: !hasAccess && !isSubscribed,
                      text: episodeNumber.toString(),
                    );
                  },
                )
              else
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: const CommonText(
                      text: "No episodes available",
                      color: AppColors.white,
                    ),
                  ),
                ),
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
