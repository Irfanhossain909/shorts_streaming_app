import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/shorts/model/bottom_card_btn_model.dart';
import 'package:testemu/features/shorts/widgets/episod_select_button.dart';

class DownloadMenuScreen extends StatelessWidget {
  const DownloadMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Reborn True Princess Returns",
        titleFontSize: 18.sp,
      ),
      bottomNavigationBar: SafeArea(
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
                    Get.toNamed(AppRoutes.downloadSeason);
                  },
                  child: CommonText(
                    text: "View Download",
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CommonText(
            left: 34.w,
            right: 34.w,
            maxLines: 2,
            style: GoogleFonts.poppins(
              color: AppColors.background.withValues(alpha: 0.8),
              fontSize: 9.sp,
            ),
            text:
                "Offline download is exclusive for paid memberships, paid shorts can only be watched within the membership period",
          ),

          24.height,

          /// GridView.builder
          GridView.builder(
            padding: EdgeInsets.all(16.w),
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
                isRunning: episodSelectBtn.isRunning,
                isAvilable: episodSelectBtn.isAvailable,
                isLock: episodSelectBtn.isLock,
                text: episodSelectBtn.text,
              );
            },
          ),
        ],
      ),
    );
  }
}
