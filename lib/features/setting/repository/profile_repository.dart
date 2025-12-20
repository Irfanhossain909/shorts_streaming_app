import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/log/error_log.dart';

class ProfileRepository {
  ProfileRepository._();
  ApiService apiService = ApiService.instance;
  ApiEndPoint apiEndPoint = ApiEndPoint.instance;

  static final ProfileRepository _instance = ProfileRepository._();
  static ProfileRepository get instance => _instance;

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
}
