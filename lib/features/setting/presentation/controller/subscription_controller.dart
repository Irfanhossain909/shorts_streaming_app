import 'package:get/get.dart';
import 'package:testemu/core/services/subscription_service/subscription_service.dart';
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
    loadSubscriptions();
    super.onInit();
  }

  /// Initialize subscription service
  final SubscriptionService subscriptionService = SubscriptionService.instance;

  void loadSubscriptions() async {
    final products = await subscriptionService.loadProducts(
      productIds: ['basic_1_month',],
    );

    appLog("Loaded products: ${products.length}", source: "Load Subscriptions");
  }

  /// Get subscription repository
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
