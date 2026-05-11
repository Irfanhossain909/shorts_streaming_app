import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/route/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_string.dart';
import '../../services/storage/storage_services.dart';
import '../button/common_button.dart';
import '../text/common_text.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  late final Future<void> _prefFuture = LocalStorage.getAllPrefData();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Allow back navigation
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          title: const Text(AppString.noInternet),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated WiFi Icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_off_rounded,
                          size: 100,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Title
              const CommonText(
                text: AppString.noInternet,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              const SizedBox(height: 16),
              // Description
              const CommonText(
                text: AppString.checkInternet,
                fontSize: 14,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CommonText(
                text:
                    "When you're online again, this screen will close automatically.",
                fontSize: 13,
                color: AppColors.white.withOpacity(0.55),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              FutureBuilder<void>(
                future: _prefFuture,
                builder: (context, snapshot) {
                  final prefsReady =
                      snapshot.connectionState == ConnectionState.done;
                  final showDownloads =
                      prefsReady && LocalStorage.isSubscribed;

                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CommonButton(
                          onTap: () => Get.back(),
                          titleText: "Try Again",
                          buttonHeight: 48,
                          buttonColor: AppColors.primaryColor,
                        ),
                        if (showDownloads) ...[
                          const SizedBox(height: 12),
                          CommonButton(
                            onTap: () =>
                                Get.toNamed(AppRoutes.downloadedShorts),
                            titleText: "Downloaded Shorts",
                            buttonHeight: 48,
                            buttonColor:
                                AppColors.primaryColor.withOpacity(0.85),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Tips
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: "Quick Tips:",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      bottom: 12,
                    ),
                    _buildTipItem("Turn off airplane mode"),
                    _buildTipItem("Turn on mobile data or Wi-Fi"),
                    _buildTipItem("Check if you have signal"),
                    _buildTipItem("Restart your router if using Wi-Fi"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonText(
              text: text,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
