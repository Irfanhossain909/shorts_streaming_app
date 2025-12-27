import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/shorts/controller/video_details_controller.dart';
import 'package:testemu/features/shorts/widgets/episod_select_button.dart';
import 'package:testemu/features/shorts/widgets/tag_card.dart';

class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({super.key});

  /// Returns appropriate ImageProvider for background decoration
  /// Uses CachedNetworkImageProvider for network URLs, AssetImage for assets
  ImageProvider _getBackgroundImageProvider(String? thumbnail) {
    final imageUrl = OtherHelper.getImageUrl(
      thumbnail,
      defaultAsset: AppImages.m1,
    );

    // If it's an asset path, use AssetImage
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }

    // Otherwise, it's a network URL, use CachedNetworkImageProvider
    return CachedNetworkImageProvider(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final VideoDetailsController videoDetailsController =
        Get.find<VideoDetailsController>();
    return Scaffold(
      body: Obx(() {
        final data = videoDetailsController.data.value;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          height: Get.height,
          width: Get.width,

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.redGradient1, // প্রথম রং
                AppColors.redGradient2, // দ্বিতীয় রং
              ],
              stops: [0.8, 1.0], // 80% পর্যন্ত প্রথম রং, তারপর দ্বিতীয় রং
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            image: DecorationImage(
              image: _getBackgroundImageProvider(data.movie.thumbnail),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.black.withValues(alpha: 0.4),
                BlendMode.dstIn,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 80.h, left: 16.w, right: 16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red2, // Background color
                      ),
                      padding: EdgeInsets.all(8), // Size control
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  40.height,
                  ///// Image And description
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: .1),
                        ),
                        child: CommonImage(
                          fill: BoxFit.cover,
                          width: 84.w,
                          height: 120.h,
                          borderRadius: 8.r,
                          imageSrc: OtherHelper.getImageUrl(
                            data.movie.thumbnail,
                            defaultAsset: AppImages.m1,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //print("Reborn True Princess Returns");
                              Get.toNamed(AppRoutes.videoDetail);
                            },
                            child: CommonText(
                              text: data.movie.title,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                          CommonText(
                            text:
                                "Update to EP.${data.totalSeasons}/EP.${data.totalSeasons}",
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white.withValues(alpha: .6),
                            bottom: 10.h,
                          ),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 6.w,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CommonText(
                                text: "Tags",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                              for (var tag in data.movie.tags)
                                TagCard(tag: tag),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  //// Episode Row
                  CommonText(
                    text: "Introduction",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 4.h),
                  CommonText(
                    text: data.movie.description,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.white,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        text: "Episode",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: CommonText(
                          text: "Episode 1 >",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  /// Horizontal ListView for episodes
                  SizedBox(
                    height: 40.h, // Fixed height for the horizontal scroll
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          videoDetailsController
                              .seasonVideoData
                              .value
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final season = videoDetailsController
                            .seasonVideoData
                            .value?[index];
                        return Container(
                          width: 70.w, // Fixed width for each button
                          margin: EdgeInsets.only(
                            right: 8.w,
                          ), // Spacing between buttons
                          child: EpisodSelectBtn(
                            isRunning: index == 0,
                            isAvilable: index > 0 && index <= 4,
                            isLock: index > 4,
                            text: season?.episodeNumber.toString(),
                            onPressed: () {
                              videoDetailsController.onSeasonTap(
                                season?.videoUrl ?? '',
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CommonText(
                    text: "You could like",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 10.h),
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 10.h),
                  //   height: 280
                  //       .h, // Increased height to accommodate full MovieCard content
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: data.seasons.length,
                  //     itemBuilder: (context, index) {
                  //       return MovieCard(
                  //         title:
                  //             data.seasons[index].title,
                  //         imageUrl: data.seasons[index].imageUrl,
                  //             data.seasons[index].imageUrl,
                  //         badge:
                  //             data.seasons[index].badge,
                  //         date: data.seasons[index].releaseDate,
                  //         onTap: () => videoDetailsController.onSeasonTap(
                  //           data.seasons[index].id,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
