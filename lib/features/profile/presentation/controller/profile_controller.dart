import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/features/profile/model/profile_model.dart';
import 'package:testemu/features/profile/repository/profile_repository.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (LocalStorage.isGuest) return;
    isLoading.value = true;
    final response = await profileRepository.getProfile();

    if (response != null) {
      profileModel.value = response;
      update();
    }
    isLoading.value = false;
  }

Future<void> openStoreReview() async {
  String urlString = "";

  if (Platform.isIOS) {
    // এখানে আপনার অ্যাপের ১০ সংখ্যার Numeric ID দিবেন (যেমন: 6443456789)
    const String appleAppId = "6758427319"; 
    urlString = 'itms-apps://itunes.apple.com/app/id$appleAppId?action=write-review';
  } else if (Platform.isAndroid) {
    // অ্যান্ড্রয়েডের জন্য আপনার প্যাকেজ নাম বা বান্ডেল আইডি
    const String packageName = "com.rubengalindo.creepyshorts";
    urlString = 'https://play.google.com/store/apps/details?id=$packageName';
  }

  if (urlString.isNotEmpty) {
    final Uri url = Uri.parse(urlString);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // যদি স্টোর অ্যাপ না পাওয়া যায়, তবে ব্রাউজারে খোলার চেষ্টা করবে
      if (Platform.isIOS) {
         // আইওএস-এ itms-apps কাজ না করলে সাধারণ লিঙ্ক
         final Uri webUrl = Uri.parse('https://apps.apple.com/app/id6758427319');
         await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    }
  }
}
}
