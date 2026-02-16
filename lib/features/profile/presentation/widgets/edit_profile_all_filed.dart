import 'package:flutter/material.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/component/text_field/common_text_field.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_string.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/features/profile/presentation/controller/edit_profile_controller.dart';

class EditProfileAllFiled extends StatelessWidget {
  const EditProfileAllFiled({super.key, required this.controller});

  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// User Full Name here
        const CommonText(
          text: AppString.fullName,
          fontWeight: FontWeight.w600,
          color: AppColors.background,
          bottom: 12,
        ),
        CommonTextField(
          controller: controller.nameController,
          validator: OtherHelper.validator,
          hintText: AppString.fullName,
          textColor: AppColors.background,
          prefixIcon: const Icon(Icons.person),
          keyboardType: TextInputType.text,
          borderColor: AppColors.black,
          fillColor: AppColors.transparent,
        ),

        /// User Phone number here
        const CommonText(
          text: AppString.email,
          fontWeight: FontWeight.w600,
          color: AppColors.background,
          top: 20,
          bottom: 12,
        ),
        CommonTextField(
          controller: controller.emailController,
          validator: OtherHelper.validator,
          hintText: AppString.email,
          textColor: AppColors.background,
          prefixIcon: const Icon(Icons.person),
          keyboardType: TextInputType.text,
          borderColor: AppColors.black,
          fillColor: AppColors.transparent,
          readOnly: true,
        ),
        // CommonPhoneNumberTextFiled(
        //   controller: controller.numberController,
        //   countryChange: (value) {
        //     appLog(value);
        //   },
        // ),
      ],
    );
  }
}
