import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/shorts/model/season_video_details_model.dart';
import 'package:testemu/features/shorts/model/video_details_model.dart';
import 'package:testemu/features/shorts/repository/shorts_repository.dart';

class VideoDetailsController extends GetxController {
  late final String videoId;
  final ShortsRepository shortsRepository = ShortsRepository.instance;
  VideoDetailsController();
  var isLoading = false.obs;
  var isError = false.obs;
  var isSuccess = false.obs;
  var isEmpty = false.obs;
  var isNotEmpty = false.obs;
  var data = Rx<MovieDetailData?>(null);
  var seasonVideoData = Rx<List<SeasonVideo>?>(null);
  var seasonVideoIsLoading = false.obs;
  var seasonVideoIsError = false.obs;
  var seasonVideoIsSuccess = false.obs;
  var seasonVideoIsEmpty = false.obs;
  var seasonVideoIsNotEmpty = false.obs;
  @override
  void onInit() {
    videoId = Get.arguments['videoId'];
    appLog(videoId, source: 'VideoId');
    super.onInit();
    getVideoDetails();
  }

  Future<void> getVideoDetails() async {
    try {
      isLoading.value = true;
      final response = await shortsRepository.getVideoDetails(videoId);
      if (response != null) {
        getVideoDetailsSuccess(response);
      } else {
        getVideoDetailsError();
      }
    } catch (error) {
      getVideoDetailsError();
    } finally {
      isLoading.value = false;
    }
  }

  void getVideoDetailsSuccess(MovieDetailData? response) {
    isSuccess.value = true;
    data.value = response;
    getSeasonVideoDetails(response?.seasons.first.id ?? '');
  }

  void getVideoDetailsError() {
    isError.value = true;
  }

  void getVideoDetailsEmpty() {
    isEmpty.value = true;
  }

  void getVideoDetailsNotEmpty() {
    isNotEmpty.value = true;
  }

  Future<void> getSeasonVideoDetails(String seasonId) async {
    try {
      seasonVideoIsLoading.value = true;
      final SeasonVideoResponse response = await shortsRepository
          .getSeasonVideoDetailsById(seasonId);
      if (response.success) {
        getSeasonVideoDetailsSuccess(response.data);
      } else {
        getSeasonVideoDetailsError();
      }
    } catch (error) {
      getSeasonVideoDetailsError();
    } finally {
      seasonVideoIsLoading.value = false;
    }
  }

  void getSeasonVideoDetailsSuccess(List<SeasonVideo>? response) {
    seasonVideoIsSuccess.value = true;
    seasonVideoData.value = response;
  }

  void getSeasonVideoDetailsError() {
    seasonVideoIsError.value = true;
  }

  void getSeasonVideoDetailsEmpty() {
    seasonVideoIsEmpty.value = true;
  }

  void onSeasonTap(String videoUrl) {
    // Sanitize URL before passing
    String sanitizedUrl = _sanitizeUrl(videoUrl);
    appLog('Original VideoUrl: $videoUrl', source: 'VideoUrl');
    appLog('Sanitized VideoUrl: $sanitizedUrl', source: 'VideoUrl');
    if (sanitizedUrl.isNotEmpty) {
      Get.toNamed(AppRoutes.videoPlayer, arguments: {'videoUrl': sanitizedUrl});
    } else {
      appLog('Video URL is empty after sanitization', source: 'VideoUrl');
    }
  }

  String _sanitizeUrl(String url) {
    if (url.isEmpty) return '';

    // Remove all whitespace, newlines, and trim
    String sanitized = url
        .replaceAll(RegExp(r'\s+'), '') // Remove all whitespace
        .replaceAll('\n', '') // Remove newlines
        .replaceAll('\r', '') // Remove carriage returns
        .trim();

    return sanitized;
  }
}
