import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/button/common_button_pro.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import '../controller/forget_password_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_string.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final formKey = GlobalKey<FormState>();

  /// init State here
  @override
  void initState() {
    ForgetPasswordController.instance.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section
      appBar: AppBar(
        title: const CommonText(
          text: AppString.forgotPassword,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),

      /// Body Section
      body: GetBuilder<ForgetPasswordController>(
        builder: (controller) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Log In Instruction here
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.background),
                    borderRadius: BorderRadius.circular(30.w),
                    color: AppColors.white.withValues(alpha: 0.3),
                  ),
                  child: Column(
                    spacing: 8.h,
                    children: [
                      CommonImage(
                        imageSrc: AppImages.verifyImage,
                        width: 210.w,
                      ),
                      CommonText(
                        text: "Verify Your Account",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.background,
                      ),
                      CommonText(
                        maxLines: 3,
                        textAlign: TextAlign.center,

                        text:
                            "We’ve sent a verification code to your email/phone. Enter the code below to continue and secure your account.",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
                24.height,
                Center(
                  child: CommonText(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    text:
                        "${AppString.codeHasBeenSendTo} ${controller.emailController.text}",
                    fontSize: 14.sp,
                  ),
                ),
                24.height,

                /// OTP Filed here
                PinCodeTextField(
                  textStyle: TextStyle(color: AppColors.background),
                  controller: controller.otpController,
                  validator: (value) {
                    if (value != null && value.length == 6) {
                      return null;
                    } else {
                      return AppString.otpIsInValid;
                    }
                  },
                  autoDisposeControllers: false,
                  cursorColor: AppColors.white,
                  appContext: (context),
                  autoFocus: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 60.h,
                    fieldWidth: 60.w,

                    activeFillColor: AppColors.white.withValues(alpha: .4),
                    selectedFillColor: AppColors.white.withValues(alpha: .4),
                    inactiveFillColor: AppColors.white.withValues(alpha: .4),
                    borderWidth: 0.5.w,
                    selectedColor: AppColors.white,
                    activeColor: AppColors.white,
                    inactiveColor: AppColors.white,
                  ),
                  length: 6,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.disabled,
                  enableActiveFill: true,
                ),

                /// Resent OTP or show Timer
                GestureDetector(
                  onTap: controller.time == '00:00'
                      ? () {
                          controller.startTimer();
                          controller.forgotPasswordRepo();
                        }
                      : () {},
                  child: CommonText(
                    color: AppColors.background,
                    text: controller.time == '00:00'
                        ? "If you didn’t receive a ${AppString.resendCode}"
                        : "${AppString.resendCodeIn} ${controller.time} ${AppString.minute}",

                    fontSize: controller.time == '00:00' ? 14.sp : 18.sp,
                  ),
                ),
                24.height,

                ///  Submit Button here
                CommonButtonPro(text: "Get Verification Code"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
