import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/setting/presentation/widgets/sub_card.dart';
import 'package:testemu/features/shorts/model/bottom_card_btn_model.dart';
import 'package:testemu/features/shorts/widgets/episod_list_selection_button.dart';
import 'package:testemu/features/shorts/widgets/episod_select_button.dart';
import 'package:testemu/features/shorts/widgets/tag_card.dart';

class ListBottomSheet extends StatelessWidget {
  const ListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // ✅ পুরো BottomSheet scrollable হবে
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          gradient: const LinearGradient(
            colors: [
              AppColors.red2, // প্রথম রং
              AppColors.red, // দ্বিতীয় রং
            ],
            stops: [0.8, 1.0], // 80% পর্যন্ত প্রথম রং, তারপর দ্বিতীয় রং
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
                  child: const CommonImage(
                    fill: BoxFit.cover,
                    width: 84,
                    height: 120,
                    borderRadius: 8,
                    imageSrc: AppImages.m1,
                    // "https://cdn.pixabay.com/photo/2023/08/06/06/08/ai-generated-8172236_640.png",
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
                        text: "Eternal Fog >",
                        fontSize: 18.sp,
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
            SizedBox(height: 16.h),

            //// Episode Row
            Row(
              children: const [
                EpisodeListSelectButton(tag: "1-25", isSelected: true),
                SizedBox(width: 8),
                EpisodeListSelectButton(tag: "26-50"),
                SizedBox(width: 8),
                EpisodeListSelectButton(tag: "51-67"),
              ],
            ),
            SizedBox(height: 16.h),

            /// GridView.builder
            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // ✅ ভিতরে scroll করবে না
              itemCount: episodSelectBtnList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                final episodSelectBtn = episodSelectBtnList[index];
                return EpisodSelectBtn(
                  onPressed: () {
                    Get.back();
                    showModalBottomSheet(
                      scrollControlDisabledMaxHeightRatio: 0.75,
                      context: context,
                      isScrollControlled: false,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const SubscriptionBottomSheet(),
                    );
                  },
                  isRunning: episodSelectBtn.isRunning,
                  isAvilable: episodSelectBtn.isAvailable,
                  isLock: episodSelectBtn.isLock,
                  text: episodSelectBtn.text,
                );
              },
            ),
          ],
        ),
      ),
    );
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
                    child: SubCard(),
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
