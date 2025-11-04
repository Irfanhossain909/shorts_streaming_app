import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/download/controller/download_episod_controller.dart';

class DownloadEpisodListScreen extends StatelessWidget {
  const DownloadEpisodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadEpisodController>(
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: IconButton(
                  onPressed: () {
                    controller.valueManupolate();
                  },
                  icon: SvgPicture.asset(width: 18.w, AppImages.markIcon),
                ),
              ),
            ],
            isBackButton: false,
            isShowBackButton: false,
            isCenterTitle: false,
            title: "Downloaded",
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .65,
                  ),
                  padding: EdgeInsets.all(12),
                  physics: BouncingScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return EpisodCard(isMarkShowAll: controller.value.value);
                    });
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: Obx(() {
            return controller.value.value
                ? SafeArea(
                    child: Container(
                      color: Colors.black, // eta tumar bg color hishebe daw
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonText(
                              text: "Select All",
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Vertical Divider
                          Container(
                            width: 1,
                            height: 24, // divider height adjust koro
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),

                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // Get.toNamed(AppRoutes.downloadSesone);
                              },
                              child: CommonText(
                                text: "Delete",
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
                : SizedBox();
          }),
        );
      },
    );
  }
}

class EpisodCard extends StatefulWidget {
  final bool isMarkShowAll;
  const EpisodCard({super.key, this.isMarkShowAll = false});

  @override
  State<EpisodCard> createState() => _EpisodCardState();
}

class _EpisodCardState extends State<EpisodCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        Stack(
          children: [
            CommonImage(
              borderRadius: 8.r,
              width: 82.w,
              height: 103.h,
              imageSrc: AppImages.m1,
            ),

            /// Select Button
            if (widget.isMarkShowAll)
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  child: isSelected
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
              ),
          ],
        ),

        CommonText(
          left: 4,
          text: "Ep.1",
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
