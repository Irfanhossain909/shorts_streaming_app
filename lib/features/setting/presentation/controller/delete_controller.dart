import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/button/common_button.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/component/text_field/common_text_field.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/setting/repository/setting_repository.dart';

class DeleteController extends GetxController {
  SettingRepository settingRepository = SettingRepository.instance;
  TextEditingController deleteConfirmController = TextEditingController();

  @override
  void onInit() {
    deleteConfirmController = TextEditingController();
    super.onInit();
  }

  void showDeleteAccountDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CommonText(
                text: "Delete Account",
                fontSize: 20,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              const CommonText(
                text: "Enter your password to delete your account.",
                fontSize: 14,
                color: AppColors.white,
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CommonTextField(
                controller: deleteConfirmController,
                hintText: "Enter Password",
                fillColor: AppColors.white.withOpacity(0.1),
                textColor: AppColors.white,
                hintTextColor: AppColors.white.withOpacity(0.5),
                borderColor: AppColors.grey.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      titleText: "Cancel",
                      buttonColor: AppColors.transparent,
                      borderColor: AppColors.white,
                      isGradient: false,
                      onTap: () {
                        deleteConfirmController.clear();
                        Get.back();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CommonButton(
                      titleText: "Delete",

                      buttonColor: AppColors.buton,
                      borderColor: AppColors.buttonColor2,
                      isGradient: false,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        deleteAccount();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    if (deleteConfirmController.text.isEmpty) {
      return;
    }
    try {
      final response = await settingRepository.deleteAccount(
        password: deleteConfirmController.text,
      );
      if (response == true) {
        LocalStorage.removeAllPrefData();
      }
    } catch (e) {
      errorLog(e, source: "Delete Account");
    }
  }

  @override
  void onClose() {
    deleteConfirmController.dispose();
    super.onClose();
  }
}
