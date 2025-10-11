import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     // if (LocalStorage.isLogIn) {
  //     //   if (LocalStorage.myRole == 'consultant') {
  //     //     Get.offAllNamed(AppRoutes.doctorHome);
  //     //   } else {
  //     //     Get.offAllNamed(AppRoutes.patientsHome);
  //     //   }
  //     // } else {
  //     Get.offAllNamed(AppRoutes.onboarding);
  //   });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(
          // 'assets/animations/confetti.json',
          'assets/animations/creepyshorts_splash_screen.json',
          frameRate: FrameRate(120),
          width: 200,
          height: 200,

          // width: MediaQuery.of(context).size.width, // বা নির্দিষ্ট width
          // height: MediaQuery.of(context).size.height, // বা নির্দিষ্ট height
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
