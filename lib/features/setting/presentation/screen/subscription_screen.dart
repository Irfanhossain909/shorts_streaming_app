import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/setting/presentation/widgets/sub_card.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: ""),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 20.w,
              children: [
                Column(
                  children: [
                    CommonText(
                      text: "Subscribe",
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                    ),
                    CommonText(
                      text: "Watch more episodes",
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.background,
                    ),
                  ],
                ),
                CommonImage(width: 250.w, imageSrc: AppImages.vipCardImg),
              ],
            ),

            SizedBox(height: 16.h),
            CarouselSlider(
              options: CarouselOptions(
                height: 220.h,
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.85,
                enableInfiniteScroll: true,
                aspectRatio: 16 / 9,
                initialPage: 0,
              ),
              items: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SubCard(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SubCard(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SubCard(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CommonText(
              text: "4 Privileges",
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.background,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 12.w,

              children: [
                SubRowCard(title: "All Free", imgPath: AppImages.free),

                SubRowCard(title: "Support 1080p", imgPath: AppImages.short),
                SubRowCard(title: "Ad Free", imgPath: AppImages.addFree),
                SubRowCard(
                  imgWidth: 62.w,
                  height: 12,
                  title: "Offline Downloads",
                  imgPath: AppImages.offLineDownload,
                ),
              ],
            ),
            18.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: "Subscription Instructions",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.background,
                ),
                12.height,
                CommonText(
                  textAlign: TextAlign.left,
                  text: "Subscription Instructions",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.background,
                ),
                8.height,
                CommonText(
                  text:
                      "(1) The subscription function is only for improving the user experience of the APP. Whether or not you subscribe does not affect the normal use of the APP.",
                  fontSize: 10.sp,
                  maxLines: 3,
                  fontWeight: FontWeight.w400,
                  color: AppColors.background,
                ),
                12.height,
                CommonText(
                  text: "2. Benefits",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.background,
                ),
                8.height,
                CommonText(
                  textAlign: TextAlign.justify,
                  text:
                      "(1) After purchasing the Weekly PRO/Monthly PRO/Yearly PRO card, you will be able to watch any episode without restrictions.",
                  fontSize: 10.sp,
                  maxLines: 3,
                  fontWeight: FontWeight.w400,
                  color: AppColors.background,
                ),

                CommonText(
                  text:
                      "(2) Ad-free: After unlocking, other types of ads will no longer be",
                  maxLines: 3,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.background,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CommonText(
                    text: "Privacy Policy | User Agreement | Restore",
                    maxLines: 3,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.background,
                    top: 12.h,
                    bottom: 12.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SubRowCard extends StatelessWidget {
  final String? title;
  final String? imgPath;
  final double? imgWidth;
  final double? height;

  const SubRowCard({
    super.key,
    this.title,
    this.imgPath,
    this.imgWidth,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonImage(
          width: imgWidth ?? 76.w,
          imageSrc: imgPath ?? AppImages.free,
        ),
        SizedBox(height: height ?? 4.h),
        CommonText(
          text: title ?? "no text",
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.background,
        ),
      ],
    );
  }
}
