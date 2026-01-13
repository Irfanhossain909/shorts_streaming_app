import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/config/route/app_routes.dart';
import 'core/config/theme/light_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(428, 926),
      // Rebuild only once after initialization
      rebuildFactor: (old, data) => false,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        navigatorKey: Get.key,
        //showPerformanceOverlay:true, // ✅ Performance testing এর জন্য enable করা হয়েছে
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        defaultTransition: Transition.fadeIn,
        theme: themeData,
        transitionDuration: const Duration(
          milliseconds: 200,
        ), // Reduced from 300ms
        initialRoute: AppRoutes.splash,
        // initialRoute: AppRoutes.editProfile,
        getPages: AppRoutes.routes,
        // Performance optimizations
        smartManagement: SmartManagement.keepFactory,
      ),
    );
  }
}
