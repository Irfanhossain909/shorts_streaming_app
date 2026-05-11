import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/services/storage/storage_keys.dart';
import 'package:testemu/core/services/storage/storage_services.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/profile/model/faqs_model.dart';
import 'package:testemu/features/profile/model/profile_model.dart';

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
      if (response.isNoConnection) {
        return [];
      }
      errorLog(
        'getFaqs failed: ${response.statusCode} ${response.message}',
        source: 'getFaqs',
      );
      return [];
    } catch (e) {
      errorLog(e, source: "getFaqs");
      return [];
    }
  }

  Future<bool> editProfile({String? firstName, String? image}) async {
    try {
      // -------------------------------
      // MAIN DATA BODY
      // -------------------------------
      final Map<String, dynamic> data = {};

      void addIfValid(String key, dynamic value) {
        if (value != null && value.toString().isNotEmpty) {
          data[key] = value;
        }
      }

      // BASIC FIELDS (don't add image path as string field)
      addIfValid("name", firstName);

      // -------------------------------
      // FORM DATA (Multipart if image)
      // -------------------------------
      FormData formData = FormData.fromMap(data);

      // IMAGE FILE (add as multipart file, not as string field)
      if (image != null && image.isNotEmpty) {
        try {
          final file = File(image);
          if (await file.exists()) {
            final fileName = file.path.split('/').last;
            final mimeType = lookupMimeType(file.path);

            formData.files.add(
              MapEntry(
                "image",
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType.parse(
                    mimeType ?? "application/octet-stream",
                  ),
                ),
              ),
            );
          }
        } catch (e) {
          errorLog("❌ Image error: $e");
        }
      }

      // -------------------------------
      // API CALL
      // -------------------------------
      final response = await apiService.patch(
        apiEndPoint.editProfile,
        body: formData,
      );

      if (response.isSuccess) {
        appLog("✅ Profile updated successfully");
        return true;
      } else {
        appLog("❌ Profile update failed");
        return false;
      }
    } catch (e) {
      appLog(e);
      return false;
    }
  }

  Future<ProfileModelData?> getProfile() async {
    try {
      final response = await apiService.get(apiEndPoint.editProfile);
      if (response.isSuccess) {
        final data = response.data['data'] as Map<String, dynamic>? ?? {};
        final result = ProfileModelData.fromJson(data);
        await LocalStorage.setString(
          LocalStorageKeys.myName,
          result.name ?? '',
        );
        await LocalStorage.setBool(
          LocalStorageKeys.isSubscribed,
          result.isSubscribed ?? false,
        );
        return result;
      }
      if (response.isNoConnection) {
        return null;
      }
      errorLog(
        'getProfile failed: ${response.statusCode} ${response.message}',
        source: 'getProfile',
      );
      return null;
    } catch (e) {
      errorLog(e, source: "getProfile");
      return null;
    }
  }
}
