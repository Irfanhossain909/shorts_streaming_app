import 'package:get/get.dart';
import 'package:testemu/core/services/subscription_service/subscription_service.dart';
import 'package:testemu/core/utils/app_utils.dart';
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

  /// Initialize subscription service
  final SubscriptionService subscriptionService = SubscriptionService.instance;

  void loadSubscriptions({required List<String> productId}) async {
    await subscriptionService.init(productIds: productId);

    final products = subscriptionService.products;

    if (products.isEmpty) {
      print("❌ No Products Found");
    } else {
      for (var product in products) {
        print("🟢 Product ID: ${product.id}");
        print("Title: ${product.title}");
        print("Price: ${product.price}");
        print("Price: ${product.currencyCode}");
        print("Price: ${product.currencySymbol}");
      }
    }
  }

  void buySubscription(String productId) async {
    await subscriptionService.buySubscription(productId);
  }

  /// Get subscription repository
  Future<void> getSubscriptionRepo() async {
    status = Status.loading;
    update();
    final response = await settingRepository.getSubscription();
    if (response.success == true) {
      subscriptions = response.data ?? [];
      loadSubscriptions(
        productId: ["basic_1_month"],
        // productId: subscriptions.map((e) => e.id ?? '').toList(),
      );
      
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
