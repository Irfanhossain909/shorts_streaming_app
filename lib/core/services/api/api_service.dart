import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:mime/mime.dart';

import '../../../core/config/api/api_end_point.dart';
import '../../../core/config/route/app_routes.dart';
import '../../constants/app_string.dart';
import '../../utils/log/api_log.dart';
import '../storage/storage_services.dart';
import 'api_response_model.dart';

class ApiService {
  static final Dio _dio = _getMyDio();

  ApiService._();
  static final ApiService _instance = ApiService._();
  static ApiService get instance => _instance;

  /// ========== [ HTTP METHODS ] ========== ///
  Future<ApiResponseModel> post(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "POST", body: body, header: header);

  Future<ApiResponseModel> get(
    String url, {
    Map<String, String>? header,
    Map<String, String>? queryParameters,
  }) => _request(url, "GET", header: header, queryParameters: queryParameters);

  Future<ApiResponseModel> put(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "PUT", body: body, header: header);

  Future<ApiResponseModel> patch(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "PATCH", body: body, header: header);

  Future<ApiResponseModel> delete(
    String url, {
    dynamic body,
    Map<String, String>? header,
  }) => _request(url, "DELETE", body: body, header: header);

  Future<ApiResponseModel> multipart(
    String url, {
    Map<String, String>? header,
    Map<String, String> body = const {},
    // String method = "POST",
    String method = "PATCH",
    String imageName = 'image',
    String? imagePath,
  }) async {
    final Map<String, String> finalHeader = header != null
        ? Map.from(header)
        : {};
    FormData formData = FormData();
    if (imagePath != null && imagePath.isNotEmpty) {
      File file = File(imagePath);
      String extension = file.path.split('.').last.toLowerCase();
      String? mimeType = lookupMimeType(imagePath);

      formData.files.add(
        MapEntry(
          imageName,
          await MultipartFile.fromFile(
            imagePath,
            filename: "$imageName.$extension",
            contentType: mimeType != null
                ? DioMediaType.parse(mimeType)
                : DioMediaType.parse("image/jpeg"),
          ),
        ),
      );
    }

    body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    finalHeader['Content-Type'] = "multipart/form-data";
    return _request(url, method, body: formData, header: finalHeader);
  }

  Future<ApiResponseModel> downloadFile(
    String url,
    String savePath, {
    Function(int, int)? onProgress,
  }) async {
    try {
      print('🔽 Dio download starting...');
      print('🔗 URL: $url');
      print('💾 Save path: $savePath');

      final response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (onProgress != null) {
            onProgress(received, total);
          }
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            print('📊 Dio progress: $progress% ($received/$total bytes)');
          }
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 10),
          sendTimeout: const Duration(minutes: 10),
          // CRITICAL: ResponseType must be bytes for file downloads
          responseType: ResponseType.bytes,
          // Follow redirects for CDN URLs
          followRedirects: true,
          maxRedirects: 5,
          // Accept any status < 500
          validateStatus: (status) => status! < 500,
        ),
      );

      print('✅ Dio download completed');
      print('📊 Response status: ${response.statusCode}');
      print('📊 Response data type: ${response.data.runtimeType}');

      // CRITICAL: For downloads, don't use _handleResponse
      // Just return success/failure based on status code
      if (response.statusCode == 200) {
        print('✅ Download successful, returning 200');
        return ApiResponseModel(200, {
          'success': true,
          'message': 'Download completed',
        });
      } else {
        print('❌ Download failed with status: ${response.statusCode}');
        return ApiResponseModel(response.statusCode ?? 500, {
          'success': false,
          'message': 'Download failed',
        });
      }
    } catch (e) {
      // Better error logging for downloads
      if (e is DioException) {
        print('❌ Download DioException: ${e.type}');
        print('❌ Error Message: ${e.message}');
        print('❌ Response: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('❌ Download Error: $e');
      }
      return _handleError(e);
    }
  }

  /// ========== [ API REQUEST HANDLER ] ========== ///
  Future<ApiResponseModel> _request(
    String url,
    String method, {
    dynamic body,
    Map<String, String>? header,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: body,
        options: Options(method: method, headers: header),
        queryParameters: queryParameters ?? {},
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  ApiResponseModel _handleResponse(Response response) {
    if (response.statusCode == 201) {
      return ApiResponseModel(200, response.data);
    }
    return ApiResponseModel(response.statusCode, response.data);
  }

  ApiResponseModel _handleError(dynamic error) {
    try {
      return _handleDioException(error);
    } catch (e) {
      return ApiResponseModel(500, {});
    }
  }

  ApiResponseModel _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiResponseModel(408, {"message": AppString.requestTimeOut});

      case DioExceptionType.badResponse:
        return ApiResponseModel(
          error.response?.statusCode,
          error.response?.data,
        );

      case DioExceptionType.connectionError:
        // Navigate to No Internet screen
        _navigateToNoInternet();
        return ApiResponseModel(503, {
          "message": AppString.noInternetConnection,
        });

      default:
        return ApiResponseModel(400, {});
    }
  }

  /// Navigate to No Internet Screen
  void _navigateToNoInternet() {
    // Check if already on no internet screen to avoid duplicate navigation
    if (getx.Get.currentRoute != AppRoutes.noInternet) {
      getx.Get.toNamed(AppRoutes.noInternet);
    }
  }
}

/// ========== [ DIO INSTANCE WITH INTERCEPTORS ] ========== ///
Dio _getMyDio() {
  Dio dio = Dio();

  dio.interceptors.add(apiLog());

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add authorization header
        options.headers["Authorization"] ??= "Bearer ${LocalStorage.token}";

        // Set timeouts (can be overridden by individual requests)
        options.connectTimeout ??= const Duration(seconds: 30);
        options.sendTimeout ??= const Duration(seconds: 30);
        options.receiveTimeout ??= const Duration(seconds: 30);

        options.receiveDataWhenStatusError = true;

        // CRITICAL FIX: Don't force responseType to json
        // Let individual requests specify their own responseType
        // For API calls it will default to json, for downloads it should be stream
        if (options.responseType != ResponseType.stream) {
          options.responseType = ResponseType.json;
        }

        // Set baseUrl only if URL doesn't already start with http/https
        final path = options.path;
        if (path.startsWith("http")) {
          // For full URLs (like video CDN), don't use baseUrl
          options.baseUrl = "";
        } else {
          options.baseUrl = ApiEndPoint.instance.baseUrl;
        }

        // Only set Content-Type to application/json if not FormData
        // Dio will automatically set multipart/form-data with boundary for FormData
        if (options.data is! FormData) {
          options.headers["Content-Type"] ??= "application/json";
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) async {
        final message = error.response?.data?['message']?.toString() ?? '';
        if (message.contains('This user is not found')) {
          await LocalStorage.removeAllPrefData();
          return;
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
