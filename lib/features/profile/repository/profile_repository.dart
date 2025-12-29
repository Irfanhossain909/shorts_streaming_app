import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/profile/model/faqs_model.dart';

class ProfileRepository {
  static ProfileRepository? _instance;
  static ProfileRepository get instance => _instance ??= ProfileRepository();
  ApiService apiService = ApiService.instance;
  ApiEndPoint apiEndPoint = ApiEndPoint.instance;

  Future<List<FaqsModel>> getFaqs() async {
    try {
      final response = await apiService.get(apiEndPoint.getFaqs);
      if (response.isSuccess) {
        final data = response.data['data'] as List<dynamic>? ?? [];
        final result = data
            .map((e) => FaqsModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return result;
      }
      throw Exception(response.message);
    } catch (e) {
      errorLog(e, source: "getFaqs");
      throw Exception(e);
    }
  }
}
