import 'package:get/get.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/features/setting/repository/setting_repository.dart';

import '../../data/model/html_model.dart';

class PrivacyPolicyController extends GetxController {
  SettingRepository settingRepository = SettingRepository.instance;

  /// Api status check here
  Status status = Status.completed;

  ///  HTML model initialize here
  HtmlModel data = HtmlModel.fromJson({});

  /// Privacy Policy Controller instance create here
  static PrivacyPolicyController get instance =>
      Get.put(PrivacyPolicyController());

  /// Privacy Policy Api call here
  Future<void> getPrivacyPolicyRepo() async {
    status = Status.loading;
    update();
    final response = await settingRepository.getPrivacyPolicy();
    if (response != null) {
      data = HtmlModel.fromJson({'_id': '', 'content': response['data']});
      status = Status.completed;
      update();
    } else {
      status = Status.error;
      update();
    }
  }

  /// Controller on Init here
  @override
  void onInit() {
    getPrivacyPolicyRepo();
    super.onInit();
  }
}
