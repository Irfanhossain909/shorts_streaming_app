import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/utils/helpers/other_helper.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/profile/repository/profile_repository.dart';
import 'package:testemu/features/profile/presentation/controller/profile_controller.dart';

class EditProfileController extends GetxController {
  // ------------------- Dependencies -------------------
  final ProfileRepository profileRepository = ProfileRepository.instance;

  // ------------------- Text Controllers -------------------
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // ------------------- States -------------------
  final RxBool isLoading = false.obs;

  // ------------------- Image -------------------
  String? image; // new selected image
  String? imageReceived; // image from arguments

  // ------------------- User Data -------------------
  String? name;
  String? email;

  // ------------------- Lifecycle -------------------
  @override
  void onInit() {
    super.onInit();
    _setInitialData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // ------------------- Initial Data Setup -------------------
  void _setInitialData() {
    final args = Get.arguments ?? {};

    name = args['name'];
    email = args['email'];
    imageReceived = args['image'];

    // Set name if empty
    if (nameController.text.isEmpty && name != null) {
      nameController.text = name!;
    }

    // Set email if empty
    if (emailController.text.isEmpty && email != null) {
      emailController.text = email!;
    }

    update();
  }

  // ------------------- Pick Image -------------------
  Future<void> getProfileImage() async {
    final selectedImage = await OtherHelper.openGalleryForProfile();

    if (selectedImage != null) {
      image = selectedImage;
      update(); // for GetBuilder
    }
  }

  // ------------------- Edit Profile -------------------
  void editProfile() {
    try {
      isLoading.value = true;

      profileRepository
          .editProfile(firstName: nameController.text.trim(), image: image)
          .then((isSuccess) {
            isLoading.value = false;

            if (isSuccess) {
              Get.find<ProfileController>().getProfile();
              Get.back();
            }
          })
          .catchError((e) {
            isLoading.value = false;
            appLog(e);
          });
    } catch (e) {
      isLoading.value = false;
      appLog(e);
    }
  }
}
