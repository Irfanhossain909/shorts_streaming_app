import 'package:get/get.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/setting/data/model/subscription_model.dart';

class SettingRepository {
  SettingRepository._();
  ApiService apiService = ApiService.instance;
  ApiEndPoint apiEndPoint = ApiEndPoint.instance;

  static final SettingRepository _instance = SettingRepository._();
  static SettingRepository get instance => _instance;

  Future<dynamic> getPrivacyPolicy() async {
    try {
      final response = await apiService.get(
        apiEndPoint.settings,
        queryParameters: {"key": "privacyPolicy"},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        errorLog(response.data, source: "Get Privacy Policy");
      }
    } catch (e) {
      errorLog(e, source: "Get Privacy Policy");
      return null;
    }
  }

  Future<dynamic> getUserAgreement() async {
    try {
      final response = await apiService.get(
        apiEndPoint.settings,
        queryParameters: {"key": "userAgreement"},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        errorLog(response.data, source: "Get User Agreement");
      }
    } catch (e) {
      errorLog(e, source: "Get User Agreement");
      return null;
    }
  }

  Future<SubscriptionModel> getSubscription() async {
    try {
      final response = await apiService.get(apiEndPoint.subscription);
      if (response.statusCode == 200) {
        SubscriptionModel subscriptionModel = SubscriptionModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return subscriptionModel;
      } else {
        errorLog(response.data, source: "Get Subscription");
        return SubscriptionModel(
          success: false,
          message: "Something went wrong",
          statusCode: 500,
          data: [],
          meta: Meta(),
        );
      }
    } catch (e) {
      errorLog(e, source: "Get Subscription");
      return SubscriptionModel(
        success: false,
        message: "Something went wrong",
        statusCode: 500,
        data: [],
        meta: Meta(),
      );
    }
  }

  Future<dynamic> deleteAccount({required String password}) async {
    try {
      final response = await apiService.delete(
        apiEndPoint.deleteAccount,
        body: {"password": password},
      );
      if (response.statusCode == 200) {
        return response.data["success"];
      } else if (response.statusCode == 401) {
        Utils.errorSnackBar(
          Get.context!,
          "Delete Account",
          "${response.data["message"] ?? "Something went wrong"}",
        );
        return response.data;
      } else {
        errorLog(response.data, source: "Delete Account");
      }
    } catch (e) {
      errorLog(e, source: "Delete Account");
      return null;
    }
  }
}
