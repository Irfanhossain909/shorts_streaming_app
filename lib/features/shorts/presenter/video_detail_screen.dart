import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/card/movie_card.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/home/presentation/controller/home_controller.dart';
import 'package:testemu/features/shorts/model/bottom_card_btn_model.dart';
import 'package:testemu/features/shorts/widgets/episod_select_button.dart';
import 'package:testemu/features/shorts/widgets/tag_card.dart';

class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      body: Container(
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
            image: AssetImage(AppImages.m1),

            // image: NetworkImage(
            //   "https://cdn.pixabay.com/photo/2023/08/06/06/08/ai-generated-8172236_640.png",
            // ),
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
                      child: const CommonImage(
                        fill: BoxFit.cover,
                        width: 84,
                        height: 120,
                        borderRadius: 8,
                        imageSrc:
                            // "https://cdn.pixabay.com/photo/2023/08/06/06/08/ai-generated-8172236_640.png",
                            AppImages.m1,
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
                            text: "Eternal Fog",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        CommonText(
                          text: "Update to EP.67/EP.67",
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
                            const TagCard(tag: "Tit for tat"),
                            const TagCard(tag: "Werewolf"),
                            const TagCard(tag: "Fantasy"),
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
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
                        text: "Episode 165 >",
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
                    itemCount: episodSelectBtnList.length,
                    itemBuilder: (context, index) {
                      final episodSelectBtn = episodSelectBtnList[index];
                      return Container(
                        width: 70.w, // Fixed width for each button
                        margin: EdgeInsets.only(
                          right: 8.w,
                        ), // Spacing between buttons
                        child: EpisodSelectBtn(
                          isRunning: episodSelectBtn.isRunning,
                          isAvilable: episodSelectBtn.isAvailable,
                          isLock: episodSelectBtn.isLock,
                          text: episodSelectBtn.text,
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  height: 280
                      .h, // Increased height to accommodate full MovieCard content
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeController.comingSoonMovies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        title: homeController.comingSoonMovies[index]['title'],
                        imageUrl:
                            homeController.comingSoonMovies[index]['imageUrl'],
                        badge: homeController.comingSoonMovies[index]['badge'],
                        date: homeController
                            .comingSoonMovies[index]['releaseDate'],
                        onTap: () => homeController.onMovieTap(
                          homeController.comingSoonMovies[index]['title'],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
