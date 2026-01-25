import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemu/core/config/route/app_routes.dart';
import 'package:testemu/features/download/model/downloaded_video_model.dart';
import 'package:testemu/features/download/service/download_service.dart';

class DownloadedShortsController extends GetxController {
  final DownloadService _downloadService = DownloadService.instance;

  // Observable list of downloaded videos
  RxList<DownloadedVideoModel> downloadedVideos = <DownloadedVideoModel>[].obs;

  // Loading state
  RxBool isLoading = false.obs;

  // Selection mode
  RxBool isSelectionMode = false.obs;
  RxList<String> selectedVideoIds = <String>[].obs;

  // Total storage used
  RxString totalStorageUsed = '0 MB'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDownloadedVideos();
  }

  /// Fetch all downloaded videos
  Future<void> fetchDownloadedVideos() async {
    try {
      isLoading.value = true;
      final videos = await _downloadService.getAllDownloadedVideos();
      downloadedVideos.value = videos;

      // Calculate total storage
      final totalBytes = await _downloadService.getTotalStorageUsed();
      totalStorageUsed.value = _downloadService.formatStorageSize(totalBytes);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error loading downloads",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle selection mode
  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedVideoIds.clear();
    }
  }

  /// Toggle video selection
  void toggleVideoSelection(String videoId) {
    if (selectedVideoIds.contains(videoId)) {
      selectedVideoIds.remove(videoId);
    } else {
      selectedVideoIds.add(videoId);
    }
  }

  /// Select all videos
  void selectAllVideos() {
    if (selectedVideoIds.length == downloadedVideos.length) {
      // Deselect all
      selectedVideoIds.clear();
    } else {
      // Select all
      selectedVideoIds.value = downloadedVideos.map((v) => v.videoId).toList();
    }
  }

  /// Delete selected videos
  Future<void> deleteSelectedVideos() async {
    if (selectedVideoIds.isEmpty) {
      Get.snackbar(
        "No Selection",
        "No videos selected",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final success = await _downloadService.deleteMultipleVideos(
        selectedVideoIds.toList(),
      );

      if (success) {
        Get.snackbar(
          "Success",
          "Videos deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
        selectedVideoIds.clear();
        isSelectionMode.value = false;
        await fetchDownloadedVideos();
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete some videos",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error deleting videos",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a single video
  Future<void> deleteSingleVideo(String videoId) async {
    try {
      isLoading.value = true;
      final success = await _downloadService.deleteDownloadedVideo(videoId);

      if (success) {
        Get.snackbar(
          "Success",
          "Video deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchDownloadedVideos();
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete video",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error deleting video",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if video is selected
  bool isVideoSelected(String videoId) {
    return selectedVideoIds.contains(videoId);
  }

  /// Get video at index
  DownloadedVideoModel getVideoAt(int index) {
    return downloadedVideos[index];
  }

  /// Navigate to play downloaded video
  void playDownloadedVideo(int initialIndex) {
    if (isSelectionMode.value) {
      toggleVideoSelection(downloadedVideos[initialIndex].videoId);
      return;
    }

    // Navigate to video player with downloaded videos list
    Get.toNamed(
      AppRoutes.downloadedShortsPlayer,
      arguments: {
        'videos': downloadedVideos,
        'initialIndex': initialIndex,
      },
    );
  }

  /// Show delete confirmation dialog
  void showDeleteConfirmationDialog() {
    if (selectedVideoIds.isEmpty) {
      Get.snackbar(
        "No Selection",
        "No videos selected",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Delete Videos",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete ${selectedVideoIds.length} video(s)?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteSelectedVideos();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    downloadedVideos.clear();
    selectedVideoIds.clear();
    super.onClose();
  }
}

