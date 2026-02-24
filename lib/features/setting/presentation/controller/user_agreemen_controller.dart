import 'package:get/get.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/features/setting/repository/setting_repository.dart';

import '../../data/model/html_model.dart';

class UserAgreementController extends GetxController {
  SettingRepository settingRepository = SettingRepository.instance;

  /// Api status check here
  Status status = Status.completed;

  ///  HTML model initialize here
  HtmlModel data = HtmlModel.fromJson({});

  /// Terms of services Controller instance create here
  static UserAgreementController get instance =>
      Get.put(UserAgreementController());

  ///  Terms of services Api call here
  Future<void> getUserAgreementRepo() async {
    status = Status.loading;
    update();

    var response = await settingRepository.getUserAgreement();

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
    getUserAgreementRepo();
    super.onInit();
  }
}
