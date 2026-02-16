import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:get/get.dart';
import 'package:testemu/core/services/storage/storage_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (LocalStorage.token.isNotEmpty && LocalStorage.isLogIn) {
        Get.offAllNamed(AppRoutes.navigation);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // বা transparent রাখতে পারো
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Lottie.asset(
            "assets/animations/chepy_shorts_ss.json",
            repeat: false,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
