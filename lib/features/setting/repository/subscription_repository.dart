import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/log/error_log.dart';

class SubscriptionRepository {
  SubscriptionRepository._();
  static final SubscriptionRepository _instance = SubscriptionRepository._();
  static SubscriptionRepository get instance => _instance;

  ApiService apiService = ApiService.instance;

  Future<bool> verifyPurchase({
    String? provider,
    String? productId,
    String? purchaseToken,
    String? packageName,
    String? price,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndPoint.instance.verifyPurchase,
        body: {
          "provider": provider,
          "productId": productId,
          "purchaseToken": purchaseToken,
          "packageName": packageName,
          "price": price,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorLog(e, source: "Verify Purchase");
      return false;
    }
  }
}
