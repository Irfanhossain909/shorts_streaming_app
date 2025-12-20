import 'package:get/get.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/setting/data/model/subscription_model.dart';
import 'package:testemu/features/setting/repository/setting_repository.dart';

class SubscriptionController extends GetxController {
  SettingRepository settingRepository = SettingRepository.instance;

  /// Api status check here
  Status status = Status.completed;

  /// Subscriptions list here
  List<SubscriptionData> subscriptions = [];

  @override
  void onInit() {
    getSubscriptionRepo();
    super.onInit();
  }

  Future<void> getSubscriptionRepo() async {
    status = Status.loading;
    update();
    final response = await settingRepository.getSubscription();
    if (response.success == true) {
      subscriptions = response.data ?? [];
      appLog(subscriptions.length.toString(), source: "Get Subscription");
      appLog(subscriptions.toString(), source: "Get Subscription");
      status = Status.completed;
      update();
    } else {
      status = Status.error;
      update();
    }
  }
}
