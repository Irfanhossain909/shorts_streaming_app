import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/services/storage/storage_keys.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/core/utils/app_utils.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';

class AuthRepository {
  AuthRepository._();
  ApiService apiService = ApiService.instance;

  static final AuthRepository _instance = AuthRepository._();
  static AuthRepository get instance => _instance;

  Future<bool> login({required String email, required String password}) async {
    try {
      Map<String, String> body = {"email": email, "password": password};
      var response = await apiService.post(
        ApiEndPoint.instance.signIn,
        body: body,
      );
      appLog(response.data, source: "Login Response");
      if (response.statusCode == 200) {
        String accessToken = response.data["data"]["accessToken"];
        await LocalStorage.setString(LocalStorageKeys.token, accessToken);
        appLog("Access Token stored successfully");

        return true;
      } else {
        // Handle the error if the response or data is null
        appLog("Error: Access Token not found!", source: "Login Response");
      }

      return false;
    } on DioException catch (error) {
      if (error.response?.data["message"].runtimeType != null) {
        Utils.errorSnackBar(
          Get.context!,
          "${error.response?.data["message"] ?? "Something went wrong"}",
          "Login",
        );
      }
      return false;
    } catch (e) {
      errorLog(e, source: "Login");
      return false;
    }
  }

  Future<bool> resendOtp({required String email}) async {
    Map<String, String> body = {"email": email};
    try {
      final response = await apiService.post(
        ApiEndPoint.instance.resendOtp,
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {
        Utils.errorSnackBar(
          Get.context!,
          "${response.data["message"] ?? "Something went wrong"}",
          "Resend Otp",
        );
      }
    } catch (e) {
      errorLog(e, source: "ResendOtp");
    }
    return false;
  }

  Future<bool> forgetPassword({required String email}) async {
    Map<String, String> body = {"email": email};
    try {
      final response = await apiService.post(
        ApiEndPoint.instance.forgotPassword,
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {
        Utils.errorSnackBar(
          Get.context!,
          "${response.data["message"] ?? "Something went wrong"}",
          "Resend Otp",
        );
      }
    } catch (e) {
      errorLog(e, source: "ResendOtp");
    }
    return false;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      Map<String, String> body = {
        "name": name,
        "email": email,
        "password": password,
      };

      final response = await apiService.post(
        ApiEndPoint.instance.signUp,
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (error) {
      if (error.response?.data["message"].runtimeType != null) {
        Utils.errorSnackBar(
          Get.context!,
          "${error.response?.data["message"] ?? "Something was wrong"}",
          "Sign Up",
        );
      }
      return false;
    } catch (e) {
      errorLog(e, source: "Sign Up");
      return false;
    }
  }

  Future<bool> emailVerify({required String email, required int otp}) async {
    Map<String, dynamic> body = {"email": email, "oneTimeCode": otp};
    try {
      final response = await apiService.post(
        ApiEndPoint.instance.verifyEmail,
        body: body,
      );
      if (response.statusCode == 200 && response.data["data"] != null) {
        String accessToken = response.data["data"]["accessToken"];
        await LocalStorage.setString(LocalStorageKeys.token, accessToken);
        appLog("Access Token stored successfully");
        return true;
      } else if (response.statusCode == 400) {
        Utils.errorSnackBar(
          Get.context!,
          "${response.data["message"] ?? "Something was wrong"}",
          "Verify Email",
        );
      } else {
        Utils.errorSnackBar(
          Get.context!,
          "${response.data["message"] ?? "Something was wrong"}",
          "Verify Email",
        );
      }

      return false;
    } catch (e) {
      errorLog(e, source: "Verify Email");
    }
    return false;
  }

  // Future<dynamic> forgetPassEmailVerify({
  //   required String email,
  //   required String otp,
  // }) async {
  //   Map<String, dynamic> body = {"email": email, "oneTimeCode": otp};
  //   try {
  //     var response = await nonAuthApi.sendRequest.post(
  //       AppApiEndPoint.instance.verifyPhone,
  //       data: body,
  //     );
  //     if (response.statusCode == 200 && response.data["data"] != null) {
  //       String resetToken = response.data["data"]["resetToken"];
  //       // storageServices.setToken(accessToken);
  //       // AppPrint.apiResponse(storageServices.getToken(), title: "Store Token");
  //       return resetToken;
  //     } else if (response.statusCode == 400) {
  //       AppSnackBar.error(response.data["message"]);
  //     } else {
  //       AppPrint.apiResponse("Error: Access Token not found!");
  //     }

  //     return false;
  //   } catch (e) {
  //     AppPrint.appError(e.toString(), title: "phone Verify");
  //   }
  //   return false;
  // }

  // Future<bool> resetPassword({
  //   required String newPassword,
  //   required String confirmPassword,
  //   required String resetToken,
  // }) async {
  //   try {
  //     appInPutUnfocused();
  //     Map body = {
  //       "newPassword": newPassword,
  //       "confirmPassword": confirmPassword,
  //     };
  //     var response = await nonAuthApi.sendRequest.post(
  //       AppApiEndPoint.instance.resetPassword,
  //       data: body,
  //       options: Options(
  //         receiveTimeout: const Duration(minutes: 2),
  //         sendTimeout: const Duration(minutes: 2),
  //         headers: {"Accept": "application/json", "Authorization": resetToken},
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       AppPrint.appLog("confirm password repository response :: $response");
  //       return true;
  //     }
  //     return false;
  //   } on DioException catch (error) {
  //     if (error.response?.data["message"].runtimeType != Null) {
  //       AppSnackBar.error(
  //         "${error.response?.data["message"] ?? "Something was wrong"}",
  //       );
  //     }
  //     return false;
  //   } catch (e) {
  //     errorLog("resetPassword", e);
  //     return false;
  //   }
  // }
}
