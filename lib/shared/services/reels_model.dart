import 'package:dio/dio.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/reels/getx/reels_list_provider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelsModel extends GetxController {
  VideoPlayerController controller;
  ReelsListProvider reelsListProvider;
  RxList<VideoModel> videosList = RxList<VideoModel>();
  int prevVideo = 0;
  int currentPlatingVideoIndex = 0;
  Map<int, List<VideoPlayerController>> controllers = {};
  Map<int, String> controllersErrorMessages = {};
  String nextUrl = "https://dualite.xyz/api/v1/videos/";
  bool isLoading = false;
  int actualScreen = 0;
  @override
  void onClose() { // called just before the Controller is deleted from memory
    disposeResources();
    super.onClose();
  }
  disposeResources(){
    for(var v in controllers.keys) {
      List<VideoPlayerController> videoPlayers=controllers[v];
      if(videoPlayers.isNotEmpty) {
        final VideoPlayerController _controller = controllers[v][0];
        final VideoPlayerController _controller2 = controllers[v][1];

        /// Dispose controller
        _controller.setVolume(0.0);
        _controller2.setVolume(0.0);
      }
    }
    update();
  }
  @override
  void onInit() {
    reelsListProvider = ReelsListProvider(dio: Dio());
    reelsListProvider.getVideosList(
      "https://dualite.xyz/api/v1/videos/",
      onSuccess: (posts) {
        if (posts.results.isNotEmpty) {
          videosList.addAll(posts.results.where((e) => e.type == "DUALITE"));
          nextUrl = posts.next;
          currentPlatingVideoIndex = 0;
          if(posts.results.length>0) {
            _initializeControllerAtIndex(0).then((value) {
              if(posts.results.length>1) {
                _initializeControllerAtIndex(1).then((value) {
                  isLoading=false;
                  update();
                });
              }else{
                isLoading=false;
                update();
              }
            });
          }
        }
      },
      onError: (error) {
        isLoading = false;
        update();
        print("Error");
      },
    );
    super.onInit();
  }

  void _playNext(int index) {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    List<VideoPlayerController> videoPlayers=controllers[index];
    if(videoPlayers.isEmpty)
      playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    List<VideoPlayerController> videoPlayers=controllers[index];
    if(videoPlayers.isEmpty)
      playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    if (videosList.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController _controller =
          VideoPlayerController.network(videosList[index].contentOne,videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true
          ));


      final VideoPlayerController _controller2 =
      VideoPlayerController.network(videosList[index].contentTwo,videoPlayerOptions: VideoPlayerOptions(
    mixWithOthers: true
    ));
      _controller.initialize().then((value){
        if(_controller.value.duration==null || _controller.value.duration==Duration(seconds: 0)){
          controllers[index]=[];
          controllersErrorMessages[index]="First Videos are blank.";
        }
        else{
          _controller2.initialize().then((value){
            if(_controller2.value.duration==null || _controller2.value.duration==Duration(seconds: 0)){
              controllers[index]=[];
              controllersErrorMessages[index]="Second Videos are blank.";
            }
            else {
              _controller.setLooping(true);
              _controller2.setLooping(true);

              /// Add to [controllers] list
              controllers[index] = [_controller, _controller2];
            }
          });
        }
      });
    }
  }

  void playControllerAtIndex(int index)async {
    if (videosList.length > index && index >= 0) {
      /// Get controller at [index]
      if(controllers[index]==null){
        await _initializeControllerAtIndex(index);
      }
      List<VideoPlayerController> videoPlayers=controllers[index];
      if(videoPlayers.isNotEmpty) {
        final VideoPlayerController _controller = controllers[index][0];
        final VideoPlayerController _controller2 = controllers[index][1];

        /// Play controller
        _controller.seekTo(Duration(seconds: 0));
        _controller2.seekTo(Duration(seconds: 0));
        _controller.setVolume(1.0);
        _controller.play();
        _controller2.play();

      }
      currentPlatingVideoIndex = index;
    }
  }

  void _stopControllerAtIndex(int index) {
    if (videosList.length > index && index >= 0) {
      /// Get controller at [index]
      ///
      List<VideoPlayerController> videoPlayers=controllers[index];
      if(videoPlayers.isNotEmpty) {
        final VideoPlayerController _controller = controllers[index][0];
        final VideoPlayerController _controller2 = controllers[index][1];

        /// Pause
        _controller.pause();
        _controller2.pause();

        /// Reset postiton to beginning
        _controller.seekTo(const Duration());
        _controller2.seekTo(const Duration());
      }
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (videosList.length > index && index >= 0) {
      /// Get controller at [index]
      if(controllers[index].isNotEmpty) {
        final VideoPlayerController _controller = controllers[index][0];
        final VideoPlayerController _controller2 = controllers[index][1];

        /// Dispose controller
        _controller.dispose();
        _controller2.dispose();
      }
      controllers.remove(index);
      controllersErrorMessages.remove(index);

    }
  }

  onVideoIndexChanged(int index) async {
    if (index > currentPlatingVideoIndex) {
      _playNext(index);
    } else {
      _playPrevious(index);
    }
    update();
  }
}
