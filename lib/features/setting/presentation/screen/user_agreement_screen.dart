import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "User Agreement"),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          spacing: 36.h,
          children: [
            70.height,
            CommonText(
              text: "User Agreement",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.activeTrackColor,
              ),
            ),
            CommonText(
              maxLines: 4,
              text:
                  " Hey the, creepy fan! Quick heads up: if you delete your account, you’ll miss out on some awesome shows and will not be able to get your data back (including downloaded episodes or subscriptions). Are you sure you want to do this? It you have any concerns you can chat with our support group. We would hate to see you go! ",
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.activeTrackColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
