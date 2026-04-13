import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/button/common_button.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/features/setting/data/model/subscription_model.dart';
import 'package:testemu/features/setting/presentation/controller/subscription_controller.dart';

class SubCard extends StatelessWidget {
  final SubscriptionData subscription;
  final VoidCallback? onTap;
  const SubCard({super.key, required this.subscription, this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final productDetails = controller.getProductDetails(subscription);

    // Use IAP product data if available, otherwise fall back to API data
    final displayName = subscription.name ?? "";
    // final displayName = productDetails?.title ?? subscription.name ?? "";
    final displayDescription = subscription.description ?? "";
    // final displayDescription =
    //     productDetails?.description ?? subscription.description ?? "";
    final displayPrice = (subscription.price?.toString() ?? "0");
    // final displayPrice =
    //     productDetails?.price ?? (subscription.price?.toString() ?? "0");
    final displayDuration = subscription.duration ?? "";
    // final displayDuration = subscription.duration ?? "";

    // Get product ID to check subscription status
    final productId =
        productDetails?.id ?? (subscription.storeProductId ?? '');
    final isSubscribed = controller.isProductSubscribed(productId);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.background.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(12.w),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF981C2C), // top shadow
            Color(0xFF981C2C),
            Color(0xFF981C2C).withValues(alpha: .6), // bottom shadow
          ],
          stops: [
            0.0,
            0.7, // 70% red
            1.0, // 30% black
          ],
        ),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.h,
        children: [
          CommonText(
            text: displayName,
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.background,
          ),
          CommonText(
            text: displayDescription,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.background,
          ),
          // Show "Subscribed" text if already subscribed, otherwise show button
          isSubscribed
              ? Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.buton.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(30.w),
                    border: Border.all(color: AppColors.buton, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: CommonText(
                    text: "Subscribed",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.background,
                  ),
                )
              : CommonButton(
                  onTap: onTap,
                  isGradient: false,
                  borderColor: AppColors.buton,
                  buttonColor: AppColors.buton,
                  titleText: "Subscribe now",
                ),
          Align(
            alignment: Alignment.center,
            child: CommonText(
              text: "renew at $displayPrice/ $displayDuration",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }
}
