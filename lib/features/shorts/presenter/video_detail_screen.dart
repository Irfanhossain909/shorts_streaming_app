import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/shimmer/video_detail_shimmer.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
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
        final seasonVideoData = videoDetailsController.seasonVideoData.value;

        // Show beautiful shimmer while loading
        if (data == null) {
          return const VideoDetailShimmer();
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
            padding: EdgeInsets.only(
              top: 80.h,
              left: 16.w,
              right: 16.w,
              bottom: 20.h,
            ),
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
                      Flexible(
                        child: Column(
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
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CommonText(
                              text: "Episode",
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                            SizedBox(width: 10.w),
                            Flexible(
                              child: Obx(() {
                                final seasons =
                                    videoDetailsController
                                        .data
                                        .value
                                        ?.seasons ??
                                    [];
                                final selectedId = videoDetailsController
                                    .selectedSeasonId
                                    .value;

                                if (seasons.isEmpty) {
                                  return SizedBox.shrink();
                                }

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.h,
                                    horizontal: 4.w,
                                  ),
                                  height: 32.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.red,
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedId ?? seasons.first.id,
                                    isExpanded: true,
                                    selectedItemBuilder: (BuildContext context) {
                                      return seasons.map((season) {
                                        final displayText =
                                            season.seasonTitle?.isNotEmpty ==
                                                true
                                            ? season.seasonTitle!
                                            : (season.seasonNumber != null
                                                  ? "Series ${season.seasonNumber}"
                                                  : "Series");
                                        return Center(
                                          child: CommonText(
                                            text: displayText,
                                            color: AppColors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList();
                                    },
                                    items: seasons.map((season) {
                                      final displayText =
                                          season.seasonTitle?.isNotEmpty == true
                                          ? season.seasonTitle!
                                          : (season.seasonNumber != null
                                                ? "Series ${season.seasonNumber}"
                                                : "Series");
                                      return DropdownMenuItem<String>(
                                        value: season.id,
                                        child: CommonText(
                                          text: displayText,
                                          color: AppColors.white,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        videoDetailsController.onSeasonChanged(
                                          value,
                                        );
                                      }
                                    },
                                    icon: const SizedBox.shrink(),
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    iconSize: 0,
                                    dropdownColor: AppColors.red,
                                    underline: Container(),
                                    borderRadius: BorderRadius.circular(10.r),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {},
                        child: CommonText(
                          text: "Episode ${seasonVideoData?.length}",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  /// Horizontal ListView for episodes
                  Obx(() {
                    // Show shimmer while loading season videos
                    if (videoDetailsController.seasonVideoIsLoading.value) {
                      return const EpisodeButtonsShimmer();
                    }

                    final episodes =
                        videoDetailsController.seasonVideoData.value ?? [];

                    // Show empty state if no episodes
                    if (episodes.isEmpty) {
                      return SizedBox(
                        height: 40.h,
                        child: Center(
                          child: CommonText(
                            text: "No episodes available",
                            fontSize: 12.sp,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      );
                    }

                    final bool subscribed = LocalStorage.isSubscribed;
                    const int freeEpisodeLimit = 3;

                    return SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          final episode = episodes[index];
                          final bool isLocked =
                              !subscribed && index >= freeEpisodeLimit;

                          return Container(
                            width: 70.w,
                            margin: EdgeInsets.only(right: 8.w),
                            child: EpisodSelectBtn(
                              isRunning: index == 0,
                              isAvilable: !isLocked && index > 0,
                              isLock: isLocked,
                              text: episode.episodeNumber.toString(),
                              onPressed: isLocked
                                  ? null
                                  : () {
                                      videoDetailsController.onSeasonTap(
                                        episode.downloadUrl,
                                        episode.id,
                                        index,
                                      );
                                    },
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 20.h),
                  CommonText(
                    text: "You could like",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 10.h),
                  Obx(() {
                    final recentVideos =
                        videoDetailsController.recentVideos.value ?? [];

                    // Show shimmer if loading, else show empty state
                    if (recentVideos.isEmpty) {
                      return videoDetailsController.isLoading.value
                          ? const RecommendedVideosShimmer()
                          : Container(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: CommonText(
                                  text: "No recommendations available",
                                  fontSize: 14.sp,
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            );
                    }

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      height: 280
                          .h, // Increased height to accommodate full MovieCard content
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: recentVideos.length,
                        itemBuilder: (context, index) {
                          final recentItem = recentVideos[index];
                          final video = recentItem
                              .videoId!; // Safe because we filter nulls in controller
                          return MovieCard(
                            title: video.title,
                            imageUrl: video.thumbnailUrl,
                            badge: "Episode ${video.episodeNumber}",
                            date: recentItem.viewedAt
                                .toLocal()
                                .toString()
                                .split(' ')[0],
                            onTap: () {
                              debugPrint("video.movieId: ${video.movieId}");
                              videoDetailsController.getVideoDetails(
                                video.movieId,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
