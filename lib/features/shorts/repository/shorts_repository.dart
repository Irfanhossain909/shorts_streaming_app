import 'package:testemu/core/config/api/api_end_point.dart';
import 'package:testemu/core/services/api/api_response_model.dart';
import 'package:testemu/core/services/api/api_service.dart';
import 'package:testemu/core/utils/log/error_log.dart';
import 'package:testemu/features/shorts/model/recent_videos_model.dart';
import 'package:testemu/features/shorts/model/season_video_details_model.dart';
import 'package:testemu/features/shorts/model/shorts_video_model.dart';
import 'package:testemu/features/shorts/model/video_details_model.dart';

class ShortsRepository {
  ShortsRepository._();
  static final ShortsRepository _instance = ShortsRepository._();
  static ShortsRepository get instance => _instance;
  ApiService apiService = ApiService.instance;
  ApiEndPoint apiEndPoint = ApiEndPoint.instance;

  Future<MovieDetailData?> getVideoDetails(String videoId) async {
    try {
      final response = await apiService.get(
        '${apiEndPoint.getVideoDetails}$videoId',
      );
      if (response.statusCode == 200) {
        // Parse the full response first
        final movieDetailResponse = MovieDetailResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        // Return the nested data
        return movieDetailResponse.data;
      } else {
        return null;
      }
    } catch (e) {
      errorLog(e, source: 'Get Video Details');
      return null;
    }
  }

  Future<SeasonVideoResponse> getSeasonVideoDetailsById(String seasonId) async {
    try {
      final response = await apiService.get(
        '${apiEndPoint.getSeasonVideoDetailsById}$seasonId',
      );
      if (response.statusCode == 200) {
        final seasonVideoResponse = SeasonVideoResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return seasonVideoResponse;
      } else {
        return SeasonVideoResponse(
          success: false,
          message: response.message,
          statusCode: response.statusCode,
          data: [],
        );
      }
    } catch (e) {
      errorLog(e, source: 'Get Season Video Details');
      return SeasonVideoResponse(
        success: false,
        message: '',
        statusCode: 0,
        data: [],
      );
    }
  }

  Future<ApiResponseModel> downloadVideo(
    String url,
    String savePath, {
    Function(int, int)? onProgress,
  }) async {
    try {
      final response = await apiService.downloadFile(
        url,
        savePath,
        onProgress: onProgress,
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      errorLog(e, source: 'Download Video');
      throw Exception(e.toString());
    }
  }

  Future<ApiResponseModel> addRecentVideo(String videoId) async {
    try {
      final response = await apiService.post(
        '${apiEndPoint.addRecentVideos}$videoId',
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      errorLog(e, source: 'Add Recent Video');
      return ApiResponseModel(500, {'message': 'Failed to add recent video'});
    }
  }

  Future<RecentVideosResponse> getRecentVideos() async {
    try {
      final response = await apiService.get(apiEndPoint.getRecentVideos);
      if (response.statusCode == 200) {
        final recentVideosResponse = RecentVideosResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return recentVideosResponse;
      } else {
        return RecentVideosResponse(
          success: false,
          message: response.message,
          statusCode: response.statusCode,
          data: [],
        );
      }
    } catch (e) {
      errorLog(e, source: 'Get Recent Videos');
      return RecentVideosResponse(
        success: false,
        message: 'Failed to fetch recent videos',
        statusCode: 500,
        data: [],
      );
    }
  }

  Future<ShortsVideosResponse> getShortsVideos() async {
    try {
      final response = await apiService.get(apiEndPoint.getShortsVideos);
      if (response.statusCode == 200) {
        final shortsVideosResponse = ShortsVideosResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return shortsVideosResponse;
      } else {
        return ShortsVideosResponse(
          success: false,
          message: response.message,
          statusCode: response.statusCode,
          data: [],
        );
      }
    } catch (e) {
      errorLog(e, source: 'Get Shorts Videos');
      return ShortsVideosResponse(
        success: false,
        message: 'Failed to fetch shorts videos',
        statusCode: 500,
        data: [],
      );
    }
  }
}
