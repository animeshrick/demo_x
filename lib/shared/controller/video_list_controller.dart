import 'package:dualites/modules/authentication/authentication_controller.dart';
import 'package:dualites/modules/home/widgets/models/video_list.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/getx/video_load_state.dart';
import 'package:dualites/modules/reels/models/video_controller_model.dart';
import 'package:dualites/shared/controller/video_list_provider.dart';
import 'package:dualites/shared/widgets/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoListController extends GetxController {
  List<VideoModel> videosList = [];
  List<VideoModel> usersVideos = [];
  List<VideoModel> searchVideos = [];
  VideoControllerModel videoControllerModel = new VideoControllerModel();
  bool isLoading = true;
  bool nextLoading = false;
  String errorMessage = "";
  String nextUrl = 'https://dualite.xyz/api/v1/videos';
  String fetchUserVideos = 'https://dualite.xyz/api/v1/profile/videos';
  String nextSearchUrl = 'https://dualite.xyz/api/v1/videos/search?title=';
  VideoListProvider videoListProvider;
  VideoPlayerController playerController1, playerController2;
  VideoListController({this.videoListProvider});
  final _videoStateStream = VideoLoadState().obs;
  VideoModel videoModel;
  VideoLoadState get state => _videoStateStream.value;
  initializeState() {
    _videoStateStream.value = VideoLoadState();
  }

  @override
  void onInit() {
    VideoListProvider().getVideosList(
      nextUrl,
      onSuccess: (posts) {
        videosList.addAll(posts.results);
        searchVideos = videosList;
        nextUrl = posts.next;
        isLoading = false;
        update();
      },
      onError: (error) {
        isLoading = false;
        update();
        print("Error");
      },
    );
    super.onInit();
  }

  getNextVideosList() {
    VideoListProvider().getVideosList(
      nextUrl,
      onSuccess: (posts) {
        videosList.addAll(posts.results);
        nextUrl = posts.next;
        nextLoading = false;
        update();
      },
      beforeSend: () {
        nextLoading = true;
        update();
      },
      onError: (error) {
        nextLoading = false;
        update();
        print("Error");
      },
    );
  }

  getVideosBasedOnCategory(String tagName) {
    VideoListProvider().getVideosList(
      "https://dualite.xyz/api/v1/tags/videos/?tag="+tagName,
      onSuccess: (posts) {
        videosList.addAll(posts.results);
        nextUrl = posts.next;
        nextLoading = false;
        update();
      },
      beforeSend: () {
        nextLoading = true;
        update();
      },
      onError: (error) {
        nextLoading = false;
        update();
        print("Error");
      },
    );
  }

  getVideosFromSearchQuery(String title) {
    searchVideos = [];
    nextLoading = true;
    update();
    VideoListProvider().getVideosListFromSearchQuery(
      nextSearchUrl,
      title,
      onSuccess: (posts) {
        searchVideos.addAll(posts.results);
        nextSearchUrl = posts.next;
        nextLoading = false;
        update();
      },
      beforeSend: () {
        nextLoading = true;
        update();
      },
      onError: (error) {
        nextLoading = false;
        update();
        print("Error");
      },
    );
  }

  void getVideoInfoById(int id) async {
    isLoading = true;
    final dynamic response = await videoListProvider
        .getVideoDetail("https://dualite.xyz/api/v1/videos/$id");
    if (response is VideoModel) {
      videoModel = response;
      isLoading = false;
      update();
    }
  }

  void deleteVideoById(int id, BuildContext context) async {
    _videoStateStream.value = VideoDeletedInProgressState();
    isLoading = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = preferences.getString("key");
    final dynamic response = await videoListProvider.deleteVideo(
        "https://dualite.xyz/api/v1/videos/$id/", key);
    if (response is bool) {
      _videoStateStream.value = VideoDeletedResponseState();
      Navigator.pop(context, true);
      AuthenticationController authenticationController = Get.find();
      getVideosModel();
      Get.snackbar("Success", "Video is Deleted",
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
    } else {
      _videoStateStream.value = VideoDeletedResponseState();
      Navigator.pop(context, false);
      Get.snackbar("Error", response,
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void getVideosModel() async {
    isLoading = true;
    update();
    usersVideos = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("key");
    dynamic response =
        await videoListProvider.getUserVideos(fetchUserVideos, token);

    if (response is VideosList) {
      usersVideos.addAll(response.results);
    } else {
      errorMessage = response;
    }
    isLoading = false;
    update();
  }

  initializeVideoControllerAndPlayVideo(double height, String videoUrl) {
    Get.defaultDialog(
        content: Container(
          height: height,
          child: VideoPlayerWidget(
            videoPlayerController: VideoPlayerController.network(videoUrl),
            looping: false,
            autoplay: true,
          ),
        ),
        title: "");
  }

  void likeVideo(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = preferences.getString("key");
    dynamic response = await videoListProvider.likeVideo(
        "https://dualite.xyz/api/v1/videos/${id}/like/", key);
    if (response is bool) {
      Get.snackbar("Success", "Thanks For Liking",
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
      _videoStateStream.value = VideoLikedState(isLiked: true);
    } else {
      Get.snackbar("Error", response.toString(),
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      _videoStateStream.value = VideoLikedState(isLiked: false);
    }
  }

  updateState() {
    _videoStateStream.value = VideoLoadState();
  }
}
