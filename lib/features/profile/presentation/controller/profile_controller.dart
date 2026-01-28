import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/features/profile/model/profile_model.dart';
import 'package:testemu/features/profile/repository/profile_repository.dart';

class ProfileController extends GetxController {
  // ----------------repository here

  ProfileRepository profileRepository = ProfileRepository.instance;

  /// edit button loading here
  final RxBool isLoading = false.obs;

  Rxn<ProfileModelData> profileModel = Rxn<ProfileModelData>();

  /// all controller here
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  //------------------------ Main Func Call
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  void getProfile() async {
    isLoading.value = true;
    final response = await profileRepository.getProfile();

    if (response != null) {
      profileModel.value = response;
      update();
    }
    isLoading.value = false;
  }
}
