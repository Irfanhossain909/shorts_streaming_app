import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/features/shorts/model/recent_videos_model.dart';
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
  var selectedSeasonId = Rx<String?>(null);
  var listOfVideos = Rx<List<String>?>(null);
  var recentVideos = Rx<List<RecentlyViewedItem>?>(null);
  @override
  void onInit() {
    videoId = Get.arguments['videoId'];
    appLog(videoId, source: 'VideoId');
    super.onInit();
    getVideoDetails();
    getRecentVideos();
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
    // Set initial selected season
    if (response?.seasons.isNotEmpty ?? false) {
      selectedSeasonId.value = response!.seasons.first.id;
      getSeasonVideoDetails(selectedSeasonId.value ?? '');
    }
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
    listOfVideos.value = response?.map((e) => e.downloadUrl).toList();
    appLog('List of Videos: ${listOfVideos.value}', source: 'List of Videos');
  }

  void getSeasonVideoDetailsError() {
    seasonVideoIsError.value = true;
  }

  void getSeasonVideoDetailsEmpty() {
    seasonVideoIsEmpty.value = true;
  }

  Future<void> onSeasonTap(String videoUrl, String videoId, int index) async {
    appLog('🎬 Opening episode in shorts-style player', source: 'VideoUrl');
    appLog('Episode index: $index', source: 'VideoUrl');

    if (seasonVideoData.value != null && seasonVideoData.value!.isNotEmpty) {
      appLog(
        'Found ${seasonVideoData.value!.length} episodes',
        source: 'List of Videos',
      );

      // Add to recent videos before navigation
      await addRecentVideo(videoId);

      // Navigate to shorts-style episode player
      Get.toNamed(
        AppRoutes.episodeShorts,
        arguments: {'episodes': seasonVideoData.value!, 'initialIndex': index},
      );
    } else {
      appLog('No episode data available', source: 'VideoUrl');
    }
  }

  void onSeasonChanged(String? seasonId) {
    if (seasonId != null && seasonId.isNotEmpty) {
      selectedSeasonId.value = seasonId;
      getSeasonVideoDetails(seasonId);
    }
  }

  Future<void> addRecentVideo(String videoId) async {
    final response = await shortsRepository.addRecentVideo(videoId);
    if (response.statusCode == 200) {
      appLog('Recent video added successfully', source: 'Recent Video');
    } else {
      appLog(
        'Failed to add recent video: ${response.message}',
        source: 'Recent Video',
      );
    }
  }

  Future<void> getRecentVideos() async {
    final RecentVideosResponse response = await shortsRepository
        .getRecentVideos();
    if (response.success && response.statusCode == 200) {
      // Filter out items with null videoId
      final validVideos = response.data
          .where((item) => item.videoId != null)
          .toList();
      recentVideos.value = validVideos;
      appLog(
        'Recent videos: ${validVideos.length} valid items (filtered from ${response.data.length} total)',
        source: 'Recent Videos',
      );
      appLog('Recent videos fetched successfully', source: 'Recent Videos');
    } else {
      appLog(
        'Failed to fetch recent videos: ${response.message}',
        source: 'Recent Videos',
      );
    }
  }
}
